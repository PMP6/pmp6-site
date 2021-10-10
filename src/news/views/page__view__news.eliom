module Model = Model__news
module Widget = Widget__view__news

let list_all all_news =
  Template_lib.page
    ~title:"Toutes les actus"
    [
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
  Template_lib.page
    ~title:"Rédiger une actu"
    [Widget.redaction_form ()]

let edition news =
  Template_lib.page
    ~title:"Éditer une actu"
    [Widget.redaction_form ~news ()]
