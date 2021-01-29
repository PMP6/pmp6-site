module Handler = News__handler
module Service = News__service

let register_with (module App : Eliom_registration.APP) () =
  let module Handler = Handler.Make (App) in
  let ( => ) service page =
    App.register ~service page in
  Service.main => Handler.list_all;
  ()
