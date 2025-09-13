module App = Eliom_registration.App (struct
  let application_name = "pmp6"
  let global_data_path = Some [ "__global_data__" ]
end)

(* As the headers (stylesheets, etc) won't change, we ask Eliom not to update the <head>
   of the page when changing page. (This also avoids blinking when changing page in
   iOS). *)
let%client () = Eliom_client.persist_document_head ()
