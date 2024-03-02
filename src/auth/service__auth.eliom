module Model = Model__auth
open Service_helpers

let path subpath = S.Path (("auth" :: subpath) @ [ "" ])

let connection =
  S.create ~path:(path [ "connexion" ]) ~meth:(S.Get P.(opt @@ Subpath.param "next")) ()

let login =
  S.create_attached_post
    ~fallback:connection
    ~post_params:P.(string "username" ** string "password")
    ()

let logout =
  S.create_attached_post
    ~csrf_safe:true
    ~fallback:Skeleton.home_service
    ~post_params:P.unit
    ()

let forbidden = S.create ~path:(path [ "acces-interdit" ]) ~meth:(S.Get P.unit) ()

module Settings = struct
  let path subpath = path ("parametres" :: subpath)
  let main = S.create ~path:(path []) ~meth:(S.Get P.unit) ()

  let save_email =
    S.create_attached_post
      ~fallback:main
      ~csrf_safe:true
      ~post_params:(P.string "email")
      ()

  let save_password =
    S.create_attached_post ~fallback:main ~post_params:(P.string "password") ()

  let forgotten_password =
    S.create ~path:(path [ "mot-de-passe-oublie" ]) ~meth:(S.Get P.unit) ()

  let request_password_token =
    S.create_attached_post ~fallback:forgotten_password ~post_params:(P.string "email") ()

  let password_reset =
    S.create
      ~path:(path [ "reinitialisation" ])
      ~meth:(S.Get (Secret.Token.param "token"))
      ()

  let validate_password_reset =
    S.create_attached_post ~fallback:password_reset ~post_params:(P.string "password") ()
end

module Admin = struct
  let path subpath = Skeleton.admin_path ("auth" :: subpath)
  let main = S.create ~path:(path []) ~meth:(S.Get P.unit) ()
  let user_creation = S.create ~path:(path [ "creation" ]) ~meth:(S.Get P.unit) ()

  let user_edition =
    S.create
      ~path:(path [ "edition" ])
      ~meth:(S.Get (P.suffix @@ Model.User.Id.param "id"))
      ()

  let create_user =
    S.create
      ~path:No_path
      ~csrf_safe:true
      ~meth:
        (S.Post
           ( P.unit,
             P.(
               string "username"
               ** string "email"
               ** string "password"
               ** bool "is_superuser"
               ** bool "is_staff") ))
      ()

  let update_user =
    S.create_attached_post
      ~fallback:user_edition
      ~csrf_safe:true
      ~post_params:
        P.(
          string "username"
          ** string "email"
          ** neopt (string "password")
          ** bool "is_superuser"
          ** bool "is_staff")
      ()

  let delete_user =
    S.create_attached_post
      ~fallback:main
      ~csrf_safe:true
      ~post_params:(Model.User.Id.param "id")
      ()
end
