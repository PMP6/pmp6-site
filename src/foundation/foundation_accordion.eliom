module H = Html

let create elements
    ?(a=[])
    ?(active_index=0)
    ?(multi_expand=false)
    ?(allow_all_closed=false)
    ?(deep_link=false)
    ()
  =
  (* Elements should be a list of (title, div content as a list) tuples *)
  let make_item index (title, content) =
    H.li ~a:[
      H.a_class (["accordion-item"] |> Utils.cons_if (index = active_index) "is-active");
      H.a_user_data "accordion-item" "";
    ] [
      (* Accordion tab title *)
      H.Raw.a
        ~a:[H.a_class [ "accordion-title" ]; H.a_href (H.uri_of_string @@ const "#") ]
        [ H.txt title ];
      (* Accordion tab content *)
      H.div ~a:[
        H.a_class [ "accordion-content" ];
        H.a_user_data "tab-content" "";
      ] content
    ]
  in
  H.ul ~a:(
    (H.a_class [ "accordion" ] :: H.a_user_data "accordion" "" :: a)
    |> Utils.cons_if multi_expand @@ H.a_user_data "multi-expand" "true"
    |> Utils.cons_if allow_all_closed @@ H.a_user_data "allow-all-closed" "true"
    |> Utils.cons_if deep_link @@ H.a_user_data "deep-link" "true"
  ) (List.mapi ~f:make_item elements)
