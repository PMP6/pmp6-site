module Handler = News__handler
module Service = News__service

let register_with (module App : Eliom_registration.APP) () =
  let ( => ) service page =
    App.register ~service page in
  let ( @=> ) service page =
    Eliom_registration.Action.register ~service page in
  Service.main => Handler.list_all;
  Service.delete @=> Handler.delete;
  ()
