module Model = News__model

val list_all : Model.t list -> [> Html_types.html ] Html.elt Lwt.t

val redaction : unit -> [> Html_types.html ] Html.elt Lwt.t
