module Handler = Handler__admin
module Service = Service__admin

let contents = Registration_lib.[
  Service.main, Handler.main;
]

let actions = Registration_lib.[]
