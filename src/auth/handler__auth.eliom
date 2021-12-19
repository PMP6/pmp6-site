module Model = Model__auth
module Session = Session__auth
module Service = Service__auth
module View = View__auth

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
