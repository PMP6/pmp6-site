module Model = Model__auth
module Usermail = Usermail__auth
module Require = Require__auth
module Session = Session__auth
module Service = Service__auth
module View = View__auth

open Require.Syntax

let login =
  let$ () = Require.unauthenticated in
  fun next (username, password) ->
    match%lwt Model.User.find_by_username username with
    | None ->
      Content.redirection
        ~action:(fun () -> Toast.push @@ View.Toast.non_existent_user ())
        (Eliom_service.preapply ~service:Service.connection next)
    | Some user ->
      if Model.User.verify_password user password
      then
        let%lwt () = Session.login user in
        let srv_next =
          Option.value_map ~default:Skeleton.home_service ~f:Utils.path_srv next in
        Content.redirection
          ~action:(fun () -> Toast.push @@ View.Toast.login_success ())
          srv_next
      else
        Content.redirection
          ~action:(fun () -> Toast.push @@ View.Toast.incorrect_password ())
          (Eliom_service.preapply ~service:Service.connection next)

let logout =
  let$ _user = Require.authenticated in
  fun () () ->
    Content.action Session.logout ()

let connection =
  let$ () = Require.unauthenticated in
  fun next () ->
    View.Page.connection ~next ()

let forbidden () () =
  View.Page.forbidden ()

module Settings = struct

  let email_edition =
    let$ user = Require.authenticated in
    fun () () ->
      View.Page.email_edition user

  let save_email =
    let$ user = Require.authenticated in
    fun () new_email ->
      if String.(new_email = Model.User.email user)
      then Content.action Toast.push (View.Toast.email_is_the_same ())
      else
        match%lwt Model.User.update_email (Model.User.id user) new_email with
        | Ok () ->
          let () =
            Usermail.send_async
              ~user
              ~forced_address:new_email
              ~subject:"Modification de votre adresse email"
              ~content:
                "Votre adresse email a bien été modifiée. Si vous \
                 n'êtes pas à l'origine de cette demande, veuillez \
                 contacter l'administrateur du site."
              ()
          in
          Content.action Toast.push (View.Toast.email_successfully_changed ())
        | Error `Email_already_exists ->
          Content.action Toast.push (View.Toast.email_not_available ())

end
