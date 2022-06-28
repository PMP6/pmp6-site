type service :=
  (unit, unit, Eliom_service.get, Eliom_service.att, Eliom_service.non_co,
   Eliom_service.non_ext, Eliom_service.reg, [ `WithoutSuffix ], unit,
   unit, Eliom_service.non_ocaml)
    Eliom_service.t

type t

val name : t -> string

val service : t -> service

val all_visible : unit -> t list Lwt.t

(** [is_visible] is only an information to be used to avoid displaying
    modules which will require higher permission to action. One should
    never rely on it to actually enforce permissions. *)
val attach : ?is_visible:(unit -> bool Lwt.t) -> string -> service -> unit Lwt.t

module Private : sig

  val all : unit -> t list Lwt.t

end
