module H = Html

type div_content = Html_types.div_content_fun H.elt list

type kind =
  | Primary
  | Secondary
  | Success
  | Warning
  | Alert

let kind_to_class = function
  | Primary -> "primary"
  | Secondary -> "secondary"
  | Success -> "success"
  | Warning -> "warning"
  | Alert -> "alert"

type t = {
  kind : kind;
  content : div_content;
}

let kind x = x.kind
let content x = x.content

let render { kind; content } =
  H.div
    ~a:[H.a_class ["callout"; kind_to_class kind]; H.a_user_data "closable" ""]
    (H.close_button () :: content)

(* Low-level closures *)
let (_all, _push) =
  let messages =
    Eliom_reference.eref ~scope:Eliom_common.request_scope [] in
  let all () =
    Eliom_reference.get messages
  in
  let push msg =
    let%lwt all = all () in
    Eliom_reference.set messages (msg :: all)
  in
  (all, push)

let all () = _all ()

let push kind content =
  _push { kind; content }

let push_primary content =
  push Primary content

let push_secondary content =
  push Secondary content

let push_success content =
  push Success content

let push_warning content =
  push Warning content

let push_alert content =
  push Alert content

let render_all () =
  let%lwt all = all () in
  Lwt.return @@ List.map ~f:render all

let simple_message msg =
  [H.p [H.txt msg]]

let push_primary_msg msg =
  push_primary (simple_message msg)

let push_secondary_msg msg =
  push_secondary (simple_message msg)

let push_success_msg msg =
  push_success (simple_message msg)

let push_warning_msg msg =
  push_warning (simple_message msg)

let push_alert_msg msg =
  push_alert (simple_message msg)
