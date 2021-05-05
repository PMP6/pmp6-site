module Model = News__model
module View = News__view

open Lwt.Infix

let list_all () () =
  Model.get_all_exn () >>=
  View.Page.list_all

let redaction () () =
  View.Page.redaction ()

let create () (title, (short_title, content)) =
  let content = Html.Unsafe.data content in
  match%lwt Model.create_now_and_return ~title ~short_title ~content with
  | Ok model ->
    Toast.push Toast.Success (View.Toast.Creation.success model)
  | Error e ->
    Lwt.fail (Caqti_error.Exn e)

let delete () id =
  match%lwt Model.delete_and_return id with
  | Ok item ->
    let%lwt () = Toast.push Toast.Success (View.Toast.Deletion.success item) in
    Lwt.return ()
  | Error e ->
    let%lwt () = Toast.push Toast.Alert (View.Toast.Deletion.error e) in
    Lwt.return ()
