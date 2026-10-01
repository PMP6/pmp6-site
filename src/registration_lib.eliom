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

let register_one_route return_page service content =
  Eliom_registration.Any.register ~service (fun gp pp ->
      Content.send_lwt return_page @@ content gp pp)

let rec register_routes return_page routes =
  match routes with
  | [] -> ()
  | (service, handler) :: tail ->
      register_one_route return_page service handler;
      register_routes return_page tail

let register_one_legacy_redirect (old_path, target_service) =
  let old_service =
    Eliom_service.create
      ~path:(Eliom_service.Path (old_path @ [ "" ]))
      ~meth:(Eliom_service.Get Eliom_parameter.unit)
      ()
  in
  Eliom_registration.Redirection.register
    ~options:`MovedPermanently
    ~service:old_service
    (fun () () -> Lwt.return (Eliom_registration.Redirection target_service))

let register_legacy_redirects redirects =
  List.iter ~f:register_one_legacy_redirect redirects
