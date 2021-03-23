module H = Html

type div_content = Html_types.div_content_fun H.elt list

(** This shall be moved under a more generic Callout/Semantic palette later *)
type kind =
  | Primary
  | Secondary
  | Success
  | Warning
  | Alert

type t

val kind : t -> kind
val content : t -> div_content

val all : unit -> t list Lwt.t
val push : kind -> div_content -> unit Lwt.t

val render : t -> [> Html_types.div ] H.elt
val render_all : unit -> [> Html_types.div ] H.elt list Lwt.t
