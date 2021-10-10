module H = Html

let thumbnail ~alt filename =
  Template.thumbnail_row ~max_size:4 ~subdir:["formations"] [alt, filename]

let intro =
  H.(
    p [
      txt "Chaque année, nous organisons des formations du Niveau 1 au \
           Niveau 3. D'autres formations peuvent être organisées s'il \
           existe un nombre suffisant de demandes. Ces formations se \
           répartissent entre cours théoriques, séances de piscine où \
           des lignes d'eau sont réservées aux différents niveaux, \
           exercices en fosse et stage de validation finale en mer.";
    ]
  )

let niveau_1 =
  H.[
    header [
      h2 [txt "Niveau 1"];
      div_classes ["h3"; "subheader"] [txt "Vos premières bulles..."]
    ];
    p [
      txt "Le Niveau 1, première étape de formation des débutants, \
           vous permettra d'évoluer jusqu'à 20m de profondeur dans une \
           palanquée guidée.";
    ];
    p [
      txt "La formation se déroule d'abord en piscine, où, après un \
           baptême, vous apprendrez à la fois la plongée avec \
           bouteille et les techniques sans scaphandre comme la nage \
           avec palmes ou l'apnée. Il faut compter une vingtaine de \
           séances de piscine au total pour une formation complète."
    ];
    p [
      txt "Une fois le feu vert donné par un encadrant, vous pourrez \
           également participer aux séances de fosse, où vous \
           appliquerez les techniques apprises dans une eau chaude et \
           claire jusqu'à 20m de profondeur."
    ];
    p [
      txt "Enfin, la validation finale de votre niveau se fait \
           habituellement au printemps, par 4 plongées en mer \
           réalisées lors du stage à l'Île de Groix.";
    ];
    thumbnail ~alt:"Une joyeuse palanquée" "n1.jpg";
  ]

let niveau_2 =
  H.[
    header [
      h2 [txt "Niveau 2"];
      div_classes ["h3"; "subheader"] [txt "Progresser pour explorer"]
    ];
    p [
      txt "Avec le Niveau 2, vous progressez à la fois vers \
           l'autonomie et la profondeur : vous pourrez plonger jusqu'à \
           20m sans guide (accompagné d'un plongeur au moins du même \
           niveau), et jusqu'à 40m en palanquée guidée.";
    ];
    p [
      txt "En piscine, vous travaillerez avant tout votre condition \
           physique, prérequis indispensable à votre sécurité en \
           immersion."
    ];
    p [
      txt "Votre formation pratique tout au long de l'année se fera \
           donc en grande partie en fosse, où vous travaillerez des \
           techniques nécessaires au déroulement d'une plongée \
           autonome."
    ];
    p [
      txt "De plus, une formation théorique est indispensable pour \
           soutenir votre pratique. Elle est assurée par une dizaine \
           de cours qui se concluent par un examen permettant de \
           vérifier que vous avez acquis et compris les connaissances \
           nécessaires."
    ];
    p [
      txt "Les Niveaux 2 se valident enfin lors d'un stage en mer \
           d'une dizaine de jours, principalement Banyuls Pâques.";
    ];
    thumbnail ~alt:"Au palier à Banyuls" "n2.jpg";
  ]

