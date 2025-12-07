module H = Html

let thumbnail alt path =
  let open H in
  img ~a:[ a_class [ "thumbnail" ] ] ~src:(Skeleton.Static.img_uri path) ~alt ()

let thumbnail_row ?(max_size = 12) ~subdir alt_and_filenames =
  let nb_thumbnails = List.length alt_and_filenames in
  let thumbnail_space_large = min max_size (12 / nb_thumbnails) in
  let make_cell (alt, filename) =
    Foundation.Grid.cell
      ~small:10
      ~medium:5
      ~large:thumbnail_space_large
      ~a:[ H.class_ "text-center" ]
      [ thumbnail alt (subdir @ [ filename ]) ]
  in
  Foundation.Grid.padding_x
    ~medium_up:2
    ~small_up:1
    ~a:[ H.class_ "align-center-middle" ]
    (List.map ~f:make_cell alt_and_filenames)
