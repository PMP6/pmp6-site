let ( => ) service page =
  Pmp6.App.register
    ~service
    page

let () =
  Skeleton.home_service => Home.home_page;
  Skeleton.Plonger.Services.formations => Formations.formation_page;
  Skeleton.Plonger.Services.stages => Stages.stage_page;
  Skeleton.Informations.Services.piscine => Piscine.piscine_page;
  Skeleton.Informations.Services.fosse => Fosse.fosse_page;
  Skeleton.Informations.Services.inscription => Inscription.inscription_page;
  Skeleton.Espace_membre.Services.boutique => Boutique.boutique_page;
  Skeleton.Contact.service => Contact.contact_page;
  ()

let () =
  Eliom_registration.set_exn_handler
    (fun e -> match e with
       | Eliom_common.Eliom_Wrong_parameter ->
         Eliom_registration.Redirection.(send @@ Redirection Skeleton.home_service)
       | _ -> Lwt.fail e)
