module type C = Caqti_lwt.CONNECTION

let caqti_exn caqti_error =
  Caqti_error.Exn caqti_error

let connection_uri =
  "sqlite3:/home/thibault/pmp6-site/pmp6_test.db"

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

let pool =
  Caqti_lwt.connect_pool ~max_size:10 (Uri.of_string connection_uri)
  |> Result.map_error ~f:caqti_exn
  |> Result.ok_exn

let run request =
  let%lwt result = Caqti_lwt.Pool.use request pool in
  Caqti_lwt.or_fail result

let collect ~out:(output_type, make_item) query =
  fun (module C : C) ->
  C.fold
    (Caqti_request.collect Caqti_type.unit output_type query)
    (fun result acc -> make_item result :: acc)
    () []

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

let transaction request =
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
