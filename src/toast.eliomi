module H = Html

type div_content := Html_types.div_content_fun H.elt list

type t

val color : t -> Foundation.Color.t
val content : t -> div_content

val create : Foundation.Color.t -> div_content -> t

val primary : div_content -> t
val secondary : div_content -> t
val success : div_content -> t
val warning : div_content -> t
val alert : div_content -> t

val msg : Foundation.Color.t -> string -> t

val primary_msg : string -> t
val secondary_msg : string -> t
val success_msg : string -> t
val warning_msg : string -> t
val alert_msg : string -> t

val push : t -> unit Lwt.t
val create_and_push : Foundation.Color.t -> div_content -> unit Lwt.t

val push_primary : div_content -> unit Lwt.t
val push_secondary : div_content -> unit Lwt.t
val push_success : div_content -> unit Lwt.t
val push_warning : div_content -> unit Lwt.t
val push_alert : div_content -> unit Lwt.t

val push_msg : Foundation.Color.t -> string -> unit Lwt.t

val push_primary_msg : string -> unit Lwt.t
val push_secondary_msg : string -> unit Lwt.t
val push_success_msg : string -> unit Lwt.t
val push_warning_msg : string -> unit Lwt.t
val push_alert_msg : string -> unit Lwt.t

val all : unit -> t list Lwt.t

val render : t -> [> Html_types.div ] H.elt
val render_all : unit -> [> Html_types.div ] H.elt list Lwt.t
