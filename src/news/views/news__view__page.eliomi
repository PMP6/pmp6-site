module Model = News__model

val list_all : Model.t list -> Html.doc Lwt.t

val redaction : unit -> Html.doc Lwt.t

val edition : Model.t -> Html.doc Lwt.t
