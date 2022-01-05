module Model = Model__auth

open Service_shortnames

let path subpath = S.Path ("auth" :: subpath @ [""])

let connection =
  S.create
    ~path:(path ["connexion"])
    ~meth:(S.Get P.(opt @@ Utils.subpath_param "next"))
    ()

let login =
  S.create_attached_post
    ~fallback:connection
    ~post_params:(P.(string "username" ** string "password"))
    ()

let logout =
  S.create
    ~csrf_safe:true
    ~path:S.No_path
    ~meth:(S.Post (P.unit, P.unit))
    ()

let forbidden =
  S.create
    ~path:(path ["acces-interdit"])
    ~meth:(S.Get P.unit)
    ()
