module Service = Service__admin

module H = Html

module Widget = struct

  let interface_icon () =
    let icon = Icon.solid ~a:[H.a_class ["icon"; "show-for-large"]] "cog" () in
    H.a
      ~service:Service.main
      [icon; H.span ~a:[H.a_class ["hide-for-large"]] [H.txt "Administration"]]
      ()

end

let main () =
  let make_li_elt module_ =
    let service = Admin_module.service module_ in
    let name = Admin_module.name module_ in
    Html.li [Html.a ~service [Html.txt name] ()] in
  let%lwt all_modules = Admin_module.all_visible () in
  Content.page
    ~title:"Administration"
    [
      H.h1 [H.txt "Interface d'administration"];
      H.p [H.txt "Cliquez sur un lien pour accéder à l'administration \
                  de ce module."];
      Html.ul ~a:[Html.a_class ["menu"]] @@
      List.map ~f:make_li_elt all_modules
    ]
