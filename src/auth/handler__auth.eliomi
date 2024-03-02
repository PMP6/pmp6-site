module Model := Model__auth

val login : Service_helpers.Subpath.t option -> string * string -> Content.page
val logout : unit -> unit -> Content.action
val connection : Service_helpers.Subpath.t option -> unit -> Content.page
val forbidden : unit -> unit -> Content.page

module Settings : sig
  val main : unit -> unit -> Content.page
  val save_email : unit -> string -> Content.action
  val save_password : unit -> string -> Content.action
  val forgotten_password : unit -> unit -> Content.page
  val request_password_token : unit -> string -> Content.page
  val password_reset : Secret.Token.t -> unit -> Content.page
  val validate_password_reset : Secret.Token.t -> string -> Content.page
end

module Admin : sig
  val main : unit -> unit -> Content.page
  val user_creation : unit -> unit -> Content.page
  val user_edition : Model.User.Id.t -> unit -> Content.page
  val create_user : unit -> string * (string * (string * (bool * bool))) -> Content.action

  val update_user :
    Model.User.Id.t ->
    string * (string * (string option * (bool * bool))) ->
    Content.action

  val delete_user : unit -> Model.User.Id.t -> Content.action
end
