module Model = Model__auth
module Usermail = Usermail__auth
module Require = Require__auth
module Session = Session__auth
module Service = Service__auth
module View = View__auth
open Require.Syntax

let (_ : unit Lwt.t) =
  Admin_module.attach
    ~is_visible:(fun () -> Require.Permission.(session_check superuser))
    "Auth"
    Service.Admin.main

let login =
  let$ () = Require.unauthenticated in
  fun next (username, password) ->
    let username = String.strip username in
    match%lwt Model.User.find_by_username username with
    | None ->
        let%lwt () = Toast.push @@ View.Toast.non_existent_user () in
        Content.redirection (Eliom_service.preapply ~service:Service.connection next)
    | Some user ->
        if Model.User.verify_password user password then
          let%lwt () = Session.login user in
          let srv_next =
            Option.value_map
              ~default:Skeleton.home_service
              ~f:Service_helpers.Subpath.get_service
              next
          in
          let%lwt () = Toast.push @@ View.Toast.login_success () in
          Content.redirection srv_next
        else
          let%lwt () = Toast.push @@ View.Toast.incorrect_password () in
          Content.redirection (Eliom_service.preapply ~service:Service.connection next)

let logout =
  let$ _user = Require.authenticated in
  fun () () -> Content.action Session.logout ()

let connection =
  let$ () = Require.unauthenticated in
  fun next () -> View.Page.connection ~next ()

let forbidden () () = View.Page.forbidden ()

