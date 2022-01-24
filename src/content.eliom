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

let redirection ?action srv =
  match action with
  | None -> Lwt.return (Redirection srv)
  | Some action ->
    (* Return a redirection to a dynamically created service, that
       will run the action and will fallback to the destination
       service srv. This allows redirections that do not break the
       request scope after executing the actions (useful for instance
       for toasts).  *)
    let tmp_srv =
      Eliom_registration.Action.create_attached_get
        ~get_params:Eliom_parameter.unit
        ~fallback:srv
        ~max_use:1
        (fun () () -> action ()) in
    Lwt.return (Redirection tmp_srv)

