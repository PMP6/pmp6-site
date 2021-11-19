module Handler = Handler__news
module Service = Service__news

let pages = Registration_lib.[
  Service.main, Handler.list_all;
  Service.redaction, Handler.redaction;
  Service.edition, Handler.edition;
]

let actions = Registration_lib.[
  Service.create_into_main, Handler.create;
  Service.update_into_main, Handler.update;
  Service.delete, Handler.delete;
]

let redirections = Registration_lib.[]
