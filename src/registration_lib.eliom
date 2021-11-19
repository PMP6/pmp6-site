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
  val pages : Template_lib.page service_handlers
  val actions : unit service_handlers
  val redirections : Eliom_service.non_ocaml Eliom_registration.redirection service_handlers
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

let register_page ~service return_page page =
  Pmp6.App.register
    ~service
    (fun gp pp ->
       let%lwt page = page gp pp in
       return_page page)

let register_pages return_page pages =
  register_handlers
    { f = fun service page -> register_page ~service return_page page }
    pages

let register_actions actions =
  register_handlers
    { f = fun service action -> Eliom_registration.Action.register ~service action }
    actions

let register_redirections redirections =
  register_handlers
    { f = fun service redirection ->
        Eliom_registration.Redirection.register ~service redirection }
    redirections

let register_module return_page (module M : Module) =
  register_pages return_page M.pages;
  register_actions M.actions;
  register_redirections M.redirections;
  ()
