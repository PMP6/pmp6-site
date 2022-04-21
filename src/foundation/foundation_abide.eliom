module H = Html

let span_form_error ?(a=[]) content =
  H.span ~a:(H.a_class ["form-error"] :: a) content

let form_error ?a txt =
  span_form_error ?a [H.txt txt]

let required () = H.a_required ()

let equalto ~id = H.a_user_data "equalto" id

(* Form should also have xhr:false *)
let form_attribs () =
  [ H.a_user_data "abide" ""; H.a_novalidate () ]

let post_form ?(a=[]) =
  H.Form.post_form
    ~xhr:false (* Mandatory to go through Abide form validation *)
    ~a:(a @ form_attribs ())

(* Error div for the whole form *)
let abide_error content =
  Foundation_callout.alert
    ~a:[
      H.a_user_data "abide-error" "";
      H.a_style "display: none";
    ]
    content
