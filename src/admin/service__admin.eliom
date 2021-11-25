let path path =
  Eliom_service.Path ("admin" :: path @ [""])

let main =
  Eliom_service.create
    ~path:(path [])
    ~meth:(Eliom_service.Get Eliom_parameter.unit)
    ()
