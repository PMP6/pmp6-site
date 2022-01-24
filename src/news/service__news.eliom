module Model = Model__news

open Service_helpers

let admin_path path = Admin.Service.path ("news" :: path)

let main =
  S.create
    ~path:(admin_path [])
    ~meth:(S.Get P.unit)
    ()

let _ : unit Lwt.t = Admin_module.attach "News" main

let redaction =
  S.create
    ~path:(admin_path ["redaction"])
    ~meth:(S.Get P.unit)
    ()

let edition =
  S.create
    ~path:(admin_path ["edition"])
    ~meth:(S.Get (P.suffix @@ Model.Id.param "id"))
    ()

let create_into_main =
  S.create_attached_post
    ~fallback:main
    ~csrf_safe:true
    ~post_params:
      P.(
        string "title" **
        string "short_title" **
        string "content"
      )
    ()

let update_into_main =
  S.create_attached_post
    ~fallback:main
    ~csrf_safe:true
    ~post_params:
      P.(
        Model.Id.param "id" **
        string "title" **
        string "short_title" **
        string "content"
      )
    ()

let delete =
  S.create
    ~csrf_safe:true
    ~path:S.No_path
    ~meth:(S.Post (P.unit, Model.Id.param "id"))
    ()
