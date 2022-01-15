module H = Html

type div_content := Html_types.div_content_fun H.elt list

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

val simple_message : string -> div_content

val push_primary : div_content -> unit Lwt.t
val push_secondary : div_content -> unit Lwt.t
val push_success : div_content -> unit Lwt.t
val push_warning : div_content -> unit Lwt.t
val push_alert : div_content -> unit Lwt.t

val push_primary_msg : string -> unit Lwt.t
val push_secondary_msg : string -> unit Lwt.t
val push_success_msg : string -> unit Lwt.t
val push_warning_msg : string -> unit Lwt.t
val push_alert_msg : string -> unit Lwt.t
