type page_components = {
  title : string;
  in_head : Html_types.head_content_fun Html.elt list;
  in_body : Html_types.main_content_fun Html.elt list;
}

type _ t =
  | Page : page_components -> Pmp6.App.result t
  | Redirection :
      ( unit,
        unit,
        Eliom_service.get,
        _,
        _,
        _,
        _,
        [ `WithoutSuffix ],
        unit,
        unit,
        _ )
      Eliom_service.t
      -> _ Eliom_registration.kind t
  | Unit : Eliom_registration.Action.result t

type page = Pmp6.App.result t Lwt.t
type action = Eliom_registration.Action.result t Lwt.t

let page ?(in_head = []) ~title in_body = Lwt.return @@ Page { title; in_head; in_body }
let redirection srv = Lwt.return (Redirection srv)
let reload () = redirection Eliom_service.reload_action

(* Force type variable to prevent weak type variables issues *)
let action_reload () : action = reload ()
let unit () = Lwt.return Unit

let action f arg =
  let%lwt () = f arg in
  unit ()

let send : type result. _ -> result t -> result Lwt.t =
 fun return_page content ->
  match content with
  | Page page ->
      let%lwt doc = return_page page in
      Pmp6.App.send doc
  | Redirection srv -> Eliom_registration.Redirection.(send @@ Redirection srv)
  | Unit -> Eliom_registration.Action.send ()

let send_lwt return_page content =
  let%lwt content = content in
  send return_page content
