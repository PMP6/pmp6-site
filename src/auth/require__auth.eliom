module Model = Model__auth
module Service = Service__auth
module Session = Session__auth
module View = View__auth

module Syntax = struct

  let ( let& ) require handler =
    require
      (fun _g _p -> Lwt.return ())
      (fun _g _p -> Lwt.return ())
      handler

  let ( let$ ) require handler =
    require
      (fun _g _p ->
         Content.redirection_with_action
           (fun () -> Toast.push Toast.Warning (View.Toast.login_required ()))
           (Eliom_service.preapply
              ~service:Service.connection
              (Option.try_with Eliom_request_info.get_current_sub_path)))
      (fun _g _p -> Content.redirection Service.forbidden)
      handler

end

let predicate perm no_login forbidden handler =
  Eliom_tools.wrap_handler
    Session.get_user
    no_login
    (fun user gp pp ->
       if perm user
       then handler user gp pp
       else forbidden gp pp)

let has_permission perm eta =
  predicate (fun user -> perm user || Model.User.is_superuser user) eta

let authenticated eta = has_permission (Fn.const true) eta

let superuser eta = has_permission (Fn.const false) eta

let staff eta = has_permission Model.User.is_staff eta
