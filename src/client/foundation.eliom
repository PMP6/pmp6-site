let responsive_embed c =
  Html.div_classes ["responsive-embed"] [c]

let ( --> ) cond f x =
  (* TODO This is an ugly solution to an actual problem. *)
  if cond
  then f x
  else x

let ( -->:: ) cond x =
  cond --> List.cons x

let accordion elements
    ?(active_index=0)
    ?(multi_expand=false)
    ?(allow_all_closed=false)
    ?(deep_link=false)
    ()
  =
  (* Elements should be a list of (title, div content as a list) tuples *)
  let open Html in
  let make_item index (title, content) =
    li ~a:[
      a_class (["accordion-item"] |> (index = active_index) -->:: "is-active");
      a_user_data "accordion-item" "";
    ] [
      (* Accordion tab title *)
      Raw.a ~a:[a_class ["accordion-title"]; a_href (uri_of_string @@ const "#")] [txt title];
      (* Accordion tab content *)
      div ~a:[
        a_class ["accordion-content"];
        a_user_data "tab-content" "";
      ] content
    ]
  in
  ul ~a:(
    [
      a_class ["accordion"];
      a_user_data "accordion" "";
    ]
    |> multi_expand -->:: a_user_data "multi-expand" "true"
    |> allow_all_closed -->:: a_user_data "allow-all-closed" "true"
    |> deep_link -->:: a_user_data "deep-link" "true"
  ) (List.mapi ~f:make_item elements)

[%%client.start]

open Js_of_ocaml

let init () =
  Js.Unsafe.eval_string {|
    jQuery(document).foundation();
  |}
