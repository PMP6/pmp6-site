[%%server.start]

module Lwr = Lwt_result

module type C = Caqti_lwt.CONNECTION

let caqti_exn caqti_error = Caqti_error.Exn caqti_error
let connection_uri = Settings.db_uri

module Type = struct
  (* Utilities over Caqti_type *)
  include Caqti_type

  let time =
    (* Store times as a timestamp *)
    (* TODO: it would be nicer to use Ptime instead (especially when manipulating the
       database directly). This would require a db migration though. *)
    let encode time =
      Ok (int_of_float @@ Time.Span.to_sec @@ Time.to_span_since_epoch time)
    in
    let decode timestamp =
      Ok (Time.of_span_since_epoch @@ Time.Span.of_sec @@ float_of_int timestamp)
    in
    custom ~encode ~decode int

  let ( & ) = t2

  module Tlist = Hlist.Make (Caqti_type)

  let rec hlist : type a. a Tlist.t -> a Hlist.t t = function
    (* Note: newer versions of Caqti may have easier ways of defining this type and/or
       find an alternative. This would need to be tested against migration. *)
    | [] -> custom ~encode:(fun Hlist.[] -> Ok ()) ~decode:(fun () -> Ok []) unit
    | t :: ts ->
        custom
          ~encode:(fun Hlist.(x :: xs) -> Ok (x, xs))
          ~decode:(fun (x, xs) -> Ok (x :: xs))
          (t2 t (hlist ts))
end

module Dyn_param = struct
  type t = Pack : 'a Type.t * 'a * string list -> t

  let add typ value field (Pack (types, repr, fields)) =
    Pack (Type.t2 types typ, (repr, value), fields @ [ field ])

  let add_opt typ value_opt field dyn =
    match value_opt with None -> dyn | Some value -> add typ value field dyn

  let empty = Pack (Caqti_type.unit, (), [])

  let sep_to_string = function
    | `And -> " AND "
    | `Or -> " OR "
    | `Comma -> ", "
    | `String str -> Fmt.str " %s " str
    | `Char chr -> Fmt.str " %c " chr

  let to_columns ~sep ~starting_index names =
    let sep = sep_to_string sep in
    names
    |> List.mapi ~f:(fun i name -> Fmt.str "%s = $%d" name (i + starting_index))
    |> String.concat ~sep
end

type +'a m = (module C) -> ('a, Caqti_error.t) result Lwt.t

include Monad.Make (struct
  type 'a t = 'a m

  let return x (module C : C) = Lwr.return x
  (* Must give a name to `C` because `_` is too recent for some ppx *)
  [@@ocaml.warning "-unused-module"]

  let bind x ~f (module C : C) =
    let%bind.Lwr r = x (module C : C) in
    f r (module C : C)

  let map x ~f (module C : C) =
    let%map.Lwr r = x (module C : C) in
    f r

  let map = `Custom map
end)

let enable_foreign_keys_pragma (module C : C) =
  C.exec
    (Caqti_request.Infix.(Type.unit ->. Type.unit)
       ~oneshot:true
       "PRAGMA foreign_keys = ON")
    ()

let check_foreign_keys_pragma (module C : C) =
  C.find
    (Caqti_request.Infix.(Type.unit ->! Type.bool) ~oneshot:true "PRAGMA foreign_keys")
    ()

let pool =
  let pool_config = Caqti_pool_config.(default_from_env () |> set max_size 10) in
  Caqti_lwt_unix.connect_pool
    ~pool_config
    ~post_connect:enable_foreign_keys_pragma
    (Uri.of_string connection_uri)
  |> Result.map_error ~f:caqti_exn
  |> Result.ok_exn

let run_keep_errors request = Caqti_lwt_unix.Pool.use request pool

let run request =
  let%lwt result = run_keep_errors request in
  Caqti_lwt.or_fail result

let check_foreign_keys () = run check_foreign_keys_pragma

module Infix_request = struct
  (** Wrappers around both Caqti_request infix operators and functions from a Connection
      module. *)

  module Caq = Caqti_request.Infix

  let ( ->. ) ?oneshot in_t out_t request in_ (module C : C) =
    C.exec (Caq.(in_t ->. out_t) ?oneshot request) in_

  let ( ->.& ) ?oneshot in_t out_t request in_ (module C : C) =
    (* exec_with_affected_count. Raises on `Unsupported error. *)
    match%bind.Lwt
      C.exec_with_affected_count (Caq.(in_t ->. out_t) ?oneshot request) in_
    with
    | (Ok _ | Error #Caqti_error.call_or_retrieve) as result -> Lwt.return result
    | Error `Unsupported -> Lwt.fail_with "Unsupported"

  let ( ->* ) ?oneshot in_t out_t request in_ (module C : C) =
    C.collect_list (Caq.(in_t ->? out_t) ?oneshot request) in_

  let ( ->? ) ?oneshot in_t out_t request in_ (module C : C) =
    C.find_opt (Caq.(in_t ->? out_t) ?oneshot request) in_

  let ( ->! ) ?oneshot in_t out_t request in_ (module C : C) =
    C.find (Caq.(in_t ->! out_t) ?oneshot request) in_
end

let check_affected_count_is_supported () =
  let%map.Lwt (_ : int) =
    run (Infix_request.(Type.unit ->.& Type.unit) "SELECT 1 WHERE 0" ())
  in
  ()

let with_transaction request (module C : C) =
  (* TODO: modern Caqti connection C has a function to do that. Check types to adapt
     it. *)
  let%bind.Lwr () = C.start () in
  let%lwt result = request (module C : C) in
  match result with
  | Ok answer ->
      let%bind.Lwr () = C.commit () in
      Lwr.return answer
  | Error e ->
      let%bind.Lwr () = C.rollback () in
      Lwr.fail e
