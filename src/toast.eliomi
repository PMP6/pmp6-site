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

val push_primary_msg : string -> unit Lwt.t
val push_secondary_msg : string -> unit Lwt.t
val push_success_msg : string -> unit Lwt.t
val push_warning_msg : string -> unit Lwt.t
val push_alert_msg : string -> unit Lwt.t

val fetch : unit -> t list Lwt.t

val render : t -> [> Html_types.div ] H.elt
val fetch_and_render : unit -> [> Html_types.div ] H.elt list Lwt.t
