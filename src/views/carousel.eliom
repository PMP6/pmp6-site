module H = Html

let images =
  let img_uri filename =
    Skeleton.Static.img_uri ["carousel"; filename] in
  List.map
    ~f:(Tuple2.map_fst ~f:img_uri)
    [
      "port.jpeg", "Le port de Banyuls";
      "galathée.jpeg", "Galathée";
      "plongeur.jpeg", "Un plongeur";
      "crevettes.jpeg", "Crevettes";
      "blennie.jpeg", "Blennie";
      "denti.jpeg", "Denti";
      "murène.jpeg", "Murène";
      "nudibranche.jpeg", "Nudibranche";
      "phoque.jpeg", "Phoque";
      "serpule.jpeg", "Serpule";
    ]

let slide ~is_active ~src ~caption =
  H.li ~a:[H.a_class @@ Utils.cons_is_active is_active ["orbit-slide"]] [
    H.figure
      ~a:[H.a_class ["orbit-figure"]]
      [H.img ~a:[H.a_class ["orbit-image"]] ~src ~alt:caption ()]
  ]

let slides =
  List.mapi
    ~f:(
      fun i (src, caption) ->
        slide ~is_active:(i = 0) ~src ~caption
    )

let bullet ~is_active ~caption ~slide_number =
  H.button
    ~a:(Utils.cons_is_active_attrib is_active @@
        [H.a_user_data "slide" (Int.to_string slide_number)])
    (H.span ~a:[H.a_class ["show-for-sr"]] [H.txt caption] ::
     if is_active
     then [H.span ~a:[H.a_class ["show-for-sr"]] [H.txt "Photo en cours"]]
     else [])

let bullets images =
  (* is_active parameter will be true only for the first slide *)
  List.mapi
    ~f:(
      fun slide_number (_src, caption) ->
        bullet ~is_active:(slide_number = 0) ~caption ~slide_number
    )
    images
  |> List.intersperse ~sep:(H.txt " ")

let make_elt images =
  let open H in
  div_classes ["orbit"; "carrousel-photos-plongeur"]
    ~a:[
      a_user_data "orbit" "";
      a_user_data "options"
        "animInFromLeft:fade-in; \
         animInFromRight:fade-in; \
         animOutToLeft:fade-out; \
         animOutToRight:fade-out;";
      a_role ["region"];
      a_aria "label" ["Images de plongeurs"];
    ]
    [
      div_class "orbit-wrapper" [
        div_classes ["orbit-controls"; "show-for-large"] [
          button ~a:[a_class ["orbit-previous"]] [
            span ~a:[a_class ["show-for-sr"]] [txt "Photo précédente"];
            Icon.solid "fa-chevron-left" ~transform:["grow-10"] ();
          ];
          button ~a:[a_class ["orbit-next"]] [
            span ~a:[a_class ["show-for-sr"]] [txt "Photo suivante"];
            Icon.solid "fa-chevron-right" ~transform:["grow-10"] ();
          ]
        ];
        ul ~a:[a_class ["orbit-container"]] (slides images)
      ];
      nav ~a:[a_class ["orbit-bullets"]] (bullets images);
    ]

let elt () =
  make_elt images
