module H = Html

let create
    ?(a=[])
    ?color
    ?(closable=false)
    contents
  =
  H.div
    ~a:(
      a
      |> List.cons @@ H.a_class ["callout"]
      |> Utils.with_if closable @@ H.a_user_data "closable" ""
      |> Utils.with_some_map color Foundation_color.to_class
    )
    contents

let primary = create ~color:Primary
let secondary = create ~color:Secondary
let success = create ~color:Success
let warning = create ~color:Warning
let alert = create ~color:Alert
