module H = Html
module Model = News__model

let news_tab_title ~is_active ~slug news =
  let open H in
  li ~a:[a_class ("tabs-title" :: Utils.is_active_class is_active)] [
    anchor_a ~anchor:slug ~a:[a_user_data "tabs-target" slug]
      [txt news.Model.short_title]
  ]

let news_header (news : Model.t) =
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
        make_elt ~is_active:(i = 0) ~slug:(Model.slug news) (Model.data news)
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
