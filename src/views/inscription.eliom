module H = Eliom_content.Html.D

module AS = struct
  let page_service =
    Eliom_service.extern
      ~prefix:"https://as.upmc.fr"
      ~path:["gestion"; "index.php"]
      ~meth:(Eliom_service.Get (Eliom_parameter.int "page"))
      ()

  let contact = 22
end

let caci_service =
  Eliom_service.extern
    ~prefix:"https://ffessm.fr"
    ~path:["ckfinder"; "userfiles"; "files"; "pdf"; "CACI_V_05_2018.pdf"]
    ~meth:(Eliom_service.Get Eliom_parameter.unit)
    ()

let inscription_page () =
  Template.make_page ~title:"Inscription"
    H.[
      h1 [txt "Inscription au club"];
      h2 [txt "Qui ?"];
      p [
        txt "L'inscription au club est ouverte aux étudiants et \
             personnels de Sorbonne Université, ainsi qu'aux anciens \
             inscrits.";
      ];
      p [
        txt "Les étudiants d'autres écoles ou universités peuvent \
             également s'inscrire sous réserve de la signature d'une \
             convention entre l'Association Sportive dont ils relèvent \
             et celle de la Faculté des Sciences et Ingénierie de \
             Sorbonne Université. Si cette convention n'existe pas \
             encore, il est possible de demander à la mettre en \
             place : ";
        a ~service:Skeleton.Contact.service [txt "contactez nous"] ();
        txt " pour plus d'informations.";
      ];
      h2 [txt "Comment ?"];
      p [
        txt "Pour s'inscrire à la section plongée, il faut d'abord \
             s'inscrire à l'";
        a ~service:AS.page_service [txt "AS"] AS.contact;
        txt ". Vous pourrez ensuite choisir la plongée parmi la liste \
             des sports sur le portail dédié.";
      ];
      p [
        txt "L'inscription est possible tout au long de \
             l'année. Toutefois, nos capacités d'encadrement sont \
             limitées, et il nous faut un minimum de temps pour former \
             un plongeur : si vous débutez, nous vous conseillons donc \
             de vous y prendre dès la rentrée !";
      ];
      h2 [txt "Documents nécessaires"];
      p [
        txt "Le coût total d'inscription à la section dépend de votre \
             statut (étudiant, personnel ou extérieur). Il est composé \
             de la cotisation de base à l'AS et d'une contribution \
             supplémentaire spécifique pour la plongée. Cette \
             contribution permet d'assurer l'achat, l'entretien et le \
             renouvellement du matériel, ainsi que la réservation des \
             séances de fosse et de piscine.";
      ];
      p [
        txt "Vous aurez besoin pour vous inscrire d'un certificat \
             médical d'absence de contre-indication à la plongée, sur ";
        a ~service:caci_service [txt "ce modèle"] ();
        txt " (ou similaire). Sauf précision contraire (sur le \
             certificat), il peut être signé par un médecin \
             généraliste.";
      ];
      p [
        txt "Vous aurez également besoin d'un document correspondant à votre statut :";
      ];
      ul [
        li [txt "Pour les étudiants de Sorbonne Université, la carte d'étudiant ;"];
        li [txt "Pour les étudiants en convention, la carte de l'AS de votre lieu d'étude ;"];
        li [txt "Pour les membres du personnel, une fiche de paye ;"];
        li [txt "Pour les anciens membres, une ancienne carte de l'AS."];
      ];
    ]
