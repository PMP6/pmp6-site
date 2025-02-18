module Model = Model__news
open Service_helpers

module Admin = struct
  let path subpath = Skeleton.admin_path ("news" :: subpath)
  let main = S.create ~path:(path []) ~meth:(S.Get P.unit) ()
  let redaction = S.create ~path:(path [ "redaction" ]) ~meth:(S.Get P.unit) ()

  let edition =
    S.create ~path:(path [ "edition" ]) ~meth:(S.Get (P.suffix @@ Model.Id.param "id")) ()

  let create_into_main =
    S.create_attached_post
      ~fallback:main
      ~csrf_safe:true
      ~post_params:
        P.(
          string "title" ** string "short_title" ** string "content" ** bool "is_visible")
      ()

  let update_into_main =
    S.create_attached_post
      ~fallback:main
      ~csrf_safe:true
      ~post_params:
        P.(
          Model.Id.param "id"
          ** bool "update_datetime"
          ** string "title"
          ** string "short_title"
          ** string "content"
          ** bool "is_visible")
      ()

  let delete =
    S.create
      ~csrf_safe:true
      ~path:S.No_path
      ~meth:(S.Post (P.unit, Model.Id.param "id"))
      ()
end
