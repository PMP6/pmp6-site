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

let close_button () =
  button
    ~a:[
      a_class ["close-button"];
      a_user_data "close" "";
      a_aria "label" ["Fermer"];
      a_button_type `Button;
    ]
    [span ~a:[a_aria "hidden" ["true"]] [txt "×"]]

module Confirmation_modal : sig

  (** Build elements that go through a confirmation modal to trigger
      some (action) service.

      [with_modal ~service text f params] will generate a modal
      displaying [text], that upon confirmation will trigger the
      action registered at [service]. It will use [f] to return its
      result -- typically, an element or a list of elements. [f] has
      access to the modal element itself, and should add it at the
      proper place (see Foundation's documentation). It also has
      access to a [opens_modal] HTML attribute that can be used on the
      elements that should trigger the modal -- typically, links or
      buttons.

      For instance, one could use a modal to delete an element by writing:

      {[
          Confirmation_modal.with_modal
            ~service:delete_an_element
            ("Are you sure you want to delete " ^ to_string the_element ^ "?")
            (fun ~opens_modal modal ->
               div [
                 p [
                   Raw.a
                     ~a:[opens_modal]
                     [txt @@ "Click me to delete " ^ to_string the_element]
                 ];
                 modal;
               ])
            (get_id_of the_element)
      ]}

      The building function mechanism, similarly to Forms, allows here to have
      a modal opened by a deeply nested [a] element, while being placed in an
      outermost position to abide by HTML rules.
  *)

  val with_modal :
    service:('gp, unit, Eliom_service.get, 'b, 'c, 'd, 'e,
             [< `WithSuffix | `WithoutSuffix ], 'f, unit, Eliom_service.non_ocaml)
        Eliom_service.t ->
    string ->
    (opens_modal:[> `User_data] attrib -> [> Html_types.div ] elt -> 'result) ->
    'gp ->
    'result

end
=
struct
  let create_id =
    let module Id = Unique_id.Int () in
    fun () ->
      let id = Id.create () in
      "confirmation-modal__" ^ Id.to_string id

  let modal_elt target_srv srv_param text modal_id =
    div
      ~a:[
        a_class ["reveal"];
        a_id @@ modal_id;
        a_user_data "reveal" "";
      ]
      [
        p [txt text];
        div_classes ["button-group"; "align-spaced"] [
          button
            ~a:[
              a_button_type `Button;
              a_class ["button"; "secondary"];
              a_user_data "close" "";
              a_aria "label" ["Annuler"];
            ]
            [txt "Annuler"];
          a
            ~a:[
              a_class ["button"];
              a_aria "label" ["Confirmer"];
            ]
            ~service:target_srv
            [txt "Confirmer"]
            srv_param;
        ];
        close_button ();
      ]

  let with_modal ~service text make_elem srv_param =
    let modal_id = create_id () in
    let opens_modal = a_user_data "open" modal_id in
    make_elem ~opens_modal (modal_elt service srv_param text modal_id)
end

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
