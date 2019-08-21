[%%client.start]

open Js_of_ocaml

(*
  Litteral translation of original PhotoSwipe code in js_of_ocaml
  See https://photoswipe.com/documentation/getting-started.html
*)

let pswp_element () =
  (Dom_html.document##querySelectorAll (Js.string ".pswp"))##item 0

(* Build items array *)

let items =
  Js.array [|
    object%js
      val src = Js.string "https://placekitten.com/600/400"
      val w = 600
      val h = 400
    end;

    object%js
      val src = Js.string "https://placekitten.com/1200/900"
      val w = 1200
      val h = 900
    end;
  |]

(* Define options (if needed) *)

let options = object%js
  (* optionName: option value *)

  (* for example : *)
  val index = 0
end

(* Initialises and opens PhotoSwipe *)

let photoswipe = Js.Unsafe.global##._PhotoSwipe

let photoswipe_ui_default = Js.Unsafe.global##._PhotoSwipeUI_Default_

let init () =
  let gallery = new%js photoswipe (pswp_element ()) photoswipe_ui_default items options in
  gallery##init
