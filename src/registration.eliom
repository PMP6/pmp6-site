let skeleton_pages = Registration_lib.[
  Skeleton.home_service, Home.home_page;
  Skeleton.Plonger.Services.formations, Formations.formation_page;
  Skeleton.Plonger.Services.stages, Stages.stage_page;
  Skeleton.Informations.Services.piscine, Piscine.piscine_page;
  Skeleton.Informations.Services.fosse, Fosse.fosse_page;
  Skeleton.Informations.Services.inscription, Inscription.inscription_page;
  Skeleton.Espace_membre.Services.boutique, Boutique.boutique_page;
  Skeleton.Contact.service, Contact.contact_page;
]

let () =
  Registration_lib.register_contents Template.return_page skeleton_pages;
  Registration_lib.register_module Template.return_page (module Admin.Registration);
  Registration_lib.register_module Template.return_page (module Auth.Registration);
  Registration_lib.register_module Template.return_page (module News.Registration);
  ()
