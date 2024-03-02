module Model = Model__news
module Service = Service__news

module%shared F = Foundation
module%shared H = Html

let tab_slug news = Model.unique_slug ~prefix:"news" news

let news_tab_title ~id i news =
  let is_active = i = 0 in
  let open H in
  let slug = tab_slug news in
  li
    ~a:
      (a_id id
      :: a_class (Utils.cons_is_active is_active [ "tabs-title" ])
      :: F.Toggler.toggler (`Animate (`Fade_in, `Fade_out)))
    [
      fragment_a
        ~fragment:slug
        ~a:[ a_user_data "tabs-target" slug ]
        [ txt @@ Model.short_title news ];
    ]

let header_ news =
  let open H in
  (* Title and pub-time must belong to the same hn class to be vertically aligned *)
  header
    ~a:[ a_class [ "grid-x"; "align-bottom" ] ]
    [
      h1 ~a:[ a_class [ "h4"; "cell"; "auto" ] ] [ txt @@ Model.title news ];
      div_classes
        [ "h4"; "subheader"; "cell"; "shrink" ]
        [ time_ ~a:[ a_class [ "pub-time" ] ] @@ Model.pub_time news ];
    ]

let article_ news = H.article [ header_ news; Model.content_as_div news ]

let deletion_icon_and_modal news =
  let open H in
  let modal_text =
    Fmt.str
      "Voulez-vous vraiment supprimer l'actu %s ? Cette action est définitive. Si vous \
       avez un doute ou que vous souhaitez conserver son contenu, il est préférable de \
       la masquer."
      (Model.short_title news)
  in
  Confirmation_modal.with_modal
    ~service:Service.Admin.delete
    modal_text
    (fun ~opens_modal modal ->
      div_classes
        [ "cell"; "text-center"; "large-12"; "small-4" ]
        [
          p
            [
              Raw.a ~a:[ opens_modal; a_class [ "dangerous" ] ] [ Icon.solid "trash" () ];
            ];
          modal;
        ])
    ()
    (Model.id news)
    Model.Id.form_param

let action_icons_callout news =
  let open H in
  F.Callout.create
    ~a:[ H.a_class [ "action-icons" ] ]
    [
      div_classes
        [ "grid-x" ]
        [
          div_classes
            [ "cell"; "text-center"; "large-12"; "small-4" ]
            [
              p
                [
                  a
                    ~service:Service.Admin.edition
                    [ Icon.solid "edit" () ]
                    (Model.id news);
                ];
            ];
          deletion_icon_and_modal news;
        ];
    ]

let article_with_action_icons news =
  let open H in
  div_classes
    [ "grid-x"; "grid-margin-x"; "news" ]
    [
      div_classes
        [ "cell"; "large-auto"; "large-order-1"; "small-order-2" ]
        [ article_ news ];
      div_classes
        [ "cell"; "large-2"; "large-order-2"; "small-order-1" ]
        [ action_icons_callout news ];
    ]

let news_tabs_panel ~show_actions i news =
  let is_active = i = 0 in
  let open H in
  let slug = tab_slug news in
  div
    ~a:[ a_id slug; a_class @@ Utils.cons_is_active is_active @@ [ "tabs-panel" ] ]
    [ (if show_actions then article_with_action_icons news else article_ news) ]

let button_to_redaction ?(expanded = false) () =
  let open H in
  a
    ~service:Service.Admin.redaction
    ~a:[ a_class @@ Utils.cons_if expanded "expanded" @@ [ "button" ] ]
    [ txt "Rédiger une actu" ]
    ()

let switch hidden_ids =
  let open H in
  let input_id = new_id () in
  F.Grid.x
    [
      F.Grid.cell
        ~small:4
        [
          F.Switch.create
            ~on:()
            ~input_id
            ~size:`Tiny
            ~a:[ F.Toggler.toggle hidden_ids ]
            ~show_for_sr:"Alterner l'affichage des actus masquées"
            ();
        ];
      F.Grid.cell
        ~small:8
        [ label ~a:[ a_label_for input_id ] [ txt "Afficher invisibles" ] ];
    ]

let news_tabs_titles ~vertical ~show_actions all_news =
  let open H in
  let hidden_ids, tab_titles =
    List.foldi
      ~f:(fun i (acc_hidden, acc_tab_titles) news ->
        let id = new_id () in
        ( (if Model.is_invisible news then id :: acc_hidden else acc_hidden),
          news_tab_title ~id i news :: acc_tab_titles ))
      ~init:([], [])
      all_news
  in

  div
    (Utils.cons_if show_actions (switch hidden_ids)
    @@ [
         ul
           ~a:
             [
               a_class @@ Utils.cons_vertical vertical [ "tabs" ];
               a_user_data "tabs" "";
               a_id "tabs-news";
             ]
           tab_titles;
       ])

