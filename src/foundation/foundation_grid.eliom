module H = Html

let ( <?> ) f opt = Option.map ~f opt

(* Grid container *)

let a_grid_container = H.class_ "grid-container"

(* Grid classes *)

let a_x = H.class_ "grid-x"
let a_margin_x = H.class_ "grid-margin-x"
let a_padding_x = H.class_ "grid-padding-x"
let a_small_up n = H.class_ (Fmt.str "small-up-%d" n)
let a_medium_up n = H.class_ (Fmt.str "medium-up-%d" n)
let a_large_up n = H.class_ (Fmt.str "large-up-%d" n)

(* Grid elements *)

let x ?(a = []) ?small_up ?medium_up ?large_up content =
  let small_up = a_small_up <?> small_up in
  let medium_up = a_medium_up <?> medium_up in
  let large_up = a_large_up <?> large_up in
  let a = a @ List.filter_opt [ small_up; medium_up; large_up ] in
  H.div ~a:(a_x :: a) content

let margin_x ?(a = []) ?small_up ?medium_up ?large_up content =
  x ~a:(a_margin_x :: a) ?small_up ?medium_up ?large_up content

let padding_x ?(a = []) ?small_up ?medium_up ?large_up content =
  x ~a:(a_padding_x :: a) ?small_up ?medium_up ?large_up content

(* Cell classes *)

let class_auto () = "auto"
let class_shrink () = "shrink"
let class_space_fixed size_name n = Fmt.str "%s-%d" size_name n
let class_space_auto size_name () = Fmt.str "%s-auto" size_name
let class_space_shrink size_name () = Fmt.str "%s-shrink" size_name

let class_space_all_sizes ?auto ?shrink () =
  List.filter_opt [ class_auto <?> auto; class_shrink <?> shrink ]

let class_space_size ?n ?auto ?shrink size_name =
  (* TODO warn on multiple definitions *)
  List.filter_opt
    [
      class_space_fixed size_name <?> n;
      class_space_auto size_name <?> auto;
      class_space_shrink size_name <?> shrink;
    ]

let class_offset size_name n = Fmt.str "%s-offset-%d" size_name n

let class_offset ?small_offset ?medium_offset ?large_offset () =
  List.filter_opt
    [
      class_offset "small" <?> small_offset;
      class_offset "medium" <?> medium_offset;
      class_offset "large" <?> large_offset;
    ]

let a_cell
    ?auto
    ?shrink
    ?small
    ?small_auto
    ?small_shrink
    ?medium
    ?medium_auto
    ?medium_shrink
    ?large
    ?large_auto
    ?large_shrink
    ?small_offset
    ?medium_offset
    ?large_offset
    () =
  H.a_class
    ([ "cell" ]
    @ class_space_all_sizes ?auto ?shrink ()
    @ class_space_size "small" ?n:small ?auto:small_auto ?shrink:small_shrink
    @ class_space_size "medium" ?n:medium ?auto:medium_auto ?shrink:medium_shrink
    @ class_space_size "large" ?n:large ?auto:large_auto ?shrink:large_shrink
    @ class_offset ?small_offset ?medium_offset ?large_offset ())

(* Cell elements *)

let cell_elt
    ~elt
    ?auto
    ?shrink
    ?small
    ?small_auto
    ?small_shrink
    ?medium
    ?medium_auto
    ?medium_shrink
    ?large
    ?large_auto
    ?large_shrink
    ?small_offset
    ?medium_offset
    ?large_offset
    ?(a = [])
    content =
  elt
    ?a:
      (Some
         (a_cell
            ?auto
            ?shrink
            ?small
            ?small_auto
            ?small_shrink
            ?medium
            ?medium_auto
            ?medium_shrink
            ?large
            ?large_auto
            ?large_shrink
            ?small_offset
            ?medium_offset
            ?large_offset
            ()
         :: a))
    content

let cell ?auto = cell_elt ~elt:H.div ?auto
