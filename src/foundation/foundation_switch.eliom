module H = Html

let size_class = function `Tiny -> "tiny" | `Small -> "small" | `Large -> "large"

(* input_id can be predetermined so it can be used on external labels *)
let create ?(a = []) ?size ?(input_id = H.new_id ()) ?on ~show_for_sr () =
  let classes = [ "switch" ] |> Utils.cons_opt_map size size_class in
  H.div
    ~a:(H.a_class classes :: a)
    [
      H.input
        ~a:
          ([ H.a_input_type `Checkbox; H.a_class_ "switch-input"; H.a_id input_id ]
          |> Utils.cons_opt_map on H.a_checked)
        ();
      H.label
        ~a:[ H.a_class_ "switch-paddle"; H.a_label_for input_id ]
        [ H.span ~a:[ H.a_class_ "show-for-sr" ] [ H.txt show_for_sr ] ];
    ]
