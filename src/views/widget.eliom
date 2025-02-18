module H = Html

let thumbnail alt path =
  let open H in
  img ~a:[ a_class [ "thumbnail" ] ] ~src:(Skeleton.Static.img_uri path) ~alt ()

let thumbnail_row ?(max_size = 12) ~subdir alt_and_filenames =
  let nb_thumbnails = List.length alt_and_filenames in
  let thumbnail_size = min max_size (12 / nb_thumbnails) in
  let large_size = sprintf "large-%d" thumbnail_size in
  let make_cell (alt, filename) =
    H.div_classes
      [ "cell"; "medium-5"; "small-10"; large_size; "text-center" ]
      [ thumbnail alt (subdir @ [ filename ]) ]
  in
  H.div_classes
    [ "grid-x"; "grid-padding-x"; "medium-up-2"; "small-up-1"; "align-center-middle" ]
    (List.map ~f:make_cell alt_and_filenames)
