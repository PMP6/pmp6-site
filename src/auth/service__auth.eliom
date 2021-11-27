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

let logout =
  Eliom_service.create
    ~csrf_safe:true
    ~path:Eliom_service.No_path
    ~meth:(Eliom_service.Post (Eliom_parameter.unit, Eliom_parameter.unit))
    ()

let forbidden =
  Eliom_service.create
    ~path:(path ["forbidden"])
    ~meth:(Eliom_service.Get Eliom_parameter.unit)
    ()
