module%client Js = Js_of_ocaml.Js

(* Various Html utilities *)
[%%shared.start]

include Eliom_content.Html.D

let class_ cls = a_class [ cls ]

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

let new_id =
  let module Id = Unique_id.Int () in
  fun () ->
    let id = Id.create () in
    "pmp6__auto__" ^ Id.to_string id

module Confirmation_modal : sig

  (** Build elements that go through a confirmation modal to trigger
      Some (action) service.

      [with_modal ~service text f gp pp pp_form_param] will generate
      a modal displaying [text], that upon confirmation will trigger
      the action registered at the [POST] [service]. The service may
      accept some GET parameters [gp] and one POST parameter [pp] that
      will be passed to it; [pp] will be passed through an hidden
      [input] and typed using [pp_form_param]. The function will use
      [f] to build its result -- typically, an element or a list of
      elements. [f] has access to the modal element itself, and should
      add it at the proper place (see Foundation's documentation). It
      also has access to a [opens_modal] HTML attribute that can be
      used on the elements that should trigger the modal -- typically,
      links or buttons.

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
            () (* get delete service parameter *)
            id_of_the_element (* post delete service parameter *)
            (Form.user id_to_string)
      ]}

      The building function mechanism, similarly to Forms, allows here to have
      a modal opened by a deeply nested [a] element, while being placed in an
      outermost position to abide by HTML rules.
  *)

  val with_modal :
    service:('gp, 'pp, Eliom_service.post, _, _, _, _,
             [< `WithSuffix | `WithoutSuffix ], _,
             [< 'pp Eliom_parameter.setoneradio ] Eliom_parameter.param_name,
             Eliom_service.non_ocaml)
        Eliom_service.t ->
    string ->
    (opens_modal:[> `User_data ] attrib -> [> Html_types.div ] elt -> 'result) ->
    'gp -> 'pp -> 'pp Form.param -> 'result

end
=
struct

  let modal_elt target_srv gp pp pp_form_param text modal_id =
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

          Form.post_form
            ~service:target_srv
            (fun pp_name ->
               [
                 Form.input
                   ~input_type:`Hidden
                   ~name:pp_name
                   ~value:pp
                   pp_form_param;

                 button ~a:[
                   a_class ["button"];
                   a_aria "label" ["Confirmer"];
                   a_button_type `Submit;
                 ] [txt "Confirmer"];
               ])
            gp;

        ];
        close_button ();
      ]

  let with_modal ~service text make_elem gp pp pp_form_param =
    let modal_id = new_id () in
    let opens_modal = a_user_data "open" modal_id in
    make_elem ~opens_modal (modal_elt service gp pp pp_form_param text modal_id)
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

(* Currently this does not allow post parameters. Use this with
   (possibly dynamically created) unit post services. This could be
   extended to support post parameters but that would probably go in
   another function as it involves a bit of plumbing (cf. Modal). *)
let split_post_pseudo_link ~service content gp =
  let id = new_id () in
  let button =
    Form.button_no_value ~a:[ class_ "link"; a_form id ] ~button_type:`Submit content in
  Form.post_form ~service ~a:[ a_id id ] (fun () -> []) gp,
  button

let post_pseudo_link ~service content gp =
  let form, button = split_post_pseudo_link ~service content gp in
  div [ form; button ]

[%%server.start]

let pp_elt =
  Eliom_content.Html.Printer.pp_elt

let elt_to_string elt =
  Fmt.str "%a" (pp_elt ()) elt
