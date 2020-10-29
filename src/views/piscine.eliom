module H = Html

let gmaps_embed () =
  Google.Maps.embed
    "!1m28!1m12!1m3!1d2625.701212225977!2d2.347797254921896!3d48.84483766236752\
     !2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!4m13!3e2!4m5!1s0x47e671e554d151e3\
     %3A0xfa89cdfe21b23752!2sPlace+Jussieu!3m2!1d48.84597!\
     2d2.3551297!4m5!1s0x47e671e8c0e6a739%3A0x46ae112e3e572b43!2sPiscine+\
     Jean-Taris%2C+16+Rue+Thouin!3m2!1d48.8447257!2d2.\
     3479414!5e0!3m2!1sfr!2sfr!4v1566935487391!5m2!1sfr!2sfr"

let piscine_page () () =
  Lwt.return @@
  Template.make_page ~title:"Piscine"
    H.[
      h1 [txt "Piscine"];
      p [
        txt "Entre les stages et les plongées en mer, nous nous entraînons \
             deux fois par semaine à la piscine Jean Taris, à 5 minutes \
             à pieds du campus Jussieu.";
      ];
      p [
        txt "Après un baptême, les débutants y apprennent les bases de la \
             plongée avec bouteille dans un environnement adapté, ainsi \
             que des techniques sans scaphandre comme la nage avec palmes \
             ou l'apnée. Les plongeurs déjà brevetés y entretiennent \
             principalement leur condition physique, prérequis \
             indispensable à une immersion en toute sécurité. Enfin, les \
             fameuses parties de ";
        i [txt "fight-polo"];
        txt " rassemblent tout le monde pour des séances intenses, \
             radicales pour évacuer le stress d'une journée de travail ou \
             de partiels...";
      ];
      p [
        txt "Les deux séances sont ouvertes à tous nos \
             adhérents. Elles se déroulent aux horaires suivants :";
      ];
      ul [
        li [txt "Le mardi de 21h à 22h"];
        li [txt "Le samedi de 18h à 19h30"];
      ];
      p [
        txt "Selon l'encadrement, certaines séances, notamment pendant \
             les périodes de vacances scolaires ou de stage, peuvent \
             être annulées. Les adhérents sont alors prévenus \
             à l'avance via nos divers canaux de communication.";
      ];
      div_classes ["grid-x"; "align-center"] [
        div_classes ["cell"; "large-8"; "medium-10"; "small-12"] [
          gmaps_embed ()
        ];
      ];
      Template.thumbnail_row ~subdir:["piscine"] [
        "Un élève en formation", "piscine_1.JPG";
        "Des attractions ludiques pour la piscine", "piscine_2.JPG";
        "Des baptêmes pour le Téléthon", "piscine_3.JPG";
      ];
    ]
