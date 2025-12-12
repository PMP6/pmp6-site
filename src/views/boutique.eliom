module H = Html

let intro () =
  H.
    [
      p
        [
          txt
            "Nous passons par AssoConnect pour permettre aux adhérents de régler divers \
             frais en ligne. Vous pouvez accéder directement aux paiements principaux \
             sur cette page.";
        ];
      p
        [
          txt
            "L'utilisation de ce service est réservée aux membres de l'ASSU SIM. Pensez \
             à contacter les encadrants pour vous assurer que votre demande est prise en \
             compte.";
        ];
    ]

(* Utility to ease card definitions *)
let make_card_cell ~title ~img:(img_filename, img_alt) ~href content =
  Foundation.Grid.cell
    ~small:10
    ~medium:5
    ~large:5
    [
      Foundation.Card.divider [ H.h1 ~a:[ H.a_class [ "h3" ] ] [ H.txt title ] ];
      H.raw_a
        ~href
        [
          H.img
            ~src:(Skeleton.Static.img_uri [ "boutique"; img_filename ])
            ~alt:img_alt
            ();
        ];
      Foundation.Card.section content;
    ]

let card_licence () =
  let href =
    "https://association-sportive-de-sorbonne-sim.assoconnect.com/collect/description/640444-b-souscrire-une-licence-ffessm-2025-2026"
  in
  make_card_cell
    ~title:"Licence FFESSM"
    ~img:("ffessm.svg", "Logo FFESSM")
    ~href
    [
      H.p
        [
          H.txt
            "La licence est valable du 15 septembre au 31 décembre de l'année suivante. \
             Elle est nécessaire dès lors que vous passez un brevet, ainsi que pour \
             certains stages.";
        ];
      H.p [ H.raw_a ~href [ H.txt "Acheter ma licence sur AssoConnect" ] ];
    ]

let card_certification () =
  let href =
    "https://association-sportive-de-sorbonne-sim.assoconnect.com/collect/description/640475-h-achat-d-une-carte-de-brevet"
  in
  make_card_cell
    ~title:"Carte de niveau"
    ~img:("cmas-formation-niveau-2.jpeg", "Carte de certification CMAS niveau 2")
    ~href
    [
      H.p
        [
          H.txt
            "Ce paiement peut être effectué dès lors que votre niveau a été validé par \
             l'encadrant responsable. Vous pourrez alors recevoir votre carte \
             d'attestation.";
        ];
      H.p [ H.raw_a ~href [ H.txt "Acheter ma carte de niveau sur AssoConnect" ] ];
    ]

let purchase_cards () =
  [
    Foundation.Grid.margin_x
      ~a:[ H.a_class [ "align-spaced" ] ]
      [ card_licence (); card_certification () ];
  ]

let boutique_page () () =
  Content.page
    ~title:"Boutique"
    H.[ h1 [ txt "Boutique" ]; section @@ intro (); section @@ purchase_cards () ]
