module Model = News__model
module View = News__view

open Lwt.Infix

module Make (App : Eliom_registration.APP) = struct
  let list_all () () =
    Model.get_all_exn () >>=
    View.Page.list_all
end
