module Model = Model__auth

let current_user_id : Model.User.Id.t option Eliom_reference.eref =
  Eliom_reference.eref ~scope:Eliom_common.default_session_scope None

let login_id id = Eliom_reference.set current_user_id (Some id)
let login user = login_id (Model.User.id user)
let logout () = Eliom_state.discard ~scope:Eliom_common.default_session_scope ()

let find_or_logout id =
  (* If the user doesn't exist (maybe he got deleted while his session was active, or some
     strange error happened), then logout as a defensive measure. *)
  match%lwt Model.User.find id with
  | None ->
      let%lwt () = logout () in
      Lwt.return None
  | Some user -> Lwt_option.return user

let get_user () =
  let%bind.Lwt_option id = Eliom_reference.get current_user_id in
  find_or_logout id

let get_unauthenticated () =
  match%lwt get_user () with Some _ -> Lwt.return None | None -> Lwt.return (Some ())

module Private = struct
  let login_id = login_id
end
