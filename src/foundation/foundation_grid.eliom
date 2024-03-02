module H = Html

let x ?(a = []) content = H.div ~a:(H.class_ "grid-x" :: a) content

let cell ?small ?medium ?large ?(a = []) content =
  let classes =
    [ "cell" ]
    |> Utils.cons_opt_map small @@ Fmt.str "small-%d"
    |> Utils.cons_opt_map medium @@ Fmt.str "medium-%d"
    |> Utils.cons_opt_map large @@ Fmt.str "large-%d"
  in
  H.div ~a:(H.a_class classes :: a) content