let news_tabs_content ~vertical ~show_actions all_news =
  let open H in
  div
    ~a:
      [
        a_class
        @@ Utils.cons_vertical vertical
        @@ Utils.cons_if vertical "gapped"
        @@ [ "tabs-content" ];
        a_user_data "tabs-content" "tabs-news";
      ]
    (List.mapi ~f:(news_tabs_panel ~show_actions) all_news)

let news_tabs ?(vertical = false) ?(show_actions = false) news =
  ( news_tabs_titles ~vertical ~show_actions news,
    news_tabs_content ~vertical ~show_actions news )

let%shared make_preview_callout content =
  match content with
  | None -> H.div []
  | Some content ->
      F.Callout.primary (H.h2 ~a:[ H.a_class [ "h4" ] ] [ H.txt "Aperçu" ] :: content)

let redaction_form ?news () =
  (* If news is passed, edition form. Otherwise, redaction. *)
  let open H in
  let prefilled_with f = Option.value_map ~default:"" ~f news in
  let update_pubtime_checkbox name =
    label
      [
        Form.bool_checkbox_one ~checked:false ~name ();
        txt "Mettre à jour la date et l'heure";
      ]
  in
  let form_with_holes
      id_hidden_input update_pubtime_checkbox (title, (short_title, (content, is_visible)))
      =
    let content_textarea =
      Form.textarea
        ~name:content
        ~a:[ F.Abide.required (); a_rows 10 ]
        ~value:(prefilled_with Model.content_as_md)
        ()
    in
    let preview_button =
      H.Form.button_no_value
        ~button_type:`Button
        ~a:[ H.a_class [ "button"; "secondary"; "small-only-expanded" ] ]
        [ H.txt "Prévisualiser" ]
    in
    let content, refresh_content = Eliom_shared.React.S.create None in
    let (_ : unit Lwt.t Eliom_client_value.t) =
      Caml.(
        [%client
          Js_of_ocaml_lwt.Lwt_js_events.clicks
            (Eliom_content.Html.To_dom.of_element ~%preview_button)
            (fun _ _ ->
              let content = Html.textarea_content ~%content_textarea in
              let%lwt content_html = Doc.render_from_md content in
              ~%refresh_content (Some content_html);
              Lwt.return ())])
    in
    let preview_callout =
      Eliom_shared.React.S.map Caml.([%shared make_preview_callout]) content
    in
    [
      F.Abide.abide_error [ H.txt "Le formulaire contient des erreurs." ];
      label
        [
          txt "Titre";
          Form.input
            ~input_type:`Text
            ~name:title
            ~a:[ F.Abide.required () ]
            ~value:(prefilled_with Model.title)
            Form.string;
          F.Abide.form_error "Vous devez renseigner le titre.";
        ];
      F.Form.help_txt "Le titre principal, affiché en haut de l'actu.";
      label
        [
          txt "Titre court";
          Form.input
            ~input_type:`Text
            ~name:short_title
            ~a:[ F.Abide.required () ]
            ~value:(prefilled_with Model.short_title)
            Form.string;
          F.Abide.form_error "Vous devez renseigner le titre court.";
        ];
      F.Form.help_txt "Un titre plus court pour les onglets.";
      label
        [
          txt "Contenu";
          content_textarea;
          F.Abide.form_error "Vous devez renseigner le contenu.";
        ];
      F.Form.help_text
        [
          H.txt "Le contenu de la news. HTML et ";
          H.raw_a ~href:"https://www.markdownguide.org/cheat-sheet/" [ H.txt "Markdown" ];
          H.txt " autorisés.";
        ];
      fieldset
        ~legend:(legend [ txt "Options" ])
        ([
           label
             [
               Form.bool_checkbox_one
                 ~checked:(Option.value_map ~f:Model.is_visible ~default:false news)
                 ~name:is_visible
                 ();
               txt "Actu visible";
             ];
         ]
        |> Utils.cons_opt update_pubtime_checkbox);
      H.div_class
        "button-group"
        [
          Form.button_no_value
            ~button_type:`Submit
            ~a:[ a_class [ "button"; "small-only-expanded" ] ]
            [ txt "Valider" ];
          preview_button;
        ];
      Eliom_content.Html.R.node preview_callout;
    ]
    |> Utils.cons_opt id_hidden_input
  in
  let creation_form names = form_with_holes None None names in
  let edition_form item (hidden_input_name, (update_pubtime_checkbox_name, names)) =
    form_with_holes
      (Some (Model.id_hidden_input hidden_input_name item))
      (Some (update_pubtime_checkbox update_pubtime_checkbox_name))
      names
  in
  match news with
  | Some news ->
      F.Abide.post_form ~service:Service.Admin.update_into_main (edition_form news) ()
  | None -> F.Abide.post_form ~service:Service.Admin.create_into_main creation_form ()
