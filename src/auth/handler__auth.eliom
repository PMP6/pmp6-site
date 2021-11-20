module Model = Model__auth
module Session = Session__auth
module Service = Service__auth
module View = View__auth

let login () (username, password) =
  match%lwt Model.User.find_by_username username with
  | None ->
    Content.redirection_with_action
      (fun () -> Toast.push Toast.Alert (View.Toast.non_existent_user ()))
      Service.connection
  | Some user ->
    if Model.User.verify_password user password
    then
      let%lwt () = Session.login user in
      Content.redirection_with_action
        (fun () -> Toast.push Toast.Success (View.Toast.login_success ()))
        Skeleton.home_service
    else
      Content.redirection_with_action
      (fun () -> Toast.push Toast.Alert (View.Toast.incorrect_password ()))
      Service.connection

let logout () () =
  Session.logout ()

let connection () () =
  match%lwt Session.get_user () with
  | None ->
    View.Page.connection ()
  | Some _ ->
    View.Page.already_connected ()

let forbidden () () =
  View.Page.forbidden ()
