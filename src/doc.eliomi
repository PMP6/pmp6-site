type t

val of_md : string -> t

val to_md : t -> string

val to_html : t -> 'a Html.elt

val to_html_string : t -> string

val form_param : t Eliom_content.Html.form_param

val db_type : t Db.Type.t

val param :
  string ->
  (t, [ `WithoutSuffix ],
   [ `One of t ] Eliom_parameter.param_name) Eliom_parameter.params_type
