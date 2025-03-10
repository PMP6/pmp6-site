let clean_load_all () =
  News__fixtures.flush ();%lwt
  Auth__fixtures.flush ();%lwt
  let%lwt auth = Auth__fixtures.load () in
  let%lwt _news = News__fixtures.load auth in
  Lwt.return ()

let main () =
  Cli.pr_cmd_name "Fixture loading";
  let answer =
    Cli.ask_confirmation
      ~default:false
      "Do you want to flush everything then load the fixtures?"
  in
  if answer then (
    Fmt.pr "@[Loading fixtures...@]@.";
    try
      Lwt_main.run @@ clean_load_all ();
      Fmt.pr "@[%a@]@." Cli.pp_success "Fixtures successfully loaded."
    with Caqti_error.Exn e ->
      Fmt.pr
        "@[<2>@[%a@]@ @[%a@]@]@."
        Cli.pp_error
        "Error while loading the fixtures:"
        Fmt.words
        (Caqti_error.show e);
      exit 1)
  else Fmt.pr "@[%a@]@." Cli.pp_warning "Fixture loading cancelled.";
  exit 0
