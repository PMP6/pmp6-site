module%client H = Html
module H = Html
module F = Foundation
open%client Js_of_ocaml
open%client Js_of_ocaml_lwt

let page_title () =
  let open H in
  let poulpe () =
    img
      ~src:(Skeleton.Static.img_uri [ "pmp6-poulpe.png" ])
      ~alt:"Le poulpe, notre mascotte"
      ()
  in
  h1 [ poulpe (); txt " Bienvenue à PMP6 ! "; poulpe () ]

let presentation_section () =
  let open H in
  section
    ~a:[ a_id "presentation" ]
    [
      p
        [
          txt
            "Club de plongée associatif de Sorbonne Université, nous sommes ouverts à \
             tous les étudiants et personnels de l'université ainsi qu'aux anciens \
             inscrits.";
        ];
      p
        [
          txt
            "Encadrés par une vingtaine de moniteurs bénévoles, nous proposons des \
             formations à tous les niveaux de plongeur ainsi qu'un accompagnement pour \
             ceux qui désirent se préparer aux niveaux d'encadrement.";
        ];
      p
        [
          txt
            "Notre entraînement hebdomadaire se déroule à la piscine Jean Taris, dans le \
             V";
          sup [ txt "ème" ];
          txt
            ". Nous proposons également des séances régulières en fosse pour travailler \
             la technique jusqu'à 20m de profondeur. Enfin, nous organisons des stages \
             en milieu naturel pour valider les niveaux... et pour le plaisir de \
             plonger !";
        ];
      p
        [
          txt
            "N'hésitez pas à parcourir les différentes sections de ce site pour plus \
             d'informations. Si vous avez des questions, vous pouvez aussi contacter nos \
             délégués à l'adresse ";
          email "delegues@pmp6.fr" ();
          txt ".";
        ];
      Widget.thumbnail_row
        ~max_size:4
        ~subdir:[]
        [ ("Un mola-mola à Banyuls", "mola-mola.jpg") ];
    ]

let make_news_section news =
  let open H in
  let tabs_titles, tabs_contents = News.View.Widget.news_tabs news in
  section
    ~a:[ a_id "section-news"; a_class [ "news" ] ]
    [
      h2 [ txt "Suivez l'actu..." ];
      hr ();
      F.Grid.padding_x
        [
          F.Grid.cell ~large_auto:() ~medium:12 [ tabs_titles; tabs_contents ];
          F.Grid.cell
            ~large_shrink:()
            ~medium:12
            ~a:[ H.class_ "text-center" ]
            [ F.Callout.create [ Facebook.page_widget () ] ];
        ];
    ]

let fetch_and_make_news_section () =
  let%map.Lwt news = News.Model.visible () in
  make_news_section news

let home_page () () =
  let%lwt news_section = fetch_and_make_news_section () in
  Content.page
    ~title:"PMP6"
    [ page_title (); H.hr (); presentation_section (); news_section ]
