module H = Html
module Model = News__model

let tab_slug news =
  Model.unique_slug ~prefix:"news" news

let news_tab_title i news =
  let is_active = i = 0 in
  let open H in
  let slug = tab_slug news in
  li ~a:[a_class @@ Utils.with_is_active is_active ["tabs-title"]] [
    anchor_a ~anchor:slug ~a:[a_user_data "tabs-target" slug]
      [txt @@ Model.short_title news]
  ]

let header_ news =
  let open H in
  (* Title and pub-time must belong to the same hn class to be
     vertically aligned *)
  header ~a:[a_class ["grid-x"; "align-bottom"]] [
    h3 ~a:[a_class ["h4"; "cell"; "auto"]] [txt @@ Model.title news];
    div_classes ["h4"; "subheader"; "cell"; "shrink"] [
      time_ ~a:[a_class ["pub-time"]] @@ Model.pub_time news
    ]
  ]

let article_ news =
  H.article [
    header_ news;
    Model.content news;
  ]

let action_icons_callout _news =
  let open H in
  div_classes ["callout"; "action-icons"] [
    div_classes ["grid-x"] [
      div_classes ["cell"; "text-center"] [p [Raw.a [Icon.solid "fa-edit" ()]]];
      div_classes ["cell"; "text-center"] [p [Raw.a [Icon.solid "fa-trash" ()]]];
      div_classes ["cell"; "text-center"] [p [Raw.a [Icon.solid "fa-eye-slash" ()]]];
    ]
  ]

let article_with_action_icons news =
  let open H in
  div_classes ["grid-x"; "grid-margin-x"; "news"] [
    div_classes ["cell"; "large-auto"] [article_ news];
    div_classes ["cell"; "large-2"] [action_icons_callout news];
  ]

let news_tabs_panel ~display_action_icons i news =
  let is_active = i = 0 in
  let open H in
  let slug = tab_slug news in
  div
    ~a:[
      a_id slug;
      a_class @@ Utils.with_is_active is_active @@ ["tabs-panel"];
    ]
    [
      if display_action_icons
      then article_with_action_icons news
      else article_ news
    ]

let news_tabs ?(vertical=false) all_news =
  let open H in
  ul
    ~a:[
      a_class @@ Utils.with_vertical vertical ["tabs"];
      a_user_data "tabs" ""; a_id "tabs-news"
    ]
    (List.mapi ~f:news_tab_title all_news)

let news_tabs_content ?(vertical=false) ?(display_action_icons=false) all_news =
  let open H in
   div
     ~a:[
       a_class @@
       Utils.with_vertical vertical @@
       Utils.with_if vertical "gapped" @@
       ["tabs-content"];
       a_user_data "tabs-content" "tabs-news";
    ]
    (List.mapi ~f:(news_tabs_panel ~display_action_icons) all_news)
