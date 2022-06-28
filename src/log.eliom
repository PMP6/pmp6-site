(* This could deserve a more complete design, but is barely used for
   now and will thus mostly serve as a greppable target for a future
   refactoring. *)

let section = Lwt_log_core.Section.make Pmp6.App.application_name

let log string =
  Ocsigen_messages.warning ~section string

let logf fmt =
  Fmt.kstr log fmt
