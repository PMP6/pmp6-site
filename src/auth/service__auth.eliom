module Model = Model__auth

open Service_helpers

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
  S.create_attached_post
    ~csrf_safe:true
    ~fallback:Skeleton.home_service
    ~post_params:P.unit
    ()

let forbidden =
  S.create
    ~path:(path ["acces-interdit"])
    ~meth:(S.Get P.unit)
    ()

module Settings = struct

  let path subpath = path ("parametres" :: subpath)

  let email_edition =
    S.create
      ~path:(path ["email"])
      ~meth:(S.Get P.unit)
      ()

  let save_email =
    S.create
      ~path:S.No_path
      ~csrf_safe:true
      ~meth:(S.Post (P.unit, P.string "email"))
      ()

end
