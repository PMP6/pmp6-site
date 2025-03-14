(* SMTP *)
let smtp_host = Config.Env.require "SMTP_HOST"
let smtp_port = Config.Env.require_int "SMTP_PORT"
let smtp_username = Config.Env.require "SMTP_USERNAME"
let smtp_password = Config.Env.require "SMTP_PASSWORD"
let smtp_starttls = Config.Env.require_bool "SMTP_STARTTLS"

(* Database *)
let db_uri = Config.Env.require "DB_URI"

(* Emails *)
let default_from_display_name = "PMP6"
let default_from_email = "noreply@pmp6.fr"

let default_email_subject_prefix =
  (* Don't forget to add a trailing space if desired *)
  "[Site web PMP6] "

let default_email_signature = Some "L'équipe du site web PMP6\nhttps://pmp6.fr"
