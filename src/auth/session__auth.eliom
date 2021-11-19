module Model = Model__auth

let current_user : Model.User.t option Eliom_reference.eref =
  Eliom_reference.eref ~scope:Eliom_common.default_session_scope None

let get_user () =
  Eliom_reference.get current_user

let login user =
  Eliom_reference.set current_user (Some user)

let logout () =
  Eliom_state.discard ~scope:Eliom_common.default_session_scope ()
