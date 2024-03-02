module H = Html

type transition_in =
  [ `Slide_in_down
  | `Slide_in_left
  | `Slide_in_up
  | `Slide_in_right
  | `Fade_in
  | `Hinge_in_from_top
  | `Hinge_in_from_right
  | `Hinge_in_from_bottom
  | `Hinge_in_from_left
  | `Hinge_in_from_middle_x
  | `Hinge_in_from_middle_y
  | `Scale_in_up
  | `Scale_in_down
  | `Spin_in
  | `Spin_in_ccw
  ]

type transition_out =
  [ `Slide_out_down
  | `Slide_out_left
  | `Slide_out_up
  | `Slide_out_right
  | `Fade_out
  | `Hinge_out_from_top
  | `Hinge_out_from_right
  | `Hinge_out_from_bottom
  | `Hinge_out_from_left
  | `Hinge_out_from_middle_x
  | `Hinge_out_from_middle_y
  | `Scale_out_up
  | `Scale_out_down
  | `Spin_out
  | `Spin_out_ccw
  ]

let to_string_in = function
  | `Slide_in_down -> "slide-in-down"
  | `Slide_in_left -> "slide-in-left"
  | `Slide_in_up -> "slide-in-up"
  | `Slide_in_right -> "slide-in-right"
  | `Fade_in -> "fade-in"
  | `Hinge_in_from_top -> "hinge-in-from-top"
  | `Hinge_in_from_right -> "hinge-in-from-right"
  | `Hinge_in_from_bottom -> "hinge-in-from-bottom"
  | `Hinge_in_from_left -> "hinge-in-from-left"
  | `Hinge_in_from_middle_x -> "hinge-in-from-middle-x"
  | `Hinge_in_from_middle_y -> "hinge-in-from-middle-y"
  | `Scale_in_up -> "scale-in-up"
  | `Scale_in_down -> "scale-in-down"
  | `Spin_in -> "spin-in"
  | `Spin_in_ccw -> "spin-in-ccw"

let to_string_out = function
  | `Spin_out_ccw -> "spin-out-ccw"
  | `Slide_out_down -> "slide-out-down"
  | `Slide_out_left -> "slide-out-left"
  | `Slide_out_up -> "slide-out-up"
  | `Slide_out_right -> "slide-out-right"
  | `Fade_out -> "fade-out"
  | `Hinge_out_from_top -> "hinge-out-from-top"
  | `Hinge_out_from_right -> "hinge-out-from-right"
  | `Hinge_out_from_bottom -> "hinge-out-from-bottom"
  | `Hinge_out_from_left -> "hinge-out-from-left"
  | `Hinge_out_from_middle_x -> "hinge-out-from-middle-x"
  | `Hinge_out_from_middle_y -> "hinge-out-from-middle-y"
  | `Scale_out_up -> "scale-out-up"
  | `Scale_out_down -> "scale-out-down"
  | `Spin_out -> "spin-out"

let animate in_ out = H.a_user_data "animate" (to_string_in in_ ^ " " ^ to_string_out out)