module Settings = struct
  let main =
    let$ user = Require.authenticated in
    fun () () -> View.Page.settings user

  let save_email =
    let$ user = Require.authenticated in
    fun () new_email ->
      let new_email = String.strip new_email in
      if String.(new_email = Model.User.email user) then
        let%lwt () = Toast.push (View.Toast.email_is_the_same ()) in
        Content.reload ()
      else
        match%lwt Model.User.update_email (Model.User.id user) new_email with
        | Ok () ->
            let () =
              Usermail.send_async
                ~user
                ~forced_address:new_email
                ~subject:"Modification de votre adresse email"
                ~content:
                  "Votre adresse email a bien été modifiée. Si vous n'êtes pas à \
                   l'origine de cette demande, veuillez contacter immédiatement \
                   l'administrateur du site."
                ()
            in
            let%lwt () = Toast.push (View.Toast.email_successfully_changed ()) in
            Content.reload ()
        | Error `Email_already_exists ->
            let%lwt () = Toast.push (View.Toast.email_not_available ()) in
            Content.reload ()

  let save_password =
    let$ user = Require.authenticated in
    fun () new_password ->
      let%lwt () = Model.User.update_password (Model.User.id user) new_password in
      let () =
        Usermail.send_async
          ~user
          ~subject:"Modification de votre mot de passe"
          ~content:
            "Votre mot de passe a bien été modifié. Si vous n'êtes pas à l'origine de \
             cette demande, veuillez contacter immédiatement l'administrateur du site."
          ()
      in
      Content.action Toast.push (View.Toast.password_successfully_changed ())

  let forgotten_password =
    let$ () = Require.unauthenticated in
    fun () () -> View.Page.forgotten_password ()

  let request_password_token =
    let$ () = Require.unauthenticated in
    fun () email ->
      let email = String.strip email in
      match%lwt Model.User.find_by_email email with
      | None ->
          let%lwt () = Toast.push @@ View.Toast.non_existent_email () in
          Content.redirection Service.Settings.forgotten_password
      | Some user ->
          let%lwt token = Model.Password_token.create (Model.User.id user) in
          let reset_uri =
            Eliom_uri.make_string_uri
              ~absolute:true
              ~service:Service.Settings.password_reset
              token
          in
          let forgotten_password_uri =
            Eliom_uri.make_string_uri
              ~absolute:true
              ~service:Service.Settings.forgotten_password
              ()
          in
          let () =
            Usermail.send_async
              ~user
              ~subject:"Réinitialisation de votre mot de passe"
              ~content:
                (Fmt.str
                   "Vous recevez ce message parce qu'une réinitialisation de votre mot \
                    de passe a été demandée sur notre site. @.@.ATTENTION : si vous \
                    n'avez pas effectué personnellement cette demande, veuillez ignorer \
                    et effacer cet email immédiatement ! @.@.Si vous souhaitez \
                    effectivement réinitialiser votre mot de passe, cliquez sur le lien \
                    suivant ou recopiez le dans votre navigateur : %s @.@.Remarque : le \
                    formulaire associé n'est valable que pendant une heure à compter de \
                    l'envoi de cet email. Passé ce délai, vous devrez effectuer une \
                    nouvelle demande à l'adresse suivante : %s"
                   reset_uri
                   forgotten_password_uri)
              ()
          in
          View.Page.password_token_requested ()

  let password_reset =
    let$ () = Require.unauthenticated in
    fun token () -> View.Page.password_reset token

  let validate_password_reset =
    let$ () = Require.unauthenticated in
    fun token password ->
      match%lwt Model.Password_token.validate_password_reset token ~password with
      | Error (`Token_absent_or_expired | `Unexpected) ->
          View.Page.failed_password_reset ()
      | Ok user_id ->
          let%lwt user = Model.User.find_exn user_id in
          let%lwt () = Session.login user in
          let () =
            Usermail.send_async
              ~user
              ~subject:"Votre mot de passe a été réinitialisé"
              ~content:
                "Votre mot de passe vient d'être réinitialisé avec succès sur notre \
                 site. Si vous n'êtes pas à l'origine de cette demande, veuillez \
                 contacter immédiatement un administrateur. Nous vous conseillons \
                 également de changer sans délai le mot de passe de votre compte email \
                 qui pourrait être compromis."
              ()
          in
          View.Page.successful_password_reset ()
end

module Admin = struct
  let main =
    let$ _user = Require.superuser in
    fun () () ->
      let%lwt all_users = Model.User.all () in
      View.Page.admin_main all_users

  let user_creation =
    let$ _user = Require.superuser in
    fun () () -> View.Page.user_creation ()

  let user_edition =
    let$ _user = Require.superuser in
    fun id () ->
      let%lwt user = Model.User.find_or_404 id in
      View.Page.user_edition user

  let create_user =
    let$ _user = Require.superuser in
    fun () (username, (email, (password, (is_superuser, is_staff)))) ->
      let username = String.strip username in
      let email = String.strip email in
      match%lwt Model.User.create ~username ~email ~password ~is_superuser ~is_staff with
      | Ok new_user ->
          let () =
            Usermail.send_async
              ~user:new_user
              ~subject:"Création de votre compte"
              ~content:
                "Votre compte vient d'être créé sur notre site. Si vous pensez qu'il \
                 s'agit d'une erreur, veuillez contacter l'administrateur du site."
              ()
          in
          let%lwt () = Toast.push (View.Toast.user_created new_user) in
          Content.redirection Service.Admin.main
      | Error errors ->
          let%lwt () =
            Lwt_list.iter_p (fun e -> Toast.push @@ View.Toast.conflict e) errors
          in
          Content.reload ()

  let update_user =
    let$ _user = Require.superuser in
    fun id (username, (email, (password, (is_superuser, is_staff)))) ->
      let username = String.strip username in
      let email = String.strip email in
      match%lwt
        Model.User.update id ~username ~email ?password ~is_superuser ~is_staff ()
      with
      | Ok model ->
          let%lwt () = Toast.push (View.Toast.user_updated model) in
          Content.redirection Service.Admin.main
      | Error errors ->
          let%lwt () =
            Lwt_list.iter_p (fun e -> Toast.push @@ View.Toast.conflict e) errors
          in
          Content.reload ()

  let delete_user =
    let$ _user = Require.superuser in
    fun () id ->
      let%lwt item = Model.User.find_and_delete id in
      let%lwt () = Toast.push (View.Toast.user_deleted item) in
      Content.reload ()
end
