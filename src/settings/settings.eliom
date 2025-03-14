module Smtp = struct
  let host = Config.Env.require "SMTP_HOST"
  let port = Config.Env.require_int "SMTP_PORT"
  let username = Config.Env.require "SMTP_USERNAME"
  let password = Config.Env.require "SMTP_PASSWORD"
  let use_starttls = Config.Env.require_bool "SMTP_STARTTLS"
end

module Database = struct
  let uri = Config.Env.require "DB_URI"
end

module Email = struct
  let default_from_display_name = "PMP6"
  let default_from_email = "noreply@pmp6.fr"

  let default_subject_prefix =
    (* Don't forget to add a trailing space if desired *)
    "[Site web PMP6] "

  let default_signature = Some "L'équipe du site web PMP6\nhttps://pmp6.fr"
end
