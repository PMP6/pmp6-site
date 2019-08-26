module Pmp6_app =
  Eliom_registration.App (struct
    let application_name = "pmp6"
    let global_data_path = None
  end)

let ( => ) service page =
  Pmp6_app.register
    ~service
    (fun () () ->
       let _ = [%client (Foundation.init () : unit)] in
       Lwt.return @@ page ())

let () =
  Skeleton.home_service => Home.home_page;
  Skeleton.Plonger.Services.formations => Formations.formation_page;
  Skeleton.Plonger.Services.stages => Stages.stage_page;
  Skeleton.Informations.Services.piscine => Piscine.piscine_page;
  Skeleton.Informations.Services.fosse => Fosse.fosse_page;
  Skeleton.Informations.Services.inscription => Inscription.inscription_page;
  Skeleton.Contact.service => Contact.contact_page;
  ()
