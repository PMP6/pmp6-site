module%client Js = Js_of_ocaml.Js

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

let%client format_datetime time =
  let time_value = Time.(Span.to_ms @@ to_span_since_epoch time) in
  let _ = Moment.locale (Js.string "fr") in
  let open Moment in
  let m = new%js moment_fromTimeValue time_value in
  let today = new%js moment in
  let yesterday = new%js moment in yesterday##subtract 1. (Js.string "days");
  let isSameDay m1 m2 = Js.to_bool (m1##isSame_withUnit m2 (Js.string "day")) in
  if isSameDay m today
  then m##fromNow |> Js.to_string |> String.capitalize
  else if isSameDay m yesterday
  then m##format_withFormat (Js.string "[Hier à] H[h]mm") |> Js.to_string
  else m##format_withFormat (Js.string "[Le] Do MMMM Y à H[h]mm") |> Js.to_string

let time_ ?(a=[]) time_ =
  let datetime =
    Time.to_string_abs_trimmed
      ~zone:(Time.Zone.of_utc_offset ~hours:2) @@
    Time.prev_multiple
      ~before:time_
      ~base:Time.epoch
      ~interval:Time.Span.minute
      ~can_equal_before:true (* For good measure, only useful is s=ms=ns=0 *)
      () in
  let attr = a_datetime datetime :: a in
  Eliom_content.Html.C.node
    ~init:(time ~a:attr [txt datetime])
    [%client (time ~a:~%attr [txt @@ format_datetime ~%time_])]

[%%server.start]

let pp_elt =
  Eliom_content.Html.Printer.pp_elt

let elt_to_string elt =
  Fmt.str "%a" (pp_elt ()) elt
