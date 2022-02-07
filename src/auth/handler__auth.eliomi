val login : Eliom_lib.Url.path option -> string * string -> Content.t Lwt.t

val logout : unit -> unit -> Content.t Lwt.t

val connection : Eliom_lib.Url.path option -> unit -> Content.t Lwt.t

val forbidden : unit -> unit -> Content.t Lwt.t

module Settings : sig

  val email_edition : unit -> unit -> Content.t Lwt.t

  val save_email : unit -> string -> Content.t Lwt.t

  val forgotten_password : unit -> unit -> Content.t Lwt.t

  val request_password_token : unit -> string -> Content.t Lwt.t

  val password_reset : Secret.Token.t -> unit -> Content.t Lwt.t

  val validate_password_reset : Secret.Token.t -> string -> Content.t Lwt.t

end
