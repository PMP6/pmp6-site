module H = Html

let app_js_script =
  Skeleton.Static.js_script ~a:[H.a_async ()] ["app.js"] ()

let gfont_uri =
  let fonts = [
    "Muli";
    "Kaushan+Script";
    "Open+Sans";
    "Oswald";
    "Inconsolata";
  ] in
  Printf.ksprintf Eliom_content.Xml.uri_of_string
    "https://fonts.googleapis.com/css?family=%s"
    (String.concat ~sep:"%7c" fonts)

let favicon_link ~size =
  let favicon_filename =
    Printf.sprintf "favicon-%dx%d.png" size size in
  let favicon_uri =
    Skeleton.Static.img_uri ["favicons"; favicon_filename] in
  H.(
    link
      ~rel:[`Icon]
      ~a:[a_mime_type "image/png"; a_sizes (Some [size, size])]
      ~href:favicon_uri
      ()
  )

let head ?(other_head=[]) ~title () =
  H.head (H.title (H.txt title)) @@ H.[
    meta ~a:[a_http_equiv "x-ua-compatible"; a_content "ie=edge"] ();
    meta ~a:[a_name "viewport"; a_content "width=device-width, initial-scale=1.0"] ();
    meta ~a:[a_name "theme-color"; a_content "#ffffff"] ();
    css_link ~uri:(Skeleton.Static.css_uri ["app.css"]) ();
    css_link ~uri:gfont_uri ();
    app_js_script;
    favicon_link ~size:16;
    favicon_link ~size:32;
    Google.Analytics.gtag_manager ();
    Google.Analytics.gtag ();
  ] @ other_head

let menu_title () =
  let open H in
  a
    ~service:Skeleton.home_service
    ~a:[a_class ["top-title"]]
    [
      img
        ~src:(Skeleton.Static.img_uri ["pavillon-alpha.png"])
        ~alt:"Pavillon alpha"
        ~a:[a_class ["show-for-large"]]
        ();
      txt " PMP6";
    ] ()

let menu_title_entry () =
  H.(
    li ~a:[a_class ["show-for-large"]] [menu_title ()]
  )

let menu_toggle () =
  let open H in
  div_class "title-bar"
    ~a:[
      a_user_data "responsive-toggle" "top-menu";
      a_user_data "hide-for" "large";
    ] [
    button ~a:[
      a_class ["menu-icon"];
      a_button_type `Button;
      a_user_data "toggle" "top-menu";
    ] [];
    div_class "title-bar-title" [menu_title ()];
  ]

let top_left_menu items =
  let open H in
  let rec entry (content, hierarchical_site_item) =
    match hierarchical_site_item with
    | Eliom_tools.Disabled ->
      None
    | Eliom_tools.(Site_tree (main_page, items)) ->
      let li_class, submenu = match items with
        | [] ->
          [] , []
        | _ :: _ ->
          [a_class ["is-dropdown-submenu-parent"]],
          [ul ~a:[a_class ["menu"]] @@ List.filter_map ~f:entry items]
      in
      let a_elt = match main_page with
        | Not_clickable ->
          Raw.a [content]
        | Default_page srv
        | Main_page srv ->
          let Srv service = srv in
          a ~service [content] ()
      in Some (li ~a:li_class (a_elt :: submenu))
  in
  ul ~a:[
    a_class [
      "menu";
      "vertical";
      "large-horizontal";
    ];
    a_user_data
      "responsive-menu"
      "accordion large-dropdown";
    a_user_data "click-open" "true";
  ] @@
  menu_title_entry () :: List.filter_map ~f:entry items

let search_form () =
  let open H in
  H.Form.get_form
    ~a:[a_class ["search-form"]]
    ~service:Google.Search.service
  @@ fun (as_sitesearch, q) ->
  [
    Form.input ~input_type:`Hidden ~name:as_sitesearch ~value:"pmp6.fr" Form.string;
    div_classes ["input-group"] [
      Form.input
        ~input_type:`Search ~name:q
        ~a:[a_placeholder "Rechercher"; a_class ["input-group-field"]]
        Form.string;
      div_classes ["input-group-button"] [
        Form.button_no_value
          ~button_type:`Submit ~a:[a_class ["button"]]
          [Icon.solid "fa-search" ()];
      ]
    ]
  ]

let top_right_menu user =
  let open H in
  let connection =
    li [Auth.View.Widget.connection_icon ()] in
  let _user_menu =
    li ~a:[a_class ["menu-text"]] [Auth.View.Widget.user_menu_icon ()] in
  let user_menu =
    Auth.View.Widget.user_menu () in
  let admin =
    li [Admin.View.Widget.interface_icon ()] in
  let search =
    li ~a:[a_class ["menu-text"; "search-form"]] [search_form ()] in
  ul
    ~a:[
      a_class ["menu"; "vertical"; "large-horizontal"];
      a_user_data
        "responsive-menu"
        "accordion large-dropdown";
      a_user_data "click-open" "true";
    ]
    (
      Utils.with_if (Option.exists ~f:Auth.Model.User.is_staff user) admin @@
      Utils.with_opt user ~some:user_menu ~none:connection @@
      [search]
    )

let header user =
  let open H in
  header [
    menu_toggle ();
    div ~a:[a_class ["top-bar"; "stacked-for-medium"]; a_id "top-menu"] [
      nav ~a:[a_class ["top-bar-left"]] [top_left_menu Skeleton.hierarchy_items];
      div ~a:[a_class ["top-bar-right"]] [top_right_menu user];
    ]
  ]

let carousel =
  Carousel.elt ()

let main ~toasts ~content =
  let open H in
  H.main
    ~a:[a_class ["grid-container"; "content"]]
    (toasts @ content)

let footer =
  let open H in
  footer [
    div_classes ["grid-x"; "grid-padding-x"; "align-left"] [

      div_classes ["cell"; "small-1"; "medium-2"; "large-4"; "icons"] [
        div_classes ["grid-x"; "grid-padding-x"] [
          div_classes ["cell"; "auto"] [
            a
              ~service:(Facebook.page_service ())
              ~a:[a_target "_blank"]
              [Icon.brands "fa-facebook-f" ()] ();
          ]
        ]
      ];

      div_classes
        ["cell"; "small-6"; "small-offset-2"; "medium-8"; "medium-offset-0"; "large-4"]
        ~a:[a_id "immatriculation"] [
        txt "ASSU SIM";
        br ();
        txt "FFESSM 07750038";
      ];

      div_classes ["cell"; "small-1"; "small-offset-2"; "large-offset-3"; "icons"] [
        anchor_a ~anchor:"top" ~a:[a_user_data "smooth-scroll" ""] [
          Icon.solid "fa-chevron-up" ()
        ]
      ]
    ]
  ]

let make_body user toasts content =
  (* empty anchor does not work for smooth scroll *)
  H.body ~a:[H.a_id "top"] [
    header user;
    carousel;
    main ~toasts ~content;
    footer;
  ]

let return_page { Content.title; in_head; in_body } =
  let _ : unit Eliom_client_value.t = [%client Foundation.init ()] in
  let%lwt toasts = Toast.render_all () in
  let%lwt user = Auth.Session.get_user () in
  Lwt.return @@
  H.html
    ~a:[H.a_lang "fr"; H.a_class ["no-js"]]
    (head ~other_head:in_head ~title ())
    (make_body user toasts in_body)
