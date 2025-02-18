module Model = Model__news
module H = Html

val article_ : Model.t -> [> Html_types.article ] H.elt

val redaction_form : ?news:Model.t -> unit -> [> Html_types.form ] H.elt
(** If [news] is passed, this will be an edition form, otherwise a redaction one. *)

val button_to_redaction :
  ?expanded:bool -> unit -> [> [> Html_types.txt ] Html_types.a ] H.elt

val news_tabs :
  ?vertical:bool ->
  ?show_actions:bool ->
  Model.t list ->
  [> Html_types.div ] H.elt * [> Html_types.div ] H.elt
(** Returns a (titles, contents) pair *)
