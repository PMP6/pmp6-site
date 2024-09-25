include Settings_base

let smtp_host = "ssl0.ovh.net"
let smtp_port = 587
let smtp_username = "noreply@pmp6.fr"
let smtp_password = Config.Env.require "SMTP_PASSWORD"
let db_uri = "sqlite3:/var/local/pmp6/pmp6.db"
