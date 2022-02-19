type page = {
  title : string;
  in_head : Html_types.head_content_fun Html.elt list;
  in_body : Html_types.main_content_fun Html.elt list;
}

type t =
  | Page : page -> t
  | Redirection :
      (unit, unit, Eliom_service.get, _, _, _, _,
       [ `WithoutSuffix ], unit, unit, _) Eliom_service.t ->
      t
  | Unit : t

let page ?(in_head=[]) ~title in_body =
  Lwt.return @@ Page { title; in_head; in_body }

let redirection srv =
  Lwt.return (Redirection srv)

let unit =
  Lwt.return Unit

let action f arg =
  let%lwt () = f arg in
  Lwt.return Unit

let send return_page content =
  match%lwt content with
  | Page page ->
    let%lwt doc = return_page page in
    Pmp6.App.send doc
  | Redirection srv ->
    Eliom_registration.Redirection.(send @@ Redirection srv)
  | Unit ->
    Eliom_registration.(appl_self_redirect Action.send ())
