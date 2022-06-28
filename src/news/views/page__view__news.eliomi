module Model = Model__news

val list_all : Model.t list -> Content.page

val redaction : unit -> Content.page

val edition : Model.t -> Content.page
