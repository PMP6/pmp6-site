module H = Html

let intro =
  H.[
    p [
      txt "Nous passons par HelloAsso pour permettre aux adhérents de \
           régler divers frais en ligne. Vous pouvez vous rendre sur ";
      a ~service:(Hello_asso.main_service ()) [txt "l'espace de la section"] ();
      txt ", ou réaliser directement sur la présente page les \
           principaux paiements.";
    ];
    p [
      txt "L'utilisation de ce service est réservée aux membres de \
           l'ASSU SIM. Pensez à contacter les encadrants pour vous \
           assurer que votre demande est prise en compte.";
    ]
  ]

let boutique =
  [
    Hello_asso.event_widget "boutique-des-plongeurs";
  ]

let boutique_page () =
  Template.make_page ~title:"Boutique"
    H.[
      h1 [txt "Boutique"];
      section intro;
      section boutique;
    ]
