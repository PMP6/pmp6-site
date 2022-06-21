type t = string

let of_md source = source

let to_md doc = doc

let to_html doc =
  Html.parse @@
  Omd.to_html @@
  Omd.of_string doc

let to_html_string doc =
  Html.elt_to_string @@ to_html doc

let form_param = Html.Form.string

let db_type = Db.Type.string

let param = Eliom_parameter.string
