module%client H = Html
module H = Html

open%client Js_of_ocaml
open%client Js_of_ocaml_lwt

let presentation_section () =
  let open H in
  let poulpe () =
    img
      ~src:(Skeleton.Static.img_uri ["pmp6-poulpe.png"])
      ~alt:"Le poulpe, notre mascotte"
      () in
  section ~a:[a_id "presentation"] [
    h1 [poulpe (); txt " Bienvenue à PMP6 ! "; poulpe ()];
    hr ();
    p [
      txt "Club de plongée associatif de Sorbonne Université, nous \
           sommes ouverts à tous les étudiants et personnels de \
           l'université ainsi qu'aux anciens inscrits.";
    ];
    p [
      txt "Encadrés par une vingtaine de moniteurs bénévoles, nous \
           proposons des formations à tous les niveaux de plongeur \
           ainsi qu'un accompagnement pour ceux qui désirent se \
           préparer aux niveaux d'encadrement."
    ];
    p [
      txt "Notre entraînement hebdomadaire se déroule à la piscine \
           Jean Taris, dans le V"; sup [txt "ème"];
      txt ". Nous proposons également des séances régulières en fosse \
           pour travailler la technique jusqu'à 20m de \
           profondeur. Enfin, nous organisons des stages en milieu \
           naturel pour valider les niveaux... et pour le plaisir de \
           plonger !"
    ];
    p [
      txt "N'hésitez pas à parcourir les différentes sections de ce \
           site pour plus d'informations. Si vous avez des questions, \
           vous pouvez aussi contacter nos délégués à l'adresse ";
      email "delegues@pmp6.fr" ();
      txt ".";
    ];
    Template.thumbnail_row
      ~max_size:4
      ~subdir:[]
      ["Un mola-mola à Banyuls", "mola-mola.jpg"];
  ]

let news_tab_title ~is_active ~slug news =
  let open H in
  li ~a:[a_class ("tabs-title" :: Utils.is_active_class is_active)] [
    anchor_a ~anchor:slug ~a:[a_user_data "tabs-target" slug]
      [txt news.News.Model.short_title]
  ]

let news_header (news : News.Model.t) =
  let open H in
  (* Title and pub-time must belong to the same hn class to be
     vertically aligned *)
  header ~a:[a_class ["grid-x"; "align-bottom"]] [
    h3 ~a:[a_class ["h4"; "cell"; "auto"]] [txt news.title];
    div_classes ["h4"; "subheader"; "cell"; "shrink"] [
      time_ ~a:[a_class ["pub-time"]] news.pub_time
    ]
  ]

let news_tabs_panel ~is_active ~slug news =
  let open H in
  div_classes ("tabs-panel" :: Utils.is_active_class is_active) ~a:[a_id slug] [
    article [
      news_header news;
      news.content
    ]
  ]

let news_elts make_elt all_news =
  List.mapi
    ~f:(
      fun i news ->
        make_elt ~is_active:(i = 0) ~slug:(News.Model.slug news) (News.Model.data news)
    )
    all_news

let news_tabs all_news =
  let open H in
  ul
    ~a:[a_class ["tabs"]; a_user_data "tabs" ""; a_id "tabs-news"]
    (news_elts news_tab_title all_news)

let news_tabs_content all_news =
  let open H in
  div_class "tabs-content"
    ~a:[a_user_data "tabs-content" "tabs-news"]
    (news_elts news_tabs_panel all_news)

let make_news_section all_news =
  let open H in
  section ~a:[a_id "section-news"; a_class ["news"]] [
    h2 [txt "Suivez l'actu..."];
    hr ();
    div_classes ["grid-x"; "grid-padding-x"] [
      div_classes ["large-auto"; "medium-12"; "cell"]
        [news_tabs all_news; news_tabs_content all_news];
      div_classes ["large-shrink"; "medium-12"; "cell"; "text-center"] [
        div_class "callout" [
          Facebook.page_widget ()
        ]
      ]
    ]
  ]

let fetch_and_make_news_section () =
  let open Lwt_result.Infix in
  News.Model.get_all () >|=
  make_news_section

let home_page () () =
  match%lwt fetch_and_make_news_section () with
  | Ok news_section ->
    Lwt.return @@
    Template.make_page ~title:"PMP6" [
      presentation_section ();
      news_section;
    ]
  | Error e -> failwith (Caqti_error.show e)
