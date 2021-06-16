module Model = Model__news
module H = Html

val article_ : Model.t -> [> Html_types.article ] H.elt

(** If [news] is passed, this will be an edition form, otherwise a redaction one. *)
val redaction_form : ?news:Model.t -> unit -> [> Html_types.form ] H.elt

val button_to_redaction :
  ?expanded:bool -> unit -> [> [> Html_types.txt ] Html_types.a ] H.elt

val news_tabs :
  ?vertical:bool ->
  Model.t list ->
  [> Html_types.ul ] H.elt

val news_tabs_content :
  ?vertical:bool ->
  ?display_action_icons:bool ->
  Model.t list ->
  [> Html_types.div ] H.elt
