[@@@warning "-5"]

let fmt_heading pp = Fmt.(styled `Bold @@ styled (`Fg `Cyan) @@ pp)

let pp_heading = fmt_heading Fmt.text

let fmt_warning pp = Fmt.styled (`Fg `Yellow) pp

let pp_warning = fmt_warning Fmt.text

let fmt_success pp = Fmt.(styled (`Fg `Green) @@ pp)

let pp_success = fmt_success Fmt.text

let fmt_error pp = Fmt.(styled (`Fg `Red) @@ pp)

let pp_error = fmt_error Fmt.text

let pr_cmd_name name =
  Fmt.pr "@[<v>@;@[%a@]@]@." (fmt_heading @@ Fmt.fmt "=== %s ===") name

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
