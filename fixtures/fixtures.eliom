let clean_load_all () =
  News__fixtures.flush ();%lwt
  Auth__fixtures.flush ();%lwt
  let%lwt auth = Auth__fixtures.load () in
  let%lwt _news = News__fixtures.load auth in
  Lwt.return ()

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

let () =
  Fmt.set_style_renderer Fmt.stdout `Ansi_tty;
  Fmt.pr "@[<v>@;@[%a@]@]@." pp_heading "=== Project fixture creation ===";
  let answer =
    ask_confirmation
      ~default:false
      "Do you want to flush everything then load the fixtures?" in
  if answer
  then begin
    Fmt.pr "@[Loading fixtures...@]@.";
    try
      Lwt_main.run @@ clean_load_all ();
      Fmt.pr "@[%a@]@." pp_success "Fixtures successfully loaded."
    with Caqti_error.Exn e ->
      Fmt.pr "@[<2>@[%a@]@ @[%a@]@]@."
        pp_error "Error while loading the fixtures:"
        Fmt.words (Caqti_error.show e);
      exit 1
  end
  else begin
    Fmt.pr "@[%a@]@." pp_warning "Fixture loading cancelled."
  end;
  exit 0
