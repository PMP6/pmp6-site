module Model = Model__auth
module Require = Require__auth
module Session = Session__auth
module Service = Service__auth
module View = View__auth

open Require.Syntax

let login next (username, password) =
  match%lwt Model.User.find_by_username username with
  | None ->
    Content.redirection_with_action
      (fun () -> Toast.push Toast.Alert (View.Toast.non_existent_user ()))
      (Eliom_service.preapply ~service:Service.connection next)
  | Some user ->
    if Model.User.verify_password user password
    then
      let%lwt () = Session.login user in
      let srv_next =
        Option.value_map ~default:Skeleton.home_service ~f:Utils.path_srv next in
      Content.redirection_with_action
        (fun () -> Toast.push Toast.Success (View.Toast.login_success ()))
        srv_next
    else
      Content.redirection_with_action
      (fun () -> Toast.push Toast.Alert (View.Toast.incorrect_password ()))
      (Eliom_service.preapply ~service:Service.connection next)

let logout () () =
  Session.logout ()

let connection next () =
  match%lwt Session.get_user () with
  | None ->
    View.Page.connection ~next ()
  | Some _ ->
    View.Page.already_connected ()

let forbidden () () =
  View.Page.forbidden ()

module Settings = struct

  let email_edition =
    let$ user = Require.authenticated in
    fun () () ->
      View.Page.email_edition user

  let save_email =
    let& user = Require.authenticated in
    fun () new_email ->
      if String.(new_email = Model.User.email user)
      then Toast.push_secondary_msg "Cette adresse est identique à la précédente."
      else
        match%lwt Model.User.update_email (Model.User.id user) new_email with
        | Ok () ->
          Toast.push_success_msg "L'adresse email a bien été changée."
        | Error `Email_already_exists ->
          Toast.push_alert_msg "Cette adresse email est indisponible."

end
