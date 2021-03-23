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

type 'a request_result = ('a, Caqti_error.t) result Lwt.t

let exn caqti_error =
  Caqti_error.Exn caqti_error

let or_exn result =
  Result.ok_exn @@
  Result.map_error ~f:exn result

let connection_uri =
  "sqlite3:/home/thibault/pmp6-site/pmp6_test.db"

let pool =
  Caqti_lwt.connect_pool ~max_size:10 (Uri.of_string connection_uri)
  |> Result.map_error ~f:Caqti_error.show
  |> Result.ok_or_failwith

let run request =
  Caqti_lwt.Pool.use request pool

let get_all make_item output_type query =
  let request =
    Caqti_request.collect Caqti_type.unit output_type query in
  let execute_request (module C : Caqti_lwt.CONNECTION) =
    C.fold request (fun result acc -> make_item result :: acc) () [] in
  run execute_request

let get_one make_item input_type input output_type query =
  let request =
    Caqti_request.find input_type output_type query in
  let execute_request (module C : Caqti_lwt.CONNECTION) =
    C.find request input in
  run execute_request
  |> Lwt_result.map make_item

let get_one_opt make_item input_type input output_type query =
  let request =
    Caqti_request.find_opt input_type output_type query in
  let execute_request (module C : Caqti_lwt.CONNECTION) =
    C.find_opt request input in
  run execute_request
  |> Lwt_result.map (Option.map ~f:make_item)

let exec input_type input query =
  let request =
    Caqti_request.exec input_type query in
  let execute_request (module C : Caqti_lwt.CONNECTION) =
    C.exec request input in
  run execute_request
