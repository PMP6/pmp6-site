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
    S.create_attached_post
      ~fallback:email_edition
      ~csrf_safe:true
      ~post_params:(P.string "email")
      ()

  let forgotten_password =
    S.create
      ~path:(path ["mot-de-passe-oublie"])
      ~meth:(S.Get P.unit)
      ()

  let request_password_token =
    S.create_attached_post
      ~fallback:forgotten_password
      ~post_params:(P.string "email")
      ()

  let password_reset =
    S.create
      ~path:(path ["reinitialisation"])
      ~meth:(S.Get (Secret.Token.param "token"))
      ()

  let validate_password_reset =
    S.create_attached_post
      ~fallback:password_reset
      ~post_params:(P.string "password")
      ()

end
