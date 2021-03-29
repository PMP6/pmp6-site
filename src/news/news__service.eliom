module Model = News__model

let path_under_news path = Eliom_service.Path ("news" :: path @ [""])

let main =
  Eliom_service.create
    ~path:(path_under_news [])
    ~meth:(Eliom_service.Get Eliom_parameter.unit)
    ()

let redaction =
  Eliom_service.create
    ~path:(path_under_news ["redaction"])
    ~meth:(Eliom_service.Get Eliom_parameter.unit)
    ()

let create_into_main =
  Eliom_service.create_attached_post
    ~fallback:main
    ~post_params:
      Eliom_parameter.(
        string "title" **
        string "short_title" **
        string "content"
      )
    ()

let delete =
  Eliom_service.create
    ~path:Eliom_service.No_path
    ~meth:(Eliom_service.Get (Model.Id.param "id"))
    ()
