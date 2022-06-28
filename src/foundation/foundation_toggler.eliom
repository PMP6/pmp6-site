module H = Html

let toggler target =
  let class_, animate = match target with
    | `Class class_ -> class_, None
    | `Animate (in_, out) -> "", Some (Foundation_motion_ui.animate in_ out)
  in
  Utils.cons_opt animate [ H.a_user_data "toggler" class_ ]

let toggle ids =
  H.a_user_data "toggle" (String.concat ~sep:" " ids)
