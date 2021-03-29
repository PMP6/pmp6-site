module H = Html

let content_expo_photos () =
  let affiche_uri =
    Skeleton.Static.img_uri ["actus"; "affiche_expo_photos.png"] in
  let open H in
  [
    p [
      txt "L'exposition de photos sous-marines de PMP6 fait son \
           grand retour !"
    ];
    p [
      txt "Au programme : (re)découvrir les \
           magnifiques créatures capturées par l'objectif de nos \
           plongeurs, tout en en apprenant plus sur elles et leurs \
           milieux."
    ];
    p [
      txt
        "Cette exposition se tiendra du 11 au 29 novembre 2019 \
         à l'Atrium Café du campus Jussieu, lieu de convivialité \
         pour de nombreux étudiants. Elle sera ensuite déplacée le \
         temps d'une journée à la piscine Jean Taris, à l'occasion \
         du Téléthon (7 décembre 2019), où petits et grands pourront \
         en profiter lors de leurs baptêmes... sous l'eau ! La \
         boucle est bouclée."
    ];
    p [
      img
        ~a:[a_class ["float-center"]]
        ~src:affiche_uri
        ~alt:"Affiche de l'expo photos"
        ()
    ]
  ]

let content_rentree () =
  let daps_service =
    Eliom_service.extern
      ~prefix:"https://daps.upmc.fr"
      ~path:[]
      ~meth:(Eliom_service.Get Eliom_parameter.unit)
      () in
  let flyer_uri =
    Skeleton.Static.img_uri ["actus"; "Flyers_PMP6_2020.png"] in
  let plaquette_uri =
    Skeleton.Static.uri ["files"; "PMP6_plaquetteAS_2020-2021.pdf"] in
  let autoquestionnaire_uri =
    Skeleton.Static.uri ["files"; "Autoquestionnaire_FFESSM.docx"] in
  let open H in
  [
    p ~a:[a_class["callout"; "alert"]] [
      txt "La réunion est annulée en raison des mesures sanitaires !";
    ];
    p [
      txt "C'est la rentrée ! ";
    ];
    p [
      txt "Les séances de piscine ont déjà repris pour les anciens aux ";
      a
        ~absolute_path:true
        ~service:Skeleton.Informations.Services.piscine
        [txt "horaires habituels"]
        ();
      txt ". Dans ce contexte sanitaire particulier, des règles sont \
           en place pour pratiquer en toute sécurité. En particulier, \
           n'oubliez pas de remplir votre ";
      Raw.a ~a:[a_href autoquestionnaire_uri] [txt "autoquestionnaire"];
      txt " et de l'envoyer aux ";
      mailto_a "delegues@pmp6.fr" [txt "délégués"];
      txt " ou de venir avec à la piscine.";
    ];
    p [
      txt "Par ailleurs, une réunion de rentrée et d'information, \
           à laquelle tous les plongeurs, anciens comme nouveaux, sont \
           conviés, se déroulera sur le campus Jussieu le \
           mercredi 7 octobre à 18 h 15."
    ];
    p [
      txt "Enfin, n'oubliez pas de vous inscrire ! Vous devez d'abord \
           vous préinscrire sur le site du ";
      a
        ~absolute_path:true
        ~service:daps_service
        [txt "DAPS"]
        ();
      txt ", puis venir régler au secrétariat. Les tarifs \
           d'inscription pour l'année comprennent la cotisation de \
           base à l'AS (à ne payer qu'une fois pour tous les sports, \
           sauf pour les inscrits Splash qui ne payent pas) ainsi \
           qu'une cotisation supplémentaire pour financer le matériel \
           et les séances spécifiques. Les deux montants dépendent de \
           votre statut :";
    ];
    ul [
      li [H.txt "Si vous passez par Splash pour vous inscrire, vous ne \
                 devrez payer que 65 € en tout (la cotisation de base \
                 est gratuite), étudiant ou non ;"];
      li [H.txt "Pour les étudiants du campus Jussieu, 45 € de base + \
                 65 € plongée ;"];
      li [H.txt "Pour les membres du personnel Jussieu, 55 € de base + \
                 85 € plongée ;"];
      li [H.txt "Pour les membres extérieurs anciens de la section, \
                 65 € de base + 95 € plongée ;"];
      li [H.txt "Pour les encadrants (E2 + permis bateau), la \
                 cotisation de base ne change pas, mais la cotisation \
                 supplémentaire est fixée à 65 € quel que soit votre \
                 statut."];
    ];
    p [
      txt "Pour plus d'informations, vous pouvez consulter la ";
      Raw.a ~a:[a_href plaquette_uri] [txt "plaquette"];
      txt " de rentrée de la section, ou écrire un mail aux délégués à l'adresse ";
      email "delegues@pmp6.fr" ();
      txt ".";
    ];
    p [
      txt "À très bientôt pour de nouvelles aventures sous-marines !";
    ];
    p [
      img
        ~a:[a_class ["float-center"]]
        ~src:flyer_uri
        ~alt:"Flyer de la réunion de rentrée"
        ()
    ];
  ]

let content_piscine () =
  let open H in
  [
    p [
      txt "Nos entraînements en piscine ont lieu à la piscine Jean \
           Taris, au 16 rue Thouin (Paris V";
      sup [txt "ème"];
      txt "). Ils se déroulent sur les créneaux suivants :";
    ];
    ul [
      li [H.txt "Le mardi de 21h à 22h"];
      li [H.txt "Le samedi de 18h à 19h30"];
    ];
    p [
      txt "Les deux créneaux sont ouverts à tous les membres.";
    ]
  ]

let content_fosse () =
  let open H in
  [
    p [
      txt "Les séances de fosse permettent de travailler jusqu'à 20m \
           de profondeur. Ils sont ouverts à tous, avec accord \
           préalable d'un moniteur pour les préparants Niveau 1.";
    ];
    p [
      txt "Elles se déroulent à l'Espace Plongée d'Antony, à l'adresse \
           suivante :";
    ];
    p [
      txt "Centre Aquatique Pajeaud";
      br ();
      txt "104 rue Adolphe Pajeaud";
      br ();
      txt "92160 ANTONY";
      br ();
      txt "RER B, direction St Rémy, station Les Baconnets puis 5-10 \
           min à pieds";
      br ();
    ];
    p [
      txt "Nous ne savons pas encore quand les séances de fosse \
           pourront reprendre pour la saison 2020-2021. Dès qu'elles \
           seront connues, les dates seront disponibles sur ";
      a ~absolute_path:true
        ~service:Skeleton.Informations.Services.fosse
        [txt "la page dédiée"]
        ();
      txt ".";
    ];
    p [
      txt "Les inscriptions se feront comme d'habitude en remplissant \
           le formulaire envoyé par mail avant chaque séance.";
    ];
  ]

let deploy_time = Time.now ()

let news_items () =
  List.map
    ~f:(fun (title, short_title, pub_time, content) ->
      News.Model.Item.build ~title ~short_title ~pub_time ~content)
  [
    (
      "Rentrée 2020",
      "Rentrée 2020",
      deploy_time |> Fn.flip Time.sub Time.Span.minute,
      Html.div @@ content_rentree ()
    );

    (
      "Horaires de piscine",
      "Piscine",
      deploy_time |> Fn.flip Time.sub Time.Span.hour,
      Html.div @@ content_piscine ()
    );

    (
      "Dates des fosses",
      "Fosses",
      Time.now () |> Fn.flip Time.sub Time.Span.day,
      Html.div @@ content_fosse ()
    );
  ]


let run () =
  Lwt_list.iter_s News.Model.create_with_item_exn (news_items ())
