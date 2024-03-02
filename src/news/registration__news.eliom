module Handler = Handler__news
module Service = Service__news

let routes =
  Registration_lib.
    [
      (Service.Admin.main, Handler.Admin.list_all);
      (Service.Admin.redaction, Handler.Admin.redaction);
      (Service.Admin.create_into_main, Handler.Admin.create);
      (Service.Admin.edition, Handler.Admin.edition);
      (Service.Admin.update_into_main, Handler.Admin.update);
      (Service.Admin.delete, Handler.Admin.delete);
    ]
