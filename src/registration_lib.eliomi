type redirection := Eliom_service.non_ocaml Eliom_registration.redirection

type _ service_handlers =
  | [] : _ service_handlers
  | ( :: ) :
      (('get, 'post, _, _, _, Eliom_service.non_ext, Eliom_service.reg,
        _, _, _, Eliom_service.non_ocaml)
         Eliom_service.t *
       ('get -> 'post -> 'result Lwt.t)) *
      'result service_handlers ->
      'result service_handlers

module type Module = sig
  val contents : Content.t service_handlers
  val actions : unit service_handlers
end

type 'result registrar =
  {
    f : 'get 'post 'scope 'm 'att 'co 'suffix 'gn 'pn.
          ('get, 'post, 'm, 'att, 'co, Eliom_service.non_ext, Eliom_service.reg,
           ([< `WithSuffix | `WithoutSuffix ] as 'suffix), 'gn, 'pn, Eliom_service.non_ocaml)
        Eliom_service.t ->
      ('get -> 'post -> 'result Lwt.t) -> unit
  }

val register_handlers : 'result registrar -> 'result service_handlers -> unit

val register_contents : (Content.page -> Html.doc Lwt.t) -> Content.t service_handlers -> unit

val register_actions : unit service_handlers -> unit

val register_module : (Content.page -> Html.doc Lwt.t) -> (module Module) -> unit
