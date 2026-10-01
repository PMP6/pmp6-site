[%%server.start]

let skeleton_routes =
  Registration_lib.
    [
      (Skeleton.home_service, Home.home_page);
      (Skeleton.Plonger.Services.formations, Formations.formation_page);
      (Skeleton.Plonger.Services.stages, Stages.stage_page);
      (Skeleton.Informations.Services.piscine, Piscine.piscine_page);
      (Skeleton.Informations.Services.fosse, Fosse.fosse_page);
      (Skeleton.Informations.Services.inscription, Inscription.inscription_page);
      (Skeleton.Espace_membre.Services.calendrier, Calendrier.calendrier_page);
      (Skeleton.Espace_membre.Services.boutique, Boutique.boutique_page);
      (Skeleton.Contact.service, Contact.contact_page);
    ]

let legacy_redirects =
  [
    ([ "plonger"; "formations" ], Skeleton.Plonger.Services.formations);
    ([ "plonger"; "stages" ], Skeleton.Plonger.Services.stages);
    ([ "informations-pratiques"; "piscine" ], Skeleton.Informations.Services.piscine);
    ([ "informations-pratiques"; "fosse" ], Skeleton.Informations.Services.fosse);
    ( [ "informations-pratiques"; "inscription" ],
      Skeleton.Informations.Services.inscription );
    ([ "espace-membre"; "boutique" ], Skeleton.Espace_membre.Services.boutique);
  ]

let () =
  Registration_lib.register_legacy_redirects legacy_redirects;
  Registration_lib.register_routes Template.return_page skeleton_routes;
  Registration_lib.register_routes Template.return_page Admin.Registration.routes;
  Registration_lib.register_routes Template.return_page Auth.Registration.routes;
  Registration_lib.register_routes Template.return_page News.Registration.routes;
  ()
