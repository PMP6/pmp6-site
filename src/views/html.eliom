(* Various Html utilities *)
[%%shared.start]

include Eliom_content.Html.D

let div_classes classes ?(a=[]) =
  div ~a:(a_class classes :: a)

let div_class class_ =
  div_classes [class_]

let id_to_href id =
  let href () = Printf.sprintf "#%s" id in
  a_href (uri_of_string href)

let anchor_a ?(a=[]) ~anchor =
  Raw.a ~a:(id_to_href anchor :: a)

let mailto_a address ?(a=[]) =
  let mailto () =
    Printf.sprintf "mailto:%s" address in
  Raw.a ~a:(
    a_class ["email"] ::
    a_target "_blank" ::
    a_href (uri_of_string mailto) ::
    a
  )

let email address ?(a=[]) () =
  mailto_a address ~a [txt address]

let js_script uri ?(a=[]) () =
  (* H.js_script generates unneeded "type=text/javascript" attribute,
     which triggers a warning on HTML validation *)
  script ~a:(a_src uri :: a) (txt "")
