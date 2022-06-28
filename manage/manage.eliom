let commands =
  [
    "fixtures", Fixtures.main;
    "superuser", Superuser.main;
  ]

let help () =
  Fmt.pr
    "@[<v>@;@[Usage: give MANAGE_COMMAND as an env var.@]@ \
     @[Availables commands:@ @[%a@].@]@]@."
    Fmt.(list ~sep:comma (pair text nop))
    commands;
  exit 1

let get_cmd name =
  Option.value ~default:help @@
  let%bind.Option name in
  List.Assoc.find ~equal:String.equal commands name

let () =
  Fmt.set_style_renderer Fmt.stdout `Ansi_tty;
  get_cmd (Sys.getenv_opt "MANAGE_COMMAND") ()
