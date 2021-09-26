module H = Html

type t = {
  short_title : string;
  title : string;
  datetime : Time.t;
  content : Html_types.div_content_fun H.elt H.list_wrap;
}

let content_rentree () =
  let daps_service =
    Eliom_service.extern
      ~prefix:"https://daps.upmc.fr"
      ~path:[]
      ~meth:(Eliom_service.Get Eliom_parameter.unit)
      () in
  let flyer_uri =
    Skeleton.Static.img_uri ["actus"; "Flyers_PMP6_2021.jpg"] in
  let plaquette_uri =
    Skeleton.Static.uri ["files"; "PMP6_plaquetteAS_2021-2022.jpg"] in
  let open H in
  [
    p [
      txt "C'est la rentrée ! ";
    ];
    p [
      txt "Les séances de piscine ont déjà repris pour les anciens aux ";
      a ~service:Skeleton.Informations.Services.piscine
        [txt "horaires habituels"]
        ();
      txt ". Dans ce contexte sanitaire particulier, des règles sont \
           en place pour pratiquer en toute sécurité. En particulier, \
           vous aurez besoin d'un pass sanitaire pour accéder à la \
           piscine.";
    ];
    p [
      txt "Par ailleurs, une réunion de rentrée et d'information, \
           à laquelle tous les plongeurs, anciens comme nouveaux, sont \
           conviés, se déroulera dans l'amphi 45 A du campus Jussieu \
           le jeudi 30 septembre à 18 h 30."
    ];
    p [
      txt "Enfin, n'oubliez pas de vous inscrire ! Vous devez d'abord \
           vous préinscrire sur le site du ";
      a ~service:daps_service
        [txt "DAPS"]
        ();
      txt ", puis venir régler au secrétariat. Les tarifs \
           d'inscription pour l'année comprennent la cotisation de \
           base à l'AS ainsi qu'une cotisation supplémentaire pour \
           financer le matériel et les séances spécifiques. Les deux \
           montants dépendent de votre statut :";
    ];
    ul [
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

let deploy_time = Time.now ()

let get () = [
  {
    title = "Rentrée 2021";
    short_title = "Rentrée 2021";
    datetime = deploy_time |> Fn.flip Time.sub Time.Span.minute;
    content = content_rentree ();
  };
  {
    title = "Horaires de piscine";
    short_title = "Piscine";
    datetime = deploy_time |> Fn.flip Time.sub Time.Span.hour;
    content = content_piscine ();
  };
]
