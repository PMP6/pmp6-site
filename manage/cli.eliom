[@@@warning "-5"]

let pp_heading =
  Fmt.(styled `Bold @@ styled (`Fg `Cyan) @@ text)

let pp_warning =
  Fmt.(styled (`Fg `Yellow) @@ text)

let pp_success =
  Fmt.(styled (`Fg `Green) @@ text)

let pp_error =
  Fmt.(styled (`Fg `Red) @@ text)

let rec ask_confirmation ?default msg =
  let hint =
    match default with
    | None -> "y/n"
    | Some true -> "Y/n"
    | Some false -> "y/N" in
  let get_default () =
    match default with
    | Some default -> default
    | None ->
      (* No default => ask again *)
      ask_confirmation ?default msg in
  Fmt.pr "@[@[%a@]@ @[[%s]@ @]@]@?" Fmt.text msg hint;
  let answer = Caml.read_line () in
  match String.(lowercase @@ strip answer) with
  | "y" | "yes" -> true
  | "n" | "no" -> false
  | "" -> get_default ()
  | _ -> ask_confirmation ?default msg
