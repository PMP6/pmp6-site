module Accordion = Foundation_accordion
module Callout = Foundation_callout
module Color = Foundation_color
module Grid = Foundation_grid
module Motion_ui = Foundation_motion_ui
module Responsive_embed = Foundation_responsive_embed
module Switch = Foundation_switch
module Toggler = Foundation_toggler

[%%client.start]

open Js_of_ocaml

let init () =
  Js.Unsafe.eval_string {|
    jQuery(document).foundation();
  |}
