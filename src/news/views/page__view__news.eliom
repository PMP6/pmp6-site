module Model = Model__news
module Widget = Widget__view__news
module H = Html

let list_all news =
  let tabs_titles, tabs_contents =
    Widget.news_tabs ~vertical:true ~show_actions:true news
  in
  Content.page
    ~title:"Toutes les actus"
    [
      H.h1 [ H.txt "Toutes les actus" ];
      Html.div_classes
        [ "grid-x"; "grid-margin-x"; "news" ]
        [
          Html.div_classes
            [ "cell"; "large-2" ]
            [ Widget.button_to_redaction ~expanded:true (); tabs_titles ];
          Html.div_classes [ "cell"; "large-10" ] [ tabs_contents ];
        ];
    ]

let redaction () =
  Content.page
    ~title:"Rédiger une actu"
    [ H.h1 [ H.txt "Rédiger une actu" ]; Widget.redaction_form () ]

let edition news =
  Content.page
    ~title:"Éditer une actu"
    [ H.h1 [ H.txt "Éditer une actu" ]; Widget.redaction_form ~news () ]
