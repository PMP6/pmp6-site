module Model := Model__auth

val login : Eliom_lib.Url.path option -> string * string -> Content.page

val logout : unit -> unit -> Content.action

val connection : Eliom_lib.Url.path option -> unit -> Content.page

val forbidden : unit -> unit -> Content.page

module Settings : sig

  val email_edition : unit -> unit -> Content.page

  val save_email : unit -> string -> Content.action

  val forgotten_password : unit -> unit -> Content.page

  val request_password_token : unit -> string -> Content.page

  val password_reset : Secret.Token.t -> unit -> Content.page

  val validate_password_reset : Secret.Token.t -> string -> Content.page

end

module Admin : sig

  val main : unit -> unit -> Content.page

  val user_creation : unit -> unit -> Content.page

  val user_edition : Model.User.Id.t -> unit -> Content.page

  val create_user : unit -> (string * (string * (string * (bool * (bool))))) -> Content.action

  val update_user :
    Model.User.Id.t ->
    string * (string * (string option * (bool * bool))) ->
    Content.action

end
