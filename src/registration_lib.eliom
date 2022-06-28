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

let register_one_route return_page service content =
  Eliom_registration.Any.register
    ~service
    (fun gp pp -> Content.send_lwt return_page @@ content gp pp)

let rec register_routes return_page routes = match routes with
    | [] -> ()
    | (service, handler) :: tail ->
      register_one_route return_page service handler;
      register_routes return_page tail
