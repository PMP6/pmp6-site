include Settings_base

(* SMTP *)
let smtp_host = Config.Env.require "SMTP_HOST"
let smtp_port = Config.Env.require_int "SMTP_PORT"
let smtp_username = Config.Env.require "SMTP_USERNAME"
let smtp_password = Config.Env.require "SMTP_PASSWORD"
let smtp_starttls = Config.Env.require_bool "SMTP_STARTTLS"

(* Database *)
let db_uri = "sqlite3:/var/local/pmp6/pmp6.db"
