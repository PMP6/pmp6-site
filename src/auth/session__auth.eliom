module Model = Model__auth

let current_user_id : Model.User.Id.t option Eliom_reference.eref =
  Eliom_reference.eref ~scope:Eliom_common.default_session_scope None

let get_user () =
  Lwt_option.bind_lwt ~f:Model.User.find (Eliom_reference.get current_user_id)

let login user =
  Eliom_reference.set current_user_id (Some (Model.User.id user))

let logout () =
  Eliom_state.discard ~scope:Eliom_common.default_session_scope ()

let get_unauthenticated () =
  match%lwt Eliom_reference.get current_user_id with
  | Some _ -> Lwt.return None
  | None -> Lwt.return (Some ())
