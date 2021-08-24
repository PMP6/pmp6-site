module Model = Model__news
module View = View__news

open Lwt.Infix

let list_all () () =
  Model.all () >>=
  View.Page.list_all

let redaction () () =
  View.Page.redaction ()

let create () (title, (short_title, content)) =
  let content = Html.Unsafe.data content in
  let%lwt model = Model.create ~title ~short_title ~content in
  Toast.push Toast.Success (View.Toast.Creation.success model)

let edition id () =
  let%lwt news = Model.find id in
  View.Page.edition news

let update () (id, (title, (short_title, content))) =
  let content = Html.Unsafe.data content in
  let%lwt model = Model.update_as_new id ~title ~short_title ~content in
  Toast.push Toast.Success (View.Toast.Update.success model)

let delete () id =
  let%lwt item = Model.find_and_delete id in
  Toast.push Toast.Success (View.Toast.Deletion.success item)
