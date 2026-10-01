module H = Html

let main_page service = Eliom_tools.Main_page (Srv service)
let hierarchy_leaf service = Eliom_tools.Site_tree (main_page service, [])

let page_service name =
  let open Eliom_service in
  create ~path:(Path [ name; "" ]) ~meth:(Get Eliom_parameter.unit) ()

let menu_item main_name sub_entries =
  ( H.txt main_name,
    Eliom_tools.Site_tree
      ( Not_clickable,
        List.map ~f:(fun (name, srv) -> (H.txt name, hierarchy_leaf srv)) sub_entries ) )

module Plonger = struct
  module Services = struct
    let formations = page_service "formations"
    let stages = page_service "stages"
  end

  let hierarchy_item =
    menu_item "Plonger" Services.[ ("Formations", formations); ("Stages", stages) ]
end

module Informations = struct
  module Services = struct
    let piscine = page_service "piscine"
    let fosse = page_service "fosse"
    let inscription = page_service "inscription"
  end

  let hierarchy_item =
    menu_item
      "Informations pratiques"
      Services.
        [ ("Piscine", piscine); ("Fosse", fosse); ("Inscription au club", inscription) ]
end

module Espace_membre = struct
  module Services = struct
    let calendrier = page_service "calendrier"
    let boutique = page_service "boutique"
  end

  let hierarchy_item =
    menu_item
      "Espace membre"
      Services.[ ("Calendrier", calendrier); ("Boutique", boutique) ]
end

module Contact = struct
  let service = page_service "contact"
  let hierarchy_item = (H.txt "Nous contacter", hierarchy_leaf service)
end

module Media = struct
  let uri path =
    Html.make_uri
      ~absolute_path:true
      ~service:(Eliom_service.static_dir ())
      ("media" :: path)
end

module Static = struct
  let uri path =
    H.make_uri
      ~absolute_path:true
      ~service:(Eliom_service.static_dir ())
      ("static" :: path)

  let subdir_uri subdir path = uri (subdir :: path)
  let img_uri = subdir_uri "img"
  let css_uri = subdir_uri "css"
  let js_uri = subdir_uri "js"

  let js_script path =
    (* H.js_script generates unneeded "type=text/javascript" attribute, which triggers a
       warning on HTML validation *)
    H.js_script (js_uri path)
end

let home_service =
  Eliom_service.create
    ~path:(Eliom_service.Path [ "" ])
    ~meth:(Eliom_service.Get Eliom_parameter.unit)
    ()

let admin_path subpath = Eliom_service.Path (("admin" :: subpath) @ [ "" ])

let hierarchy_items =
  [
    Plonger.hierarchy_item;
    Informations.hierarchy_item;
    (* Galerie.hierarchy_item; *)
    Espace_membre.hierarchy_item;
    Contact.hierarchy_item;
  ]
