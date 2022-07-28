module Handler = Handler__auth
module Service = Service__auth

let routes = Registration_lib.[
  Service.connection, Handler.connection;
  Service.forbidden, Handler.forbidden;
  Service.login, Handler.login;
  Service.logout, Handler.logout;
  Service.Settings.main, Handler.Settings.main;
  Service.Settings.save_email, Handler.Settings.save_email;
  Service.Settings.save_password, Handler.Settings.save_password;
  Service.Settings.forgotten_password, Handler.Settings.forgotten_password;
  Service.Settings.request_password_token, Handler.Settings.request_password_token;
  Service.Settings.password_reset, Handler.Settings.password_reset;
  Service.Settings.validate_password_reset, Handler.Settings.validate_password_reset;
  Service.Admin.main, Handler.Admin.main;
  Service.Admin.user_creation, Handler.Admin.user_creation;
  Service.Admin.user_edition, Handler.Admin.user_edition;
  Service.Admin.create_user, Handler.Admin.create_user;
  Service.Admin.update_user, Handler.Admin.update_user;
  Service.Admin.delete_user, Handler.Admin.delete_user;
]
