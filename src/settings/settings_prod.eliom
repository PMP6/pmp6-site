include Settings_base

let smtp_host = "ssl0.ovh.net"

let smtp_port = 587

let smtp_credentials = Some ("noreply@pmp6.fr", Config.Env.require "SMTP_PASSWORD")

let db_uri = "sqlite3:/home/thibault/pmp6-site/pmp6_test.db"
