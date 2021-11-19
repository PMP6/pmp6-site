module Model = Model__news

let path path = Eliom_service.Path ("news" :: path @ [""])

let main =
  Eliom_service.create
    ~path:(path [])
    ~meth:(Eliom_service.Get Eliom_parameter.unit)
    ()

let redaction =
  Eliom_service.create
    ~path:(path ["redaction"])
    ~meth:(Eliom_service.Get Eliom_parameter.unit)
    ()

let edition =
  Eliom_service.create
    ~path:(path ["edition"])
    ~meth:(Eliom_service.Get (Eliom_parameter.suffix @@ Model.Id.param "id"))
    ()

let create_into_main =
  Eliom_service.create_attached_post
    ~fallback:main
    ~csrf_safe:true
    ~post_params:
      Eliom_parameter.(
        string "title" **
        string "short_title" **
        string "content"
      )
    ()

let update_into_main =
  Eliom_service.create_attached_post
    ~fallback:main
    ~csrf_safe:true
    ~post_params:
      Eliom_parameter.(
        Model.Id.param "id" **
        string "title" **
        string "short_title" **
        string "content"
      )
    ()

let delete =
  Eliom_service.create
    ~csrf_safe:true
    ~path:Eliom_service.No_path
    ~meth:(Eliom_service.Post (Eliom_parameter.unit, Model.Id.param "id"))
    ()
