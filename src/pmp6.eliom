[%%shared
    open Eliom_lib
    open Eliom_content
    open Html.D
]

module Pmp6_app =
  Eliom_registration.App (
    struct
      let application_name = "pmp6"
      let global_data_path = None
    end)

let main_service =
  Eliom_service.create
    ~path:(Eliom_service.Path [])
    ~meth:(Eliom_service.Get Eliom_parameter.unit)
    ()

let () =
  Pmp6_app.register
    ~service:main_service
    (fun () () ->
      Lwt.return
        (Eliom_tools.F.html
           ~title:"pmp6"
           ~css:[["css";"pmp6.css"]]
           Html.F.(body [
             h1 [pcdata "Welcome from Eliom's distillery!"];
           ])))
