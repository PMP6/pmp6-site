module H = Html

let gmaps_embed () =
  Google.Maps.embed
    "!1m24!1m8!1m3!1d8849.634086269782!2d2.282821449764344!3d48.\
     74346840674256!3m2!1i1024!2i768!4f13.1!4m13!3e3!4m5!1s0x47e6777\
     4f96d6ce9%3A0x64efdacc741a99bf!2sLes+Baconnets+92160+Antony!\
     3m2!1d48.739612699999995!2d2.2874453999999997!4m5!1s0x47e6777399ab91f7%\
     3A0x85ba6533358802fc!2sCentre+Aquatique+Pajeaud%2C\
     +104+Rue+Adolphe+Pajeaud%2C+92160+Antony!3m2!1d48.7431596!2d2.286931!\
     5e0!3m2!1sfr!2sfr!4v1557852774857!5m2!1sfr!2sfr\""

let fosse_page () () =
  Template_lib.page ~title:"Fosse"
    H.[
      h1 [txt "Fosse"];
      p ~a:[a_class["callout"; "alert"]] [
        txt "L'espace plongée d'Antony est en travaux jusqu'à une date \
             indéterminée, ce qui nous empêche actuellement de \
             proposer des séances de fosse. Nous travaillons à une \
             solution alternative qui sera proposée aux adhérents dès \
             que possible !";
      ];
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
      (* p [
       *   txt "Pour l'année 2020-2021, les séances sont prévues aux \
       *        dates suivantes :";
       * ];
       * ul [
       *   li [txt "Jeudi 29 octobre à 19 h"];
       *   li [txt "Lundi 9 novembre à 20 h"];
       *   li [txt "Jeudi 26 novembre à 19 h"];
       *   li [txt "Lundi 7 décembre à 20 h"];
       *   li [txt "Jeudi 21 janvier à 20 h"];
       *   li [txt "Jeudi 4 février à 19 h"];
       *   li [txt "Jeudi 18 février à 20 h"];
       *   li [txt "Lundi 1"; sup [txt "er"]; txt " mars à 20 h"];
       *   li [txt "Lundi 15 mars à 19h"];
       *   li [txt "Lundi 29 mars à 21 h "];
       *   li [txt "Jeudi 6 mai à 19 h"];
       * ]; *)

      p [
        txt "Les inscriptions se font sur le formulaire envoyé par \
             mail avant chaque séance. Le rendez-vous est fixé vingt \
             minutes avant la séance, sur le côté droit du complexe \
             sportif quand on arrive.";
      ];
      div_classes ["grid-x"; "align-center"] [
        div_classes ["cell"; "large-8"; "medium-10"; "small-12"] [
          gmaps_embed ()
        ];
      ];
      Template.thumbnail_row ~subdir:["fosse"] [
        "Le tube de 20m vu de haut", "fosse_1.JPG";
        "Exercices à 6m", "fosse_2.JPG";
        "Ensemble sur le bord du tube", "fosse_3.JPG";
        "Descentes et remontées dans le tube", "fosse_4.JPG";
      ];
    ]
