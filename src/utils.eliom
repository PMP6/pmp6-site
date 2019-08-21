module H = Eliom_content.Html.D

let clean_uchar uchar =
  (* Returns a string containing the lowercase version of an unicode
     character, if it is alphanumeric. Some characters such as
     linguistic ligatures, that remain after unicode normalisation,
     are explicitly converted. Other symbols produce the empty
     string. *)
  match Uchar.to_scalar uchar with
  | 0xC6 (* Æ *)
  | 0xE6 (* æ *) ->
    "ae"
  | 0x152 (* Œ *)
  | 0x153 (* œ *) ->
    "oe"
  | 0xdf (* ß *)
  | 0x1e9f (* ẞ *) ->
    "ss"
  | _ -> begin
      match Uchar.to_char uchar with
      | Some char ->
        if Char.is_alphanum char
        then String.of_char (Char.lowercase char)
        else ""
      | None -> ""
    end

let concat_map_utf_8 ~f string =
  let b = Buffer.create (String.length string) in
  let process_uchar () _index = function
    | `Uchar u -> Buffer.add_string b (f u)
    | `Malformed _ -> Uutf.Buffer.add_utf_8 b Uutf.u_rep
  in
  Uutf.String.fold_utf_8 process_uchar () string;
  Buffer.contents b

let clean_word word =
  (* Returns a lowercase version of the utf-8 encoded word where all
     diacritics are removed, ligatures decomposed, and non
     alphanumeric characters deleted. *)
  Uunf_string.normalize_utf_8 `NFKD word
  |> concat_map_utf_8 ~f:clean_uchar

let slugify string =
  (* Returns a slug made from the utf-8 encoded parameter. *)
  Uuseg_string.fold_utf_8 `Word
    (fun acc word ->
       let word = clean_word word in
       if String.is_empty word
       then acc
       else word :: acc)
    []
    string
  |> List.rev
  |> String.concat ~sep:"-"

let is_active_class is_active =
  if is_active
  then ["is-active"]
  else []

let is_active_attrib is_active =
  if is_active
  then [H.a_class (is_active_class is_active)]
  else []
