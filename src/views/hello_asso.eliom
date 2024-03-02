module H = Html

let make_service path =
  Eliom_service.(
    extern
      ~prefix:"https://www.helloasso.com"
      ~path:("associations" :: "assu-sim-section-plongee" :: path)
      ~meth:(Eliom_service.Get Eliom_parameter.unit)
      ())

let main_service () = make_service []
let make_uri path = H.make_uri ~service:(make_service path) ()

let pay_widget item_name =
  let uri = make_uri [ "paiements"; item_name; "widget-bouton" ] in
  let open H in
  iframe ~a:[ a_src uri; a_style "border: none;" ] []

let event_widget event_name =
  let uri = make_uri [ "evenements"; event_name; "widget" ] in
  let open H in
  iframe ~a:[ a_src uri; a_style "width: 100%; height: 750px; border: none" ] []
