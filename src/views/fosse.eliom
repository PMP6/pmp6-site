module H = Html

let antony_gmaps_embed () =
  Google.Maps.embed
    "!1m24!1m8!1m3!1d8849.634086269782!2d2.282821449764344!3d48.\
     74346840674256!3m2!1i1024!2i768!4f13.1!4m13!3e3!4m5!1s0x47e6777\
     4f96d6ce9%3A0x64efdacc741a99bf!2sLes+Baconnets+92160+Antony!\
     3m2!1d48.739612699999995!2d2.2874453999999997!4m5!1s0x47e6777399ab91f7%\
     3A0x85ba6533358802fc!2sCentre+Aquatique+Pajeaud%2C\
     +104+Rue+Adolphe+Pajeaud%2C+92160+Antony!3m2!1d48.7431596!2d2.286931!\
     5e0!3m2!1sfr!2sfr!4v1557852774857!5m2!1sfr!2sfr\""

let charenton_gmaps_embed () =
  Google.Maps.embed
    "!1m28!1m12!1m3!1d955.9487768243421!2d2.412119659111019!3d48.\
     822760692822!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!4m13!3e3\
     !4m5!1s0x47e672f973b70143%3A0x742d9f52f7ff23ed!2s\
     Charenton-Écoles+Charenton-le-Pont+France\
     !3m2!1d48.8215862!2d2.4140601999999998!4m5!1s0x47e672f9b9575371%\
     3A0xc96f9be18e461e31!2s4+Av.+Anatole+France%2C+94220\
     +Charenton-le-Pont%2C+France!3m2!1d48.8231241!2d2.4129158\
     !5e0!3m2!1sfr!2suk!4v1666200351405!5m2!1sfr!2suk"

let villeneuve_gmaps_embed () =
  Google.Maps.embed
    "!1m18!1m12!1m3!1d2620.5825615796984!2d2.3149239516407483!3d48.\
     942392202640114!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2\
     !1s0x47e668ce0172bedb%3A0x19a2a82e09902bfe!2sCentre%20de%20plong\
     %C3%A9e%20Aqua%20Hauts-de-Seine%20-%20UCPA!5e0!3m2!1sfr!2suk\
     !4v1666202603898!5m2!1sfr!2suk"

let fosse_page () () =
  Content.page ~title:"Fosse"
    H.[
      h1 [txt "Fosse"];
      p [
        txt "La fosse nous permet de pratiquer, jusqu'à 20m de \
             profondeur, les gestes techniques de la plongée. Les \
             plongeurs qui préparent un niveau peuvent y travailler \
             leur maîtrise technique de ces gestes avant de rencontrer \
             en stage les difficultés supplémentaires du milieu \
             naturel.";
      ];
      p [
        txt "Les séances de fosse sont ouvertes à tous les adhérents, \
             avec accord préalable d'un moniteur pour les \
             débutants. Elles sont spécialement indiquées pour la \
             préparation de niveaux de plongée, mais sont aussi \
             accessibles à ceux qui veulent entretenir leurs \
             compétences, ou simplement profiter du bien-être que \
             procure une heure d'immersion en eau chaude.";
      ];
      p [
        txt "Selon la disponibilité des installations, les séances se \
             déroulent dans plusieurs complexes sportifs proches de \
             Paris. Les inscriptions se font habituellement sur un \
             formulaire envoyé par mail avant chaque séance.";
      ];

      section [
        header [
          h2 [txt "Fosse de plongée de Charenton"];
        ];
        p [
          txt "4 bis avenue Anatole France";
          br ();
          txt "94220 Charenton-le-Pont";
          br ();
          txt "Métro Charenton-Écoles, Ligne 8";
          br ();
        ];
        div_classes ["grid-x"; "align-center"] [
          div_classes ["cell"; "large-8"; "medium-10"; "small-12"] [
            charenton_gmaps_embed ()
          ];
        ];
      ];

      section [
        header [
          h2 [txt "Aqua Hauts-de-Seine, Villeneuve"]
        ];
        p [
          txt "Centre UCPA Aqua Hauts-de-Seine";
          br ();
          txt "119 boulevard Charles de Gaulle";
          br ();
          txt "92390 Villeneuve-la-Garenne";
          br ();
        ];
        p [
          txt "Pour les plongeurs arrivant en voiture, des places de \
               parking sont disponibles près de l'entrée (ne pas \
               franchir la grille qui peut être verrouillée le \
               soir). Il est possible de s'y rendre en transports en \
               commun, et des covoiturages sont habituellement \
               organisés par les participants de chaque séance (y \
               compris sur place pour le retour).";
        ];
        div_classes ["grid-x"; "align-center"] [
          div_classes ["cell"; "large-8"; "medium-10"; "small-12"] [
            villeneuve_gmaps_embed ()
          ];
        ];
      ];

      section [
        header [
          h2 [txt "Espace Plongée d'Antony"]
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
          txt "Le rendez-vous est fixé vingt minutes avant la séance, \
               sur le côté droit du complexe sportif quand on arrive.";
        ];
        div_classes ["grid-x"; "align-center"] [
          div_classes ["cell"; "large-8"; "medium-10"; "small-12"] [
            antony_gmaps_embed ()
          ];
        ];
      ];

      Widget.thumbnail_row ~subdir:["fosse"] [
        "Le tube de 20m vu de haut", "fosse_1.JPG";
        "Exercices à 6m", "fosse_2.JPG";
        "Ensemble sur le bord du tube", "fosse_3.JPG";
        "Descentes et remontées dans le tube", "fosse_4.JPG";
      ];

    ]
