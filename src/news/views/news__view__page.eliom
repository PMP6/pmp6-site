module Model = News__model
module Widget = News__view__widget

let list_all all_news =
  Template.return_page
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
  Template.return_page
    ~title:"Rédiger une actu"
    [Widget.redaction_form ()]
