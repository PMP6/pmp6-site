module Model = Model__auth

let path path = Eliom_service.Path ("auth" :: path @ [""])

let connection =
  Eliom_service.create
    ~path:(path ["connexion"])
    ~meth:(Eliom_service.Get Eliom_parameter.unit)
    ()

let login =
  Eliom_service.create_attached_post
    ~fallback:connection
    ~post_params:(Eliom_parameter.(string "username" ** string "password"))
    ()
