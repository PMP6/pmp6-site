module H = Eliom_content.Html.D

let thumbnails location =
  Template.thumbnail_row ~subdir:["stages"; location]

let intro =
  H.(
    p [
      txt "Entre Manche et Méditerranée, nous organisons au cours de \
           l'année plusieurs stages de plongée en mer. Certains sont \
           conçus en priorité pour le passage de niveau, alors que \
           d'autres sont plutôt orientés vers la plongée plaisir.";
    ]
  )

let banyuls =
  H.[
    header [
      h2 [txt "Banyuls-sur-mer"];
    ];
    p [
      txt "En plein cœur de la côte vermeille, au pied du massif des \
           Albères, réside une station marine à laquelle est rattaché \
           un observatoire océanologique : le laboratoire Arago. C'est \
           aussi le lieu d'accueil d'un fragile paradis sous-marin, la \
           réserve naturelle marine de Cerbère-Banyuls."
    ];
    p [
      txt "Première réserve marine de France, ce site abrite les \
           principaux habitats méditerranéens permettant le \
           développement d'une faune et d'une flore foisonnantes, dont \
           l'emblématique mérou brun ";
      i [txt "Epinephelus marginatus"];
      txt ".";
    ];
    p [
      txt "Les stages à Banyuls sont organisés sur deux périodes de l'année :"
    ];
    ul [
      li [
        txt "Au printemps, pendant les vacances de Pâques de la zone \
             parisienne. Ce stage sur une dizaine de jours est \
             spécialement dédié à la préparation des Niveaux 2 \
             et 3. Il se divise entre plongées d'exercices techniques \
             et plongées d'exploration pour la formation à l'autonomie."
         ];
      li [
        txt "En été, sur une durée d'un mois qui s'étend \
             habituellement entre mi-juillet et mi-août. En cette \
             période où la faune de la réserve est particulièrement \
             abondante, ce stage est principalement dédié aux plongées \
             d'exploration. Il peut toutefois être l'occasion de \
             valider des niveaux si l'encadrement est suffisant. Il \
             n'est bien sûr pas nécessaire de rester un mois entier : \
             la priorité est donnée aux stagiaires restant au moins \
             une semaine complète, mais il est en général possible de \
             choisir ses dates d'arrivée et de départ.";
      ];
    ];
    p [
      txt "L'hébergement se fait lorsque c'est possible dans la \
           résidence d'accueil de l'observatoire Arago.";
    ];
    thumbnails "banyuls" [
      "Baudroie", "baudroie close up.jpg";
      "Banyuls-sur-mer", "Banyuls-sur-mer.jpeg";
      "Mérou", "mérou.jpg";
      "Murène", "murene.jpg";
    ];
  ]

let carantec =
  H.[
    header [
      h2 [txt "Carantec"];
    ];
    p [
      txt "Tombants, délirantes dérivantes, laminaires et crustacés, \
           raies et roussettes : voilà ce qui vous attend sous la \
           surface de la magnifique baie de Morlaix."
    ];
    p [
      txt "Les stages à Carantec sont habituellement organisés au \
           printemps, sur les week-ends prolongés de l'Ascension et de \
           la Pentecôte. Ils sont dédiés principalement \
           à l'exploration, mais selon l'encadrement il est parfois \
           possible de valider des niveaux de plongées.";
    ];
    p [
      txt "L'hébergement se fait en camping, et l'accès aux sites de \
           plongées depuis nos zodiacs."
    ];
    p [
      txt "Si les places sont limitées, ces stages sont ouverts à tous \
           les adhérents. Toutefois, un Niveau 2 est recommandé pour \
           profiter au maximum des sites qui descendent facilement \
           jusqu'à 30m."
    ];
    thumbnails "carantec" [
      "Roussette", "roussette.jpg";
      "Baie de Morlaix", "baie de morlaix.jpg";
      "Homard", "homard.jpg";
      "Macropode", "macropode.jpg";
    ];
  ]

let dieppe =
  H.[
    header [
      h2 [txt "Dieppe"];
    ];
    p [
      txt "Tôles, congres, homards et tacauds : venez plonger sur les \
           épaves de Normandie !";
    ];
    p [
      txt "Ce stage est organisé sur un week-end entre septembre et \
           octobre. Trois plongées y sont prévues, toutes sur \
           épave. Il est accessible aux plongeurs Niveau 2 et plus."
    ];
    p [
      txt "Les plongées sont organisées par un club local, et \
           l'hébergement se fait en camping."
    ];
    thumbnails "dieppe" [
      "Saint-pierre", "saint-pierre.jpg";
      "Tourteau", "tourteau.jpg";
      "Homard", "homard.jpg";
      "Canon", "canon.JPG";
    ];
  ]

let groix =
  H.[
    header [
      h2 [txt "Île de Groix"];
    ];
    p [
      i [txt "Qui voit Groix voit sa joie,"];
      txt " nous enseigne la sagesse des navigateurs bretons. Île au \
           patrimoine géologique exceptionnel, Groix présente aussi \
           des sites et conditions de plongées bien adaptés à la \
           formation des débutants."
    ];
    p [
      txt "Le stage de Groix, sur un week-end, est ainsi dédié à la \
           validation finale des Niveaux 1. La logistique des \
           plongées, la traversée vers l'île et l'hébergement sont \
           organisés par un club local."
    ];
    p [
      txt "La majorité des plongées se font avec un départ du bord. Si \
           les conditions le permettent, des plongées depuis un bateau \
           pour atteindre des profondeurs plus importantes et admirer \
           une faune et une flore sous-marines différentes peuvent \
           aussi être organisées."
    ];
    thumbnails "groix" [
      "Araignée de mer", "araignée.JPG";
      "Groix", "groix.JPG";
      "Araignée sur une épave", "araignée_tôle.JPG";
      "Œil de congre", "oeil_congre.JPG";
    ];
  ]

let provence =
  H.[
    header [
      h2 [txt "Provence"];
    ];
    p [
      txt "Marseille, Hyères ou le Lavandou : au sud de la France, le \
           pays des santons est aussi le berceau historique de la \
           plongée sous-marine."
    ];
    p [
      txt "Organisés sur un week-end, souvent au début ou à la fin de \
           l'été, les stages en Provence permettent de découvrir les \
           épaves mythiques et les tombants spectaculaires de la \
           Méditerranée.";
    ];
    p [
      txt "Les plongées se font à des profondeurs importantes et sont \
           réservées aux Niveaux 3, ou exceptionnellement à des \
           Niveaux 2 confirmés."
    ];
    thumbnails "provence" [
      "Sars", "sars.JPG";
      "Gorgone", "gorgone.JPG";
      "Poulpe", "poulpe.JPG";
      "Anthias", "anthias.JPG";
    ]
  ]

let stage_page () () =
  Lwt.return @@
  Template.make_page ~title:"Stages"
    H.[
      h1 [txt "Stages"];
      intro;
      section banyuls;
      section carantec;
      section dieppe;
      section groix;
      section provence;
    ]
