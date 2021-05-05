module H = Html
module Model = News__model
module Service = News__service

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

let deletion_icon_and_modal news =
  let open H in
  let modal_text =
    "Voulez-vous vraiment supprimer l'actu " ^ Model.short_title news ^ " ?" in
  Confirmation_modal.with_modal
    ~service:Service.delete
    modal_text
    (fun ~opens_modal modal ->
       div_classes ["cell"; "text-center"; "large-12"; "small-4"] [
         p [
           Raw.a
             ~a:[opens_modal]
             [Icon.solid "fa-trash" ()]
         ];
         modal;
       ])
    ()
    (Model.id news)
    Model.Id.form_param

let action_icons_callout news =
  let open H in
  div_classes ["callout"; "action-icons"] [
    div_classes ["grid-x"] [
      div_classes
        ["cell"; "text-center"; "large-12"; "small-4"]
        [p [Raw.a [Icon.solid "fa-edit" ()]]];
      deletion_icon_and_modal news;
      div_classes
        ["cell"; "text-center"; "large-12"; "small-4"]
        [p [Raw.a [Icon.solid "fa-eye-slash" ()]]];
    ]
  ]

let article_with_action_icons news =
  let open H in
  div_classes ["grid-x"; "grid-margin-x"; "news"] [
    div_classes
      ["cell"; "large-auto"; "large-order-1"; "small-order-2"]
      [article_ news];
    div_classes
      ["cell"; "large-2"; "large-order-2"; "small-order-1"]
      [action_icons_callout news];
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

let button_to_redaction ?(expanded=false) () =
  let open H in
  a
    ~service:Service.redaction
    ~a:[
      a_class @@
      Utils.with_if expanded "expanded" @@
      ["button"]
    ]
    [txt "Rédiger une actu"]
    ()

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

let redaction_form () =
  let open H in
  let span_form_error text =
    H.span ~a:[H.a_class ["form-error"]] [H.txt text]
  in
  let help_text text =
    H.p ~a:[H.a_class ["help-text"]] [H.txt text]
  in
  Form.post_form
    ~xhr:false (* Mandatory to go through Abide form validation *)
    ~a:[
      a_user_data "abide" "";
      a_novalidate ();
    ]
    ~service:Service.create_into_main
    (fun (title, (short_title, content)) ->
       [

         div
           ~a:[
             a_class ["alert"; "callout"];
             a_user_data "abide-error" "";
             a_style "display: none";
           ]
           [H.txt "Le formulaire contient des erreurs."];

         label [
           txt "Titre";
           Form.input
             ~input_type:`Text
             ~name:title
             ~a:[a_required ()]
             Form.string;
           span_form_error "Vous devez renseigner le titre.";
         ];
         help_text "Le titre principal, affiché en haut de l'actu.";

         label [
           txt "Titre court";
           Form.input
             ~input_type:`Text
             ~name:short_title
             ~a:[a_required ()]
             Form.string;
           span_form_error "Vous devez renseigner le titre court.";
         ];
         help_text "Un titre plus court pour les onglets.";

         label [
           txt "Contenu";
           Form.textarea
             ~name:content
             ~a:[a_required ()]
             ();
           span_form_error "Vous devez renseigner le contenu.";
         ];
         help_text "Le contenu de la news. HTML autorisé.";

         Form.button_no_value
           ~button_type:`Submit
           ~a:[a_class ["button"; "small-only-expanded"]]
           [txt "Valider"];
       ])
    ()
