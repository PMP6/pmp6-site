module H = Eliom_content.Html.D

let icon ~style name ?(a=[]) ?(transform=[]) () =
  let name = "fa-" ^ name in
  let a = match transform with
    | [] -> a
    | _ ->
      H.a_user_data "transform" (String.concat ~sep:" " transform) :: a in
  H.i ~a:(H.a_class [style; name] :: a) []

(* Partial applications of style needs to eta-expand ?a as
   a parameter to prevent loss of generalisation. *)

let solid ?(a=[]) =
  icon ~a ~style:"fa-solid"

let brands ?(a=[]) =
  icon ~a ~style:"fa-brands"
