module Accordion = Foundation_accordion
module Callout = Foundation_callout
module Color = Foundation_color
module Responsive_embed = Foundation_responsive_embed

[%%client.start]

open Js_of_ocaml

let init () =
  Js.Unsafe.eval_string {|
    jQuery(document).foundation();
  |}
