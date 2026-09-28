[%%server.start]

type outcome = {
  passed : int;
  skipped : int;
}

let zero = { passed = 0; skipped = 0 }
let one_passed = { passed = 1; skipped = 0 }
let one_skipped = { passed = 0; skipped = 1 }

let combine { passed = p1; skipped = s1 } { passed = p2; skipped = s2 } =
  { passed = p1 + p2; skipped = s1 + s2 }

let check_unit ?(if_ = true) name run_test () =
  if if_ then (
    Log.logf "Running config check `%s`..." name;
    match%lwt run_test () with
    | () ->
        Log.logf "Config check `%s` passed." name;
        Lwt.return one_passed
    | exception e ->
        Log.logf "Config check `%s` failed with error: %s" name (Exn.to_string e);
        Lwt.fail e)
  else (
    Log.logf "Skipping disabled check `%s`" name;
    Lwt.return one_skipped)

let check_bool ?if_ name run_test =
  check_unit ?if_ name (fun () ->
      if%lwt run_test () then Lwt.return () else Lwt.fail_with "unmet condition")

let check_ignore ?if_ name run_test =
  check_unit ?if_ name (fun () -> Lwt_monad.ignore_m @@ run_test ())

let check_list tests =
  let%lwt outcomes = Lwt_list.map_p (fun test -> test ()) tests in
  Lwt.return (List.fold ~init:zero ~f:combine outcomes)

let tests =
  [
    check_bool "enabled foreign keys" Db.check_foreign_keys;
    check_unit "db supports affected count" Db.check_affected_count_is_supported;
    check_unit "email" Email.check ~if_:Settings.smtp.check_settings;
    check_ignore "smoke user model" Auth.Model.User.all;
    check_ignore "smoke news model" News.Model.all;
  ]

let log_root_uri () =
  Log.logf
    "Site will now be available on %s"
    (Eliom_uri.make_string_uri ~absolute:true ~service:Skeleton.home_service ())

let () =
  Log.logf "Running configuration checks...";
  match Lwt_main.run @@ check_list tests with
  | { passed; skipped } ->
      Log.logf
        "All configuration checks successful (%d passed, %d skipped)."
        passed
        skipped;
      log_root_uri ()
  | exception _ ->
      Log.logf "At least one configuration check failed. Now stopping the server.";
      exit 0
