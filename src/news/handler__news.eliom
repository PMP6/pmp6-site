module Model = Model__news
module View = View__news

open Lwt.Infix
open Auth.Require.Syntax

module Admin = struct

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
    fun () (title, (short_title, (content, is_visible))) ->
      let content = Doc.of_md content in
      let%lwt model = Model.create ~title ~short_title ~content ~author ~is_visible in
      Content.action Toast.push (View.Toast.created model)

  let edition =
    let$ _user = Auth.Require.staff in
    fun id () ->
      let%lwt news = Model.find id in
      View.Page.edition news

  let update =
    let$ user = Auth.Require.staff in
    let author = Auth.Model.User.id user in
    fun () (id, (update_pubtime, (title, (short_title, (content, is_visible))))) ->
      let content = Doc.of_md content in
      let pub_time =
        if update_pubtime
        then Some (Time.now ())
        else None in
      let%lwt model =
        Model.update id ~title ~short_title ?pub_time ~content ~author ~is_visible () in
      Content.action Toast.push (View.Toast.updated model)

  let delete =
    let$ _user = Auth.Require.staff in
    fun () id ->
      let%lwt item = Model.find_and_delete id in
      Content.action Toast.push (View.Toast.deleted item)

end
