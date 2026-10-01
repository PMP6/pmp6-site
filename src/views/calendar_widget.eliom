module H = Html

let calendar_script () =
  H.js_script
    ~a:[ H.a_defer () ]
    (H.uri_of_string (fun () -> "https://static.elfsight.com/platform/platform.js"))
    ()

let calendar_div () =
  H.div
    ~a:
      [
        H.a_class_ "elfsight-app-912f8507-7c26-4cb8-b9a9-c15d0e25b4c7";
        H.a_user_data "elfsight-app-lazy" "";
      ]
    []

let calendar () = H.div [ calendar_script (); calendar_div () ]
