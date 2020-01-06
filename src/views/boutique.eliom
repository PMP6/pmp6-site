module H = Html

let intro =
  H.[
    p [
      txt "Nous passons par HelloAsso pour permettre aux adhérents \
           de régler divers frais en ligne. Vous trouverez sur cette \
           page des liens directs vers les principaux paiements. Les \
           autres seront visibles directement sur ";
      a ~service:(Hello_asso.main_service ()) [txt "la page de la section"] ();
      txt ".";
    ];
    p [
      txt "L'utilisation de ces liens est réservée aux membres de \
           l'ASSU-SIM. Pensez à contacter les encadrants pour vous \
           assurer que votre demande est prise en compte.";
    ]
  ]

let licence =
  H.[
    header [
      h2 [txt "Licence FFESSM"];
    ];
    p [
      txt "Utilisez ce bouton pour souscrire une licence FFESSM via \
           PMP6."
    ];
    p [
      txt "La licence est valable du 15 septembre au 31 décembre de \
           l'année suivante. Elle est nécessaire dès lors que vous \
           passez un brevet, ainsi que pour certains stages.";
    ];
    Hello_asso.pay_widget "achat-de-licence-ffessm";
  ]

let carte_niveau =
  H.[
    header [
      h2 [txt "Carte de niveau"];
    ];
    p [
      txt "Utilisez ce bouton pour payer une carte de niveau."
    ];
    p [
      txt "Ce paiement peut être effectué dès lors que votre niveau \
           a été validé par l'encadrant responsable. Vous pourrez \
           alors recevoir votre carte d'attestation.";
    ];
    Hello_asso.pay_widget "achat-d-une-carte-de-brevet";
  ]


let boutique_page () =
  Template.make_page ~title:"Boutique"
    H.[
      h1 [txt "Boutique"];
      section intro;
      section licence;
      section carte_niveau;
    ]
