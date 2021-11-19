module Handler = Handler__auth
module Service = Service__auth

let pages = Registration_lib.[
  Service.connection, Handler.connection;
]

let actions = Registration_lib.[
  Service.logout, Handler.logout;
]

let redirections = Registration_lib.[
  Service.login, Handler.login;
]
