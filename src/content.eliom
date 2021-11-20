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

let page ?(in_head=[]) ~title in_body =
  Lwt.return @@ Page { title; in_head; in_body }

let redirection srv =
  Lwt.return @@ Redirection srv
