module Model = Model__news
module View = View__news

open Lwt.Infix
open Auth.Require.Syntax

let list_all =
  let$ _user = Auth.Require.staff in
  fun () () ->
    Model.all () >>=
    View.Page.list_all

let redaction =
  let$ _user = Auth.Require.staff in
  fun () () ->
    View.Page.redaction ()

let create =
  let$ user = Auth.Require.staff in
  let author = Auth.Model.User.id user in
  fun () (title, (short_title, content)) ->
  let content = Html.Unsafe.data content in
  let%lwt model = Model.create ~title ~short_title ~content ~author in
  Content.action Toast.push_success (View.Toast.Creation.success model)

let edition =
  let$ _user = Auth.Require.staff in
  fun id () ->
  let%lwt news = Model.find id in
  View.Page.edition news

let update =
  let$ user = Auth.Require.staff in
  let author = Auth.Model.User.id user in
  fun () (id, (title, (short_title, content))) ->
  let content = Html.Unsafe.data content in
  let%lwt model = Model.update_as_new id ~title ~short_title ~content ~author in
  Content.action Toast.push_success (View.Toast.Update.success model)

let delete =
  let$ _user = Auth.Require.staff in
  fun () id ->
  let%lwt item = Model.find_and_delete id in
  Content.action Toast.push_success (View.Toast.Deletion.success item)
