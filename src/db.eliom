module type C = Caqti_lwt.CONNECTION

let caqti_exn caqti_error =
  Caqti_error.Exn caqti_error

let connection_uri =
  Settings.db_uri

module Type = struct
  (* Utilities over Caqti_type *)
  include Caqti_type

  type _ field +=
    | Time : Time.t field

  let time_coding =
    (* Store times as a timestamp *)
    let rep = Int in
    let encode time =
      Ok (
        int_of_float @@
        Time.Span.to_sec @@
        Time.to_span_since_epoch time
      ) in
    let decode timestamp =
      Ok (
        Time.of_span_since_epoch @@
        Time.Span.of_sec @@
        float_of_int timestamp
      ) in
    Field.Coding { rep; encode; decode }

  let get_coding : type a. _ -> a field -> a Field.coding =
    fun driver_info field -> match field with
      | Time -> time_coding
      | field -> Option.value_exn (Field.coding driver_info field)

  let () =
    Caqti_type.Field.define_coding Time { get_coding }

  let time =
    field Time

  let ( & ) = tup2

  module Tlist = Hlist.Make (Caqti_type)

  let rec hlist : type a. a Tlist.t -> a Hlist.t t = function
    | [] ->
      custom
        ~encode:(fun Hlist.[] -> Ok ())
        ~decode:(fun () -> Ok [])
        unit
    | t :: ts ->
      custom
        ~encode:(fun Hlist.(x :: xs) -> Ok (x, xs))
        ~decode:(fun (x, xs) -> Ok (x :: xs))
        (tup2 t (hlist ts))

end

module Dyn_param = struct

  type t = Pack : 'a Type.t * 'a * string list -> t

  let add typ value field (Pack (types, repr, fields)) =
    Pack (Type.tup2 types typ, (repr, value), fields @ [ field ])

  let add_opt typ value_opt field dyn = match value_opt with
    | None -> dyn
    | Some value -> add typ value field dyn

  let empty = Pack (Caqti_type.unit, (), [])

  let sep_to_string = function
    | `And -> " AND "
    | `Or -> " OR "
    | `Comma -> ", "
    | `String str -> Fmt.str " %s " str
    | `Char chr -> Fmt.str " %c " chr

  (* todo better name than from? *)
  let to_columns ~sep ~starting_index names =
    let sep = sep_to_string sep in
    names
    |> List.mapi ~f:(fun i name -> Fmt.str "%s = $%d" name (i + starting_index))
    |> String.concat ~sep

end

type +'a m = (module C) -> ('a, Caqti_error.t) result Lwt.t

module R = Lwt_result

include Monad.Make (struct
    type 'a t = 'a m

    let return x =
      fun (module C : C) ->
      Lwt_result.return x
    (* Must give a name to `C` because `_` is too recent for some ppx *)
    [@@ocaml.warning "-unused-module"]

    let bind x ~f =
      fun (module C : C) ->
      let%bind.R r = x (module C : C) in
      f r (module C : C)

    let map x ~f =
      fun (module C : C) ->
      let%map.R r = x (module C : C) in
      f r

    let map = `Custom map
  end)

let enable_foreign_keys_pragma (module C : C) =
  C.exec (Caqti_request.exec ~oneshot:true Type.unit "PRAGMA foreign_keys = ON") ()

let check_foreign_keys_pragma (module C : C) =
  C.find
    (Caqti_request.find ~oneshot:true Type.unit Type.bool "PRAGMA foreign_keys")
    ()

let pool =
  Caqti_lwt.connect_pool
    ~max_size:10
    ~post_connect:enable_foreign_keys_pragma
    (Uri.of_string connection_uri)
  |> Result.map_error ~f:caqti_exn
  |> Result.ok_exn

let run_keep_errors request =
  Caqti_lwt.Pool.use request pool

let run request =
  let%lwt result = run_keep_errors request in
  Caqti_lwt.or_fail result

let check_foreign_keys () =
  run check_foreign_keys_pragma

let unit = Type.unit, ()

let collect ~in_:(input_type, input) ~out:(output_type, make_item) query =
  fun (module C : C) ->
  let%map.R items =
    C.fold
      (Caqti_request.collect input_type output_type query)
      (fun result acc -> make_item result :: acc)
      input [] in
  List.rev items

let collect_all ~out query =
  collect ~in_:unit ~out query

let find ~in_:(input_type, input) ~out:(output_type, make_item) query =
  fun (module C : C) ->
  let%map.R result =
    C.find
      (Caqti_request.find input_type output_type query)
      input in
  make_item result

let find_opt ~in_:(input_type, input) ~out:(output_type, make_item) query =
  fun (module C : C) ->
  let%map.R result =
    C.find_opt
      (Caqti_request.find_opt input_type output_type query)
      input in
  Option.map ~f:make_item result

let exec ~in_:(input_type, input) query =
  fun (module C : C) ->
  C.exec
    (Caqti_request.exec input_type query)
    input

let exec_with_affected_count ~in_:(input_type, input) query =
  fun (module C : C) ->
  C.exec_with_affected_count
    (Caqti_request.exec input_type query)
    input

let with_transaction request =
  fun (module C : C) ->
  let%bind.R () = C.start () in
  let%lwt result = request (module C : C) in
  match result with
  | Ok answer ->
    let%bind.R () = C.commit () in
    Lwt_result.return answer
  | Error e ->
    let%bind.R () = C.rollback () in
    Lwt_result.fail e
