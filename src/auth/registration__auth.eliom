module Handler = Handler__auth
module Service = Service__auth

let contents = Registration_lib.[
  Service.connection, Handler.connection;
  Service.forbidden, Handler.forbidden;
  Service.login, Handler.login;
  Service.Settings.email_edition, Handler.Settings.email_edition;
]

let actions = Registration_lib.[
  Service.logout, Handler.logout;
  Service.Settings.save_email, Handler.Settings.save_email;
]
