module H = Html

let page_service () =
  Eliom_service.extern
    ~prefix:"https://www.facebook.com"
    ~path:["as.pmp6"]
    ~meth:(Eliom_service.Get Eliom_parameter.unit)
    ()

let messenger_service () =
  Eliom_service.extern
    ~prefix:"https://m.me"
    ~path:["as.pmp6"]
    ~meth:(Eliom_service.Get Eliom_parameter.unit)
    ()

let page_widget () =
  let plugin_uri =
    H.uri_of_string @@ const @@
    "https://www.facebook.com/plugins/page.php?\
     href=https%3A%2F%2Fwww.facebook.com%2Fas.pmp6\
     &tabs=timeline&width=500&height=1000&small_header=false\
     &adapt_container_width=true&hide_cover=false&show_facepile=false&appId"
  in
  let open H in
  iframe ~a:[
    a_src plugin_uri;
    a_width 500;
    a_height 1000;
    a_style "border: none; overflow: auto; background-color: transparent";
  ] []
