include Settings_base

(* SMTP *)
let smtp_host = "ssl0.ovh.net"
let smtp_port = 465
let smtp_username = "noreply@pmp6.fr"
let smtp_password = Config.Env.require "SMTP_PASSWORD"
let smtp_starttls = Config.Env.require_bool "SMTP_STARTTLS"

(* Database *)
let db_uri = "sqlite3:pmp6_beta.db"
