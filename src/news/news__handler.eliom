module Model = News__model
module View = News__view

open Lwt.Infix

let list_all () () =
  Model.get_all_exn () >>=
  View.Page.list_all

let delete id () =
  match%lwt Model.delete_and_return id with
  | Ok news ->
    let%lwt () = Toast.push Toast.Success (View.Widget.Deletion_toast.success news) in
    Lwt.return ()
  | Error e ->
    let%lwt () = Toast.push Toast.Alert (View.Widget.Deletion_toast.error e) in
    Lwt.return ()
