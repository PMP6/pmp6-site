module%shared H = Eliom_content.Html.D

let clean_uchar uchar =
  (* Returns a string containing the lowercase version of an unicode character, if it is
     alphanumeric. Some characters such as linguistic ligatures, that remain after unicode
     normalisation, are explicitly converted. Other symbols produce the empty string. *)
  match Uchar.to_scalar uchar with
  | 0xC6 (* Æ *) | 0xE6 (* æ *) -> "ae"
  | 0x152 (* Œ *) | 0x153 (* œ *) -> "oe"
  | 0xdf (* ß *) | 0x1e9f (* ẞ *) -> "ss"
  | _ -> (
      match Uchar.to_char uchar with
      | Some char ->
          if Char.is_alphanum char then String.of_char (Char.lowercase char) else ""
      | None -> "")

let concat_map_utf_8 ~f string =
  let b = Buffer.create (String.length string) in
  let process_uchar () _index = function
    | `Uchar u -> Buffer.add_string b (f u)
    | `Malformed _ -> Uutf.Buffer.add_utf_8 b Uutf.u_rep
  in
  Uutf.String.fold_utf_8 process_uchar () string;
  Buffer.contents b

let clean_word word =
  (* Returns a lowercase version of the utf-8 encoded word where all diacritics are
     removed, ligatures decomposed, and non alphanumeric characters deleted. *)
  Uunf_string.normalize_utf_8 `NFKD word |> concat_map_utf_8 ~f:clean_uchar

let slugify string =
  (* Returns a slug made from the utf-8 encoded parameter. *)
  Uuseg_string.fold_utf_8
    `Word
    (fun acc word ->
      let word = clean_word word in
      if String.is_empty word then acc else word :: acc)
    []
    string
  |> List.rev
  |> String.concat ~sep:"-"

[%%shared
let cons_if boolean elt list = if boolean then elt :: list else list

let cons_if_opt opt ~some ~none list =
  match opt with None -> none :: list | Some _ -> some :: list

let cons_opt opt list = match opt with None -> list | Some elt -> elt :: list
let cons_opt_map opt f list = match opt with None -> list | Some elt -> f elt :: list

(* TODO: put that in foundation or delete it altogether *)

let cons_vertical is_vertical classes = cons_if is_vertical "vertical" classes
let cons_is_active is_active classes = cons_if is_active "is-active" classes

let cons_is_active_attrib is_active attribs =
  if is_active then H.a_class (cons_is_active is_active []) :: attribs else attribs]
