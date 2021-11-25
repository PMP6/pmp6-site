let main () =
  let make_li_elt name service =
    Html.li [Html.a ~service [Html.txt name] ()] in
  let%lwt all_modules = Admin_module.all () in
  Content.page
    ~title:"Administration"
    [
      Html.ul ~a:[Html.a_class ["menu"]] @@
      List.map ~f:(Tuple2.uncurry make_li_elt) all_modules
    ]
