include Settings_base

let smtp_host = "ssl0.ovh.net"
let smtp_port = 465
let smtp_username = "noreply@pmp6.fr"
let smtp_password = Config.Env.require "SMTP_PASSWORD"
let smtp_starttls = Config.Env.require_bool "SMTP_STARTTLS"
let db_uri = "sqlite3:pmp6_beta.db"
