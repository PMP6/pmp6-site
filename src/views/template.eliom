module H = Html

let app_js_script =
  Skeleton.Static.js_script ~a:[H.a_async ()] ["app.js"] ()

let thumbnail alt path =
  let open H in
  img
    ~a:[a_class ["thumbnail"]]
    ~src:(Skeleton.Static.img_uri path)
    ~alt
    ()

let thumbnail_row ?(max_size=12) ~subdir alt_and_filenames =
  let nb_thumbnails =
    List.length alt_and_filenames in
  let thumbnail_size =
    min max_size (12 / nb_thumbnails) in
  let large_size =
    sprintf "large-%d" thumbnail_size in
  let make_cell (alt, filename) =
    H.div_classes [
      "cell";
      "medium-5"; "small-10"; large_size;
      "text-center";
    ] [
      thumbnail alt (subdir @ [filename])
    ]
  in
  H.div_classes [
    "grid-x"; "grid-padding-x";
    "medium-up-2"; "small-up-1";
    "align-center-middle";
  ] (List.map ~f:make_cell alt_and_filenames)

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

let top_menu items =
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

let search_form =
  let create_form =
    let open H in
    fun (as_sitesearch, q) ->
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
  in H.Form.get_form ~service:(Google.Search.service) create_form

let header =
  let open H in
  header [
    menu_toggle ();
    div ~a:[a_class ["top-bar"; "stacked-for-medium"]; a_id "top-menu"] [
      nav ~a:[a_class ["top-bar-left"]] [top_menu Skeleton.hierarchy_items];
      div ~a:[a_class ["top-bar-right"]] [search_form];
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

      div_classes ["cell"; "small-3"; "medium-2"; "large-4"; "icons"] [

        div_classes ["grid-x"; "grid-padding-x"; "align-right"] [
          div_classes ["cell"; "small-6"; "medium-shrink"] [
            a ~service:News.Service.main [
              Icon.solid "fa-tools" ()
            ] ()
          ];

          div_classes ["cell"; "small-6"; "medium-shrink"] [
            anchor_a ~anchor:"top" ~a:[a_user_data "smooth-scroll" ""] [
              Icon.solid "fa-chevron-up" ()
            ]
          ];
        ]
      ]
    ]
  ]

let make_body toasts content =
  (* empty anchor does not work for smooth scroll *)
  H.body ~a:[H.a_id "top"] [
    header;
    carousel;
    main ~toasts ~content;
    footer;
  ]

let return_page { Template_lib.title; in_head; in_body } =
  let _ : unit Eliom_client_value.t = [%client (Foundation.init () : unit)] in
  let%lwt toasts = Toast.render_all () in
  Lwt.return @@
  H.html
    ~a:[H.a_lang "fr"; H.a_class ["no-js"]]
    (head ~other_head:in_head ~title ())
    (make_body toasts in_body)
