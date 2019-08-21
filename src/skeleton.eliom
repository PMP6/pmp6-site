module H = Html

let main_page service =
  Eliom_tools.Main_page (Srv service)

let hierarchy_leaf service =
  Eliom_tools.(Site_tree (main_page service, []))

module SubLeaf (Config : sig val path_root : string end) = struct
  let service =
    let open Eliom_service in
    create
      ~path:(Path ([Config.path_root; ""]))
      ~meth:(Get Eliom_parameter.unit)
      ()

  let make_hierarchy_item main_name sub_entries =
    H.txt main_name, Eliom_tools.Site_tree (
      main_page service,
      List.map
        ~f:(fun (name, srv) -> H.txt name, hierarchy_leaf srv)
        sub_entries
    )
end

module SubTree (Config : sig val path_root : string end) = struct
  (* Currently works only for one level. *)

  let path_root = Config.path_root

  let void_service subpath =
    let open Eliom_service in
    let service = create
      ~path:(Path (path_root :: subpath @ [""]))
      ~meth:(Get Eliom_parameter.unit)
      ()
    in
    Eliom_registration.Html_text.register ~service
      (fun () () -> Lwt.return @@ String.concat ~sep:"/" (path_root :: subpath));
    service

  let sub_service subpath =
    let open Eliom_service in
    create
      ~path:(Path (path_root :: subpath @ [""]))
      ~meth:(Get Eliom_parameter.unit)
      ()

  let make_hierarchy_item main_name sub_entries =
    H.txt main_name, Eliom_tools.Site_tree (
      Not_clickable,
      List.map
        ~f:(fun (name, srv) -> H.txt name, hierarchy_leaf srv)
        sub_entries
    )
end

module Plonger = struct
  include SubTree (struct let path_root = "plonger" end)

  module Services = struct
    let formations =
      sub_service ["formations"]

    let stages =
      sub_service ["stages"]
  end

  let hierarchy_item =
    make_hierarchy_item "Plonger"
      Services.[
        "Formations", formations;
        "Stages", stages;
      ]
end

module Informations = struct
  include SubTree (struct let path_root = "informations-pratiques" end)

  module Services = struct
    let piscine =
      sub_service ["piscine"]

    let fosse =
      sub_service ["fosse"]

    let inscription =
      sub_service ["inscription"]
  end

  let hierarchy_item =
    make_hierarchy_item "Informations pratiques"
      Services.[
        "Piscine", piscine;
        "Fosse", fosse;
        "Inscription au club", inscription;
      ]
end

module Galerie = struct
  include SubLeaf (struct let path_root = "galerie" end)

  let hierarchy_item =
    make_hierarchy_item "Galerie" []
end

module Contact = struct
  include SubLeaf (struct let path_root = "contact" end)

  let hierarchy_item =
    make_hierarchy_item "Nous contacter" []
end

module Static = struct
  let uri path =
    H.make_uri ~service:(Eliom_service.static_dir ()) path

  let subdir_uri subdir path =
    uri (subdir :: path)

  let img_uri = subdir_uri "img"

  let css_uri = subdir_uri "css"

  let js_uri = subdir_uri "js"

  let js_script path =
    (* H.js_script generates unneeded "type=text/javascript" attribute,
       which triggers a warning on HTML validation *)
    H.js_script (js_uri path)
end

let home_service =
  Eliom_service.create
    ~path:(Eliom_service.Path [""])
    ~meth:(Eliom_service.Get Eliom_parameter.unit)
    ()

let hierarchy_items =
  [
    Plonger.hierarchy_item;
    Informations.hierarchy_item;
    (* Galerie.hierarchy_item; *)
    Contact.hierarchy_item;
  ]
