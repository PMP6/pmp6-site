module Maps = struct

  let embed pb =
    let open Html in
    let service =
      Eliom_service.extern
        ~prefix:"https://www.google.com"
        ~path:["maps"; "embed"]
        ~meth:(Eliom_service.Get (Eliom_parameter.string "pb"))
        () in
    let src = make_uri ~service pb in
    Foundation.responsive_embed @@
    iframe
      ~a:[
        a_src src;
        a_width 500;
        a_height 450;
        a_style "border:0";
        Unsafe.string_attrib "allow" "fullscreen";
      ]
      []

end

module Search = struct

  let service =
    Eliom_service.(
      extern
        ~prefix:"https://google.fr"
        ~path:["search"]
        ~meth:(Get (Eliom_parameter.(string "as_sitesearch" ** string "q")))
        ()
    )

end

module YouTube = struct

  let embed ~width ~height v =
    let open Html in
    let service =
      Eliom_service.extern
        ~prefix:"https://www.youtube.com"
        ~path:["embed"]
        ~meth:(Get Eliom_parameter.(suffix (string "v")))
        () in
    let src = make_uri ~service v in
    Foundation.responsive_embed @@
    iframe ~a:[
      a_width width;
      a_height height;
      a_src src;
      a_style "border: 0;";
      Unsafe.string_attrib
        "allow"
        "accelerometer; autoplay; encrypted-media; \
         gyroscope; picture-in-picture; fullscreen";
    ] []

end
