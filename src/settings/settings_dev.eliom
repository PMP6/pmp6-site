include Settings_base

(* SMTP. *)
let smtp_host = Config.Env.require "SMTP_HOST"
let smtp_port = int_of_string (Config.Env.require "SMTP_PORT")
let smtp_username = Config.Env.require "SMTP_USERNAME"
let smtp_password = Config.Env.require "SMTP_PASSWORD"

(* Database. *)
let db_uri = "sqlite3:pmp6_test.db"
