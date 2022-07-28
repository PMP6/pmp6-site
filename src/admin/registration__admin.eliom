module Handler = Handler__admin
module Service = Service__admin

let routes = Registration_lib.[
  Service.main, Handler.main;
]
