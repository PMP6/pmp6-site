module Model = News__model
module H = Html

val article_ : Model.t -> [> Html_types.article ] H.elt

val news_tabs :
  ?vertical:bool ->
  Model.t list ->
  [> Html_types.ul ] H.elt

val news_tabs_content :
  ?vertical:bool ->
  ?display_action_icons:bool ->
  Model.t list ->
  [> Html_types.div ] H.elt
