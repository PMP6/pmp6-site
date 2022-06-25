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
    let%lwt () = Toast.push @@ View.Toast.login_required () in
    Content.redirection
      (Eliom_service.preapply
         ~service:Service.connection
         (Option.try_with Eliom_request_info.get_current_sub_path))

  let forbidden _gp _pp =
    Content.redirection Service.forbidden

  let already_connected _gp _pp =
    View.Page.already_connected ()

end

module Permission : sig

  type t

  val make : (Model.User.t -> bool) -> t

  val check : t -> Model.User.t -> bool

  (* Always return false if unauthenticated *)
  val session_check : t -> bool Lwt.t

  val authenticated : t

  val superuser : t

  val staff : t

end
=
struct

  type t = Model.User.t -> bool

  let make f = f

  let check perm user =
    perm user ||
    Model.User.is_superuser user

  let session_check perm =
    match%map.Lwt Session.get_user () with
    | None -> false
    | Some user -> check perm user

  let authenticated = make (Fn.const true)

  let superuser = make (Fn.const false)

  let staff = make Model.User.is_staff

end

let has_permission perm handler =
  Eliom_tools.wrap_handler
    Session.get_user
    Fallback.login_required
    (fun user gp pp ->
       if Permission.check perm user
       then handler user gp pp
       else Fallback.forbidden gp pp)

let authenticated handler = has_permission Permission.authenticated handler

let superuser handler = has_permission Permission.superuser handler

let staff handler = has_permission Permission.staff handler

let unauthenticated handler =
  Eliom_tools.wrap_handler
    Session.get_unauthenticated
    Fallback.already_connected
    handler
