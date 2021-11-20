module Handler = Handler__auth
module Service = Service__auth

let contents = Registration_lib.[
  Service.connection, Handler.connection;
  Service.forbidden, Handler.forbidden;
  Service.login, Handler.login;
]

let actions = Registration_lib.[
  Service.logout, Handler.logout;
]
