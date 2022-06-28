module Model := Model__auth

val get_user : unit -> Model.User.t option Lwt.t

val login : Model.User.t -> unit Lwt.t

val logout : unit -> unit Lwt.t

(** A pseudo-get that returns Some () is there is no authenticated
    user. Can be useful for service wrappers that require this type. *)
val get_unauthenticated : unit -> unit option Lwt.t

module Private : sig

  val login_id : Model.User.Id.t -> unit Lwt.t

end
