module Model = Model__news

val list_all : Model.t list -> Content.t Lwt.t

val redaction : unit -> Content.t Lwt.t

val edition : Model.t -> Content.t Lwt.t
