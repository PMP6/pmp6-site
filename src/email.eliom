open Async_smtp

let server =
  Host_and_port.create ~host:Settings.smtp_host ~port:Settings.smtp_port

let credentials = match Settings.smtp_credentials with
  | None -> None
  | Some (username, password) -> Some (Smtp_client.Credentials.login ~username ~password ())

let send
    ?auto_generated
    ?(display_name=Settings.default_from_display_name)
    ?(from=Settings.default_from_email)
    ~to_
    ~subject ?(subject_prefix=Settings.default_email_subject_prefix)
    ~content ?(signature=Settings.default_email_signature)
    ?(cc=[]) ?(bcc=[])
    () =
  let from = Email_address.create ~prefix:display_name from
  and reply_to = Email_address.of_string_exn from in
  let content = match signature with
    | None -> content
    | Some signature -> content ^ "\n\n" ^ signature
  in
  let content = match auto_generated with
    | None -> content
    | Some () ->
      content ^ "\n\nCet email a été généré automatiquement. Merci de ne pas y répondre."
  in
  let email_addresses list = List.map ~f:Email_address.of_string_exn list in
  Async_bridge.run_exn @@ fun () ->
  Simplemail.send
    ?auto_generated
    ~server
    ?credentials
    ~from
    ~reply_to
    ~to_:(email_addresses to_)
    ~cc:(email_addresses cc)
    ~bcc:(email_addresses bcc)
    ~subject:(subject_prefix ^ subject)
    (Simplemail.Content.text_utf8 content)

let check () =
  (* Sending a dummy empty mail and hope no exception is raised. *)
  send
    ~to_:["dummy@mailinator.com"]
    ~from:"dummy@dummy.dummy"
    ~display_name:""
    ~subject_prefix:""
    ~subject:"Test"
    ~content:"Dummy"
    ~signature:None
    ()
