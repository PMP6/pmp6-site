type%shared t = string

let of_md source = source

let to_md doc = doc

let to_html doc =
  Html.parse @@
  Omd.to_html @@
  Omd.of_string doc

let to_div ?a doc =
  Html.div ?a (to_html doc)

let form_param = Html.Form.string

let db_type = Db.Type.string

let param = Eliom_parameter.string

let render_from_md =
  Eliom_client.server_function
    [%json:string]
    (fun str -> Lwt.return @@ to_html @@ of_md str)

let%client render_from_md str =
  ~%render_from_md str
