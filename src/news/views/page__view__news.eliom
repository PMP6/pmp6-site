module Model = Model__news
module Widget = Widget__view__news

module H = Html

let list_all all_news =
  Content.page
    ~title:"Toutes les actus"
    [
      H.h1 [H.txt "Toutes les actus"];
      Html.div_classes ["grid-x"; "grid-margin-x"; "news"]
        [
          Html.div_classes ["cell"; "large-2"] [
            Widget.button_to_redaction ~expanded:true ();

            Widget.news_tabs
              ~vertical:true
              all_news
          ];

          Html.div_classes ["cell"; "large-10"] [
            Widget.news_tabs_content
              ~vertical:true
              ~display_action_icons:true
              all_news
          ];

        ]
    ]

let redaction () =
  Content.page
    ~title:"Rédiger une actu"
    [
      H.h1 [H.txt "Rédiger une actu"];
      Widget.redaction_form ()
    ]

let edition news =
  Content.page
    ~title:"Éditer une actu"
    [
      H.h1 [H.txt "Éditer une actu"];
      Widget.redaction_form ~news ();
    ]
