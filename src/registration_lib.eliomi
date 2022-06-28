[%%server.start]

type routes =
  | [] : routes
  | ( :: ) :
      (('get, 'post, _, _, _, Eliom_service.non_ext, Eliom_service.reg,
        _, _, _, Eliom_service.non_ocaml)
         Eliom_service.t *
       ('get -> 'post -> _ Eliom_registration.kind Content.t Lwt.t)) *
      routes ->
      routes

val register_routes : (Content.page_components -> Html.doc Lwt.t) -> routes -> unit
