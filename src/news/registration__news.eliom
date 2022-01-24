module Handler = Handler__news
module Service = Service__news

let routes = Registration_lib.[
  Service.main, Handler.list_all;
  Service.redaction, Handler.redaction;
  Service.create_into_main, Handler.create;
  Service.edition, Handler.edition;
  Service.update_into_main, Handler.update;
  Service.delete, Handler.delete;
]
