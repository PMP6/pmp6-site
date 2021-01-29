let path_under_news path = Eliom_service.Path ("news" :: path @ [""])

let main =
  Eliom_service.create
    ~path:(path_under_news [])
    ~meth:(Eliom_service.Get Eliom_parameter.unit)
    ()
