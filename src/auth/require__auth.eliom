module Model = Model__auth
module Service = Service__auth
module Session = Session__auth
module View = View__auth

module Syntax = struct

  let ( let$ ) require handler =
    require handler

end

module Fallback = struct

  let login_required _gp _pp =
    Content.redirection
      ~action:(fun () -> Toast.push Toast.Warning (View.Toast.login_required ()))
      (Eliom_service.preapply
         ~service:Service.connection
         (Option.try_with Eliom_request_info.get_current_sub_path))

  let forbidden _gp _pp =
    Content.redirection Service.forbidden

  let already_connected _gp _pp =
    View.Page.already_connected ()

end

let auth_with_predicate perm handler =
  Eliom_tools.wrap_handler
    Session.get_user
    Fallback.login_required
    (fun user gp pp ->
       if perm user
       then handler user gp pp
       else Fallback.forbidden gp pp)

let has_permission perm handler =
  auth_with_predicate
    (fun user -> perm user || Model.User.is_superuser user)
    handler

let authenticated handler = has_permission (Fn.const true) handler

let superuser handler = has_permission (Fn.const false) handler

let staff handler = has_permission Model.User.is_staff handler

let unauthenticated handler =
  Eliom_tools.wrap_handler
    Session.get_unauthenticated
    Fallback.already_connected
    handler
