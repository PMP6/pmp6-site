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

let mola_mola () =
  Widget.thumbnail_row
    ~max_size:8
    ~subdir:[]
    [ ("Un mola-mola à Banyuls", "mola-mola.jpg") ]

let presentation_section () =
  let open H in
  section
    ~a:[ a_id "presentation" ]
    [
      h1 ~a:[ a_class_ "h3" ] [ txt "Qui sommes-nous ?" ];
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
            "Encadrés par nos moniteurs bénévoles, nous proposons des formations à tous \
             les niveaux de plongeur ainsi qu'une préparation aux niveaux d'encadrement.";
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
          txt "Pour plus d'informations, vous pouvez contacter nos délégués à l'adresse ";
          email "delegues@pmp6.fr" ();
          txt ".";
        ];
      mola_mola ();
    ]

let news_section news =
  let open H in
  let tabs_titles, tabs_contents = News.View.Widget.news_tabs news in
  section
    ~a:[ a_id "section-news"; a_class [ "news" ] ]
    [ h1 ~a:[ a_class_ "h3" ] [ txt "Actualités" ]; hr (); tabs_titles; tabs_contents ]

let top_section news =
  let open H in
  section
    ~a:[ a_id "section-news"; a_class [ "news" ] ]
    [
      F.Grid.padding_x
        [
          F.Grid.cell ~large:6 ~medium:12 [ H.div [ presentation_section () ] ];
          F.Grid.cell ~large:6 ~medium:12 [ F.Callout.create [ news_section news ] ];
        ];
    ]

let fetch_and_make_top_section () =
  let%map.Lwt news = News.Model.visible () in
  top_section news

let callendar_callout () = F.Callout.create [ Calendar_widget.calendar () ]

let home_page () () =
  let%lwt top_section = fetch_and_make_top_section () in
  Content.page ~title:"PMP6" [ page_title (); top_section; callendar_callout () ]