let niveau_3 =
  H.[
    header [
      h2 [txt "Niveau 3"];
      div_classes ["h3"; "subheader"] [txt "L'autonomie en profondeur"];
    ];
    p [
      txt "Le Niveau 3 est le niveau le plus élevé de plongeur loisir \
           dans la progression fédérale. Depuis le Niveau 2, la \
           progression est considérable : vous pourrez plonger en \
           autonomie jusqu'à 60m de profondeur !"
    ];
    p [
      txt "Plonger dans cette zone nécessite une bonne technique, une \
           bonne condition physique et la connaissance des dangers \
           associés. La formation au Niveau 3 vise à vous enseigner \
           tout cela. Pendant l'année, elle est composée \
           principalement d'un volet théorique de cinq cours environ \
           suivis d'un examen et d'une préparation physique en \
           piscine. Elle comporte également une formation au \
           secourisme sur un week-end, le ";
      abbr
        ~a:[a_title "Réaction et intervention face à un accident de plongée"]
        [txt "RIFAP"];
      txt ".";
    ];
    p [
      txt "Pour plonger profond en autonomie, il est également \
           nécessaire d'avoir accumulé suffisamment d'expérience sur \
           ces deux axes. Ainsi, il est indispensable pour attaquer le \
           stage dans de bonnes conditions d'avoir plongé suffisamment \
           depuis votre Niveau 2 : nous recommandons au moins une \
           dizaine de plongées autonomes à 20m et 4-5 plongées au delà \
           de 30m avant de vous lancer dans la partie finale de la \
           formation. Ces plongées pour acquérir de l’expérience \
           peuvent par exemple être faites au cours des stages de \
           Banyuls (pour l'autonomie) et de Marseille/Hyères/Lavandou \
           (pour la profondeur)."
    ];
    p [
      txt "La validation finale se fait également habituellement lors \
           du stage de Banyuls Pâques, sur une dizaine de jours."
    ];
    thumbnail ~alt:"Exploration d'une faille" "n3.jpg";
  ]

let autres =
  let tapsec_service =
    Eliom_service.extern
      ~prefix:"http://www.fc.upmc.fr"
      ~path:[
        "fr";
        "catalogue-de-formations-2018-2019";
        "formation-qualifiante-FC6";
        "sciences-technologies-sante-STS";
        "techniques-appliquees-de-plongee-scientifique-\
         pour-l-ecologie-cotiere-\
         program-techniques-appliquees-de-plongee-scientifique-\
         pour-l-ecologie-cotiere-2-2.html"
      ]
      ~meth:(Eliom_service.Get Eliom_parameter.unit)
      ()
  in
  H.[
    header [
      h2 [txt "Autres formations"];
      div_classes ["h3"; "subheader"] [txt "Enseignement, spécialités..."];
    ];
    p [
      txt "Si la demande est suffisante, nous pouvons également \
           proposer des formations à d'autres brevets. Si vous êtes \
           intéressés, n'hésitez pas à prend contact avec les \
           encadrants ou les délégués !"
    ];
    p [
      txt "Voici quelques exemples :"
    ];
    dl [
      dt [txt "Niveau 4"];
      dd [txt "Pour l'encadrement de palanquée. Nous pouvons organiser \
               une formation si la demande est suffisante, le passage \
               de l'examen étant en général organisé dans une autre \
               structure."];

      dt [txt "Enseignement"];
      dd [txt "De l'Initiateur (accessible dès le N2) au Moniteur \
               Fédéral 2";
          sup [txt "ème"];
          txt " degré, nous pouvons vous préparer pour les niveaux \
               d'enseignement. La validation se fait avec les Comités \
               Départementaux ou Régionaux de la Fédération."];

      dt [txt "Nitrox"];
      dd [txt "Enrichissez votre air en oxygène pour réduire vos \
               paliers et augmenter la sécurité !"];

      dt [txt "Plongée scientifique"];
      dd [txt "Les étudiants de Sorbonne Université ont accès à une ";
          a ~service:tapsec_service
            [txt "UE de formation en plongée scientifique"]
            ();
          txt " à laquelle certains de nos moniteurs participent comme \
               formateurs. Nous contacter pour plus d'informations."
         ];
      dt [txt "Bio, archéo..."];
      dd [txt "Selon la demande et la disponibilité des moniteurs \
               compétents, nous participons parfois à des formations \
               de plongée spécialisée, au sein du club ou avec des \
               partenaires."];
    ];
    thumbnail ~alt:"Le pacha et l'oursin" "Alain.jpg";
  ]

let formation_page () () =
  Template_lib.page ~title:"Formations"
    H.[
      h1 [txt "Formations"];
      intro;
      section niveau_1;
      section niveau_2;
      section niveau_3;
      section autres;
    ]
