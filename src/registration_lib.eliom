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
    f : 'get 'post 'm 'att 'co 'suffix 'gn 'pn.
          ('get, 'post, 'm, 'att, 'co, Eliom_service.non_ext, Eliom_service.reg,
           ([< `WithSuffix | `WithoutSuffix ] as 'suffix), 'gn, 'pn, Eliom_service.non_ocaml)
        Eliom_service.t ->
      ('get -> 'post -> 'result Lwt.t) -> unit
  }

let rec register_handlers :
  type result. result registrar -> result service_handlers -> unit =
  fun register service_handlers -> match service_handlers with
    | [] -> ()
    | (service, handler) :: tail ->
      register.f service handler;
      register_handlers register tail

let register_content ~service return_page content =
  Eliom_registration.Any.register
    ~service
    (fun gp pp ->
       match%lwt content gp pp with
       | Content.Page page ->
         let%lwt doc = return_page page in
         Pmp6.App.send doc
       | Content.Redirection srv ->
         Eliom_registration.Redirection.(send @@ Redirection srv))

let register_contents return_page pages =
  register_handlers
    { f = fun service page -> register_content ~service return_page page }
    pages

let register_actions actions =
  register_handlers
    { f = fun service action -> Eliom_registration.Action.register ~service action }
    actions

let register_module return_page (module M : Module) =
  register_contents return_page M.contents;
  register_actions M.actions;
  ()
