let run_all () =
  Lwt.join [
    Fixtures__news.run ();
  ]

let service =
  Eliom_service.create
    ~path:(Eliom_service.Path ["fixtures"])
    ~meth:(Eliom_service.Get Eliom_parameter.unit)
    ()

let () =
  Eliom_registration.Html_text.register
    ~service
    (fun () () ->
       let%lwt () = run_all () in
       Lwt.return "Fixtures loaded!")
