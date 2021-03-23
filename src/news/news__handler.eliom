module Model = News__model
module View = News__view

open Lwt.Infix

let list_all () () =
  Model.get_all_exn () >>=
  View.Page.list_all
