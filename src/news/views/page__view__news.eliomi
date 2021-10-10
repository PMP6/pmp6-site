module Model = Model__news

val list_all : Model.t list -> Template_lib.page Lwt.t

val redaction : unit -> Template_lib.page Lwt.t

val edition : Model.t -> Template_lib.page Lwt.t
