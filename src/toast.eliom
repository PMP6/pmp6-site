module H = Html

type div_content = Html_types.div_content_fun H.elt list

type t = {
  color : Foundation.Color.t;
  content : div_content;
}

let color x = x.color
let content x = x.content

let create color content = { color; content }

let primary = create Primary
let secondary = create Secondary
let success = create Success
let warning = create Warning
let alert = create Alert

let msg color msg = create color [ H.p [ H.txt msg ] ]

let primary_msg = msg Primary
let secondary_msg = msg Secondary
let success_msg = msg Success
let warning_msg = msg Warning
let alert_msg = msg Alert

let render { color; content } =
  Foundation.Callout.create ~color ~closable:true (H.close_button () :: content)

let (fetch, push) =
  let messages =
    Eliom_reference.eref ~scope:Eliom_common.default_session_scope [] in
  let fetch () =
    let%lwt result = Eliom_reference.get messages in
    let%lwt () = Eliom_reference.set messages [] in
    Lwt.return result
  in
  let push msg =
    Eliom_reference.modify messages (List.cons msg)
  in
  (fetch, push)

let fetch_and_render () =
  let%lwt all = fetch () in
  Lwt.return @@ List.map ~f:render all

let create_and_push color content =
  create color content |> push

let push_primary = create_and_push Primary
let push_secondary = create_and_push Secondary
let push_success = create_and_push Success
let push_warning = create_and_push Warning
let push_alert = create_and_push Alert

let push_msg color msg_ = push (msg color msg_)

let push_primary_msg = push_msg Primary
let push_secondary_msg = push_msg Secondary
let push_success_msg = push_msg Success
let push_warning_msg = push_msg Warning
let push_alert_msg = push_msg Alert
