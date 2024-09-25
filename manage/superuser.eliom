let main () =
  Cli.pr_cmd_name "Superuser creation";
  let username = Cli.ask "Username:" in
  let password = Cli.ask_password "Password:" in
  let email = Cli.ask "Email:" in
  Fmt.pr "@[Creating superuser...@]@.";
  match
    Lwt_main.run
    @@ Auth.Model.User.create
         ~username
         ~password
         ~email
         ~is_superuser:true
         ~is_staff:false
  with
  | Ok _ ->
      Fmt.pr "@[%a@]@." Cli.pp_success "Superuser successfully created.";
      exit 0
  | Error _ ->
      Fmt.pr "@[%a@]@." Cli.pp_error "Error: username and/or email conflict.";
      exit 1
