type t

val of_md : string -> t

val to_md : t -> string

val to_html : t -> [> Html_types.div_content ] Html.elt list

val to_div :
  ?a:[< Html_types.div_attrib ] Html.attrib list -> t -> [> Html_types.div ] Html.elt

val form_param : t Eliom_content.Html.form_param

val db_type : t Db.Type.t

val param :
  string ->
  (t, [ `WithoutSuffix ],
   [ `One of t ] Eliom_parameter.param_name) Eliom_parameter.params_type

(** Rendering is done on the server *)
val%client render_from_md : string -> [> Html_types.div_content ] Html.elt list Lwt.t
