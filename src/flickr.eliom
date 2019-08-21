let pmp6_user () =
  "181728096@N03"

let embedded_album ~album_uri ~thumbnail_uri ~width ~height ~title:album_title =
  let open Html in
  Raw.a ~a:[
    a_user_data "flickr-embed" "true";
    a_href (uri_of_string @@ const album_uri);
    a_title album_title;
  ] [
    img
      ~src:(uri_of_string @@ const thumbnail_uri)
      ~alt:album_title
      ~a:[a_width width; a_height height]
      ()
  ]


let client_code_script () =
  let open Html in
  js_script
    ~a:[
      a_async ();
      a_charset "utf-8";
    ]
    (uri_of_string @@ const "//embedr.flickr.com/assets/client-code.js")
    ()
