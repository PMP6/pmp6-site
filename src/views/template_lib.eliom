type page = {
  title : string;
  in_head : Html_types.head_content_fun Html.elt list;
  in_body : Html_types.main_content_fun Html.elt list;
}

let page ?(in_head=[]) ~title in_body =
  Lwt.return { title; in_head; in_body }
