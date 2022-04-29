module Handler = Handler__auth
module Service = Service__auth

let routes = Registration_lib.[
  Service.connection, Handler.connection;
  Service.forbidden, Handler.forbidden;
  Service.login, Handler.login;
  Service.logout, Handler.logout;
  Service.Settings.email_edition, Handler.Settings.email_edition;
  Service.Settings.save_email, Handler.Settings.save_email;
  Service.Settings.forgotten_password, Handler.Settings.forgotten_password;
  Service.Settings.request_password_token, Handler.Settings.request_password_token;
  Service.Settings.password_reset, Handler.Settings.password_reset;
  Service.Settings.validate_password_reset, Handler.Settings.validate_password_reset;
  Service.Admin.user_creation, Handler.Admin.user_creation;
  Service.Admin.create_user, Handler.Admin.create_user;
]
