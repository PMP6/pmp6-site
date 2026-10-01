[%%server.start]

type routes =
  | [] : routes
  | ( :: ) :
      (( 'get,
         'post,
         _,
         _,
         _,
         Eliom_service.non_ext,
         Eliom_service.reg,
         _,
         _,
         _,
         Eliom_service.non_ocaml )
       Eliom_service.t
      * ('get -> 'post -> _ Eliom_registration.kind Content.t Lwt.t))
      * routes
      -> routes

val register_routes : (Content.page_components -> Html.doc Lwt.t) -> routes -> unit

(** Register permanent HTTP 301 redirections from legacy paths to target services. *)
val register_legacy_redirects :
  (string list
  * ( unit,
      unit,
      Eliom_service.get,
      _,
      _,
      _,
      _,
      [ `WithoutSuffix ],
      unit,
      unit,
      Eliom_service.non_ocaml )
    Eliom_service.t)
  list ->
  unit
