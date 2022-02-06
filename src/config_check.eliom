let check_unit name run_test () =
  Log.logf "Running config check `%s`..." name;
  match%lwt run_test () with
  | () ->
    Log.logf "Config check `%s` passed." name;
    Lwt.return ()
  | exception e ->
    Log.logf
      "Config check `%s` failed with error: %s"
      name (Exn.to_string e);
    Lwt.fail e

let check_bool name run_test =
  check_unit name
    (fun () ->
       if%lwt run_test ()
       then Lwt.return ()
       else Lwt.fail_with "unmet condition")

let check_ignore name run_test =
  check_unit name (fun () -> Lwt_monad.ignore_m @@ run_test ())

let check_list tests =
  Lwt_list.fold_left_s
    (fun () test -> test ())
    ()
    tests

let tests = [
  check_bool "enabled foreign keys" Db.check_foreign_keys;
  check_unit "email" Email.check;
  check_ignore "smoke user model" Auth.Model.User.all;
]

let () =
  Log.logf "Running configuration checks...";
  match Lwt_main.run @@ check_list tests with
  | () -> Log.logf "All configuration checks passed."
  | exception _ ->
    Log.logf "At least one configuration check failed. Now stopping the server.";
    exit 0
