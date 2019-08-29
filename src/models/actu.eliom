module H = Eliom_content.Html.D

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
  let open H in
  [
    p [
      txt "C'est la rentrée ! ";
    ];
    p [
      txt "La première séance de piscine pour les anciens aura lieu \
           à Jean Taris le mardi 3 septembre. Pour les nouveaux \
           arrivants, les séances commenceront le mardi 1";
      sup [txt "er"];
      txt " octobre. Pour plus d'informations ou pour connaître les \
           horaires, consultez ";
      a ~service:Skeleton.Informations.Services.piscine
        [txt "la page dédiée"]
        ();
      txt ".";
    ];
    p [
      txt "Par ailleurs, une réunion de rentrée et d'information, \
           à laquelle tous les nouveaux inscrits sont conviés, se \
           déroulera sur le campus Jussieu le 24 septembre en fin \
           d'après-midi."
    ];
    p [
      txt "Enfin, n'oubliez pas de vous inscrire ! Les préinscriptions \
           seront ouvertes à partir du 1";
      sup [txt "er"];
      txt " septembre sur le site du ";
      a ~service:daps_service
        [txt "DAPS"]
        ();
      txt ". Les tarifs d'inscription pour l'année comprennent la \
           cotisation de base à l'AS (à ne payer qu'une fois pour tous \
           les sports) ainsi qu'une cotisation supplémentaire pour \
           financer le matériel et les séances spécifiques. Les deux \
           montants dépendent de votre statut :";
    ];
    ul [
      li [H.txt "Pour les étudiants, 45€ de base + 65€ plongée ;"];
      li [H.txt "Pour les membres du personnel, 65€ de base + 85€ plongée ;"];
      li [H.txt "Pour les membres extérieurs, 85€ de base + 95€ plongée ;"];
      li [H.txt "Pour les encadrants (E2 + permis bateau), la \
                 cotisation de base ne change pas, mais la cotisation \
                 supplémentaire est fixée à 65€ quel que soit votre statut."];
    ];
    p [
      txt "À très bientôt pour de nouvelles aventures sous-marines !";
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
      li [H.txt "Le samedi de 18h à 20h"];
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
      txt "Les fosses reprendront le 30 octobre 2019 (à 21h). Les \
           dates des suivantes sont d'ores et déjà prévues et \
           disponibles sur ";
      a ~service:Skeleton.Informations.Services.fosse
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

let get () = [
  {
    title = "Informations rentrée";
    short_title = "Rentrée";
    datetime = deploy_time;
    content = content_rentree ();
  };
  {
    title = "Horaires de piscine";
    short_title = "Piscine";
    datetime = deploy_time |> Fn.flip Time.sub Time.Span.minute;
    content = content_piscine ();
  };
  {
    title = "Dates des fosses";
    short_title = "Fosses";
    datetime = Time.now () |> Fn.flip Time.sub Time.Span.hour;
    content = content_fosse ();
  };
]
