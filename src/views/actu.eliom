module H = Eliom_content.Html.D

type t = {
  short_title : string;
  title : string;
  datetime : Time.t;
  content : Html_types.div_content_fun H.elt H.list_wrap;
}

let content_piscine =
  let open H in
  [
    p [
      txt "Nos entraînements en piscine ont lieu à la piscine Jean \
           Taris, au 16 rue Thouin (Paris V";
      sup [txt "ème"];
      txt "). Ils se déroulent sur les créneaux suivants :";
    ];
    ul [
      li [H.txt "Le mardi de 21h à 22h"];
      li [H.txt "Le samedi de 18h à 20h"];
    ];
    p [
      txt "Les deux créneaux sont ouverts à tous les membres.";
    ]
  ]

let content_fosse =
  let open H in
  [
    p [
      txt "Les séances de fosse permettent de travailler jusqu'à 20m \
           de profondeur. Ils sont ouverts à tous, avec accord \
           préalable d'un moniteur pour les préparants Niveau 1.";
    ];
    p [
      txt "Elles se déroulent à l'Espace Plongée d'Antony, à l'adresse \
           suivante :";
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

let get () = [
  {
    title = "Horaires de piscine";
    short_title = "Piscine";
    datetime = Time.now ();
    content = content_piscine;
  };
  {
    title = "Dates des fosses";
    short_title = "Fosses";
    datetime = Time.now () |> Fn.flip Time.sub Time.Span.hour;
    content = content_fosse;
  };
]
