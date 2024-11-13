let config =
  Letters.Config.create
    ~username:Settings.smtp_username
    ~password:Settings.smtp_password
    ~hostname:Settings.smtp_host
    ~with_starttls:true
    ()
  |> Letters.Config.set_port (Some Settings.smtp_port)

let mailbox_as_string_exn ~display_name ~email =
  let email_mailbox =
    match Mrmime.Mailbox.of_string email with
    | Ok email -> email
    | Error (`Msg msg) -> failwith msg
  in
  let display_name_phrase = Mrmime.Mailbox.Phrase.(v [ word_exn display_name ]) in
  Mrmime.Mailbox.with_name display_name_phrase email_mailbox |> Mrmime.Mailbox.to_string

let send
    ?auto_generated
    ?(display_name = Settings.default_from_display_name)
    ?(from = Settings.default_from_email)
    ~to_
    ~subject
    ?(subject_prefix = Settings.default_email_subject_prefix)
    ~content
    ?(signature = Settings.default_email_signature)
    ?(cc = [])
    ?(bcc = [])
    () =
  let from = mailbox_as_string_exn ~display_name ~email:from in
  let reply_to = match auto_generated with Some () -> None | None -> Some from in
  let content =
    match signature with
    | None -> content
    | Some signature -> content ^ "\n\n" ^ signature
  in
  let content =
    match auto_generated with
    | None -> content
    | Some () ->
        content
        ^ "\n\nCet email a été généré automatiquement. Merci de ne pas y répondre."
  in
  let recipients =
    let to_ = List.map ~f:(fun x -> Letters.To x) to_ in
    let cc = List.map ~f:(fun x -> Letters.Cc x) cc in
    let bcc = List.map ~f:(fun x -> Letters.Bcc x) bcc in
    List.concat [ to_; cc; bcc ]
  in
  let message =
    Letters.create_email
      ~from
      ?reply_to
      ~recipients
      ~subject:(subject_prefix ^ subject)
      ~body:(Letters.Plain content)
      ()
    |> Result.ok_or_failwith
  in
  Letters.send ~config ~sender:from ~recipients ~message

let send
    ?auto_generated
    ?display_name
    ?from
    ~to_
    ~subject
    ?subject_prefix
    ~content
    ?signature
    ?cc
    ?bcc
    () =
  (* Hack for send failures that just retries 10 times. *)
  let rec aux nb_future_tries =
    match%lwt
      send
        ?auto_generated
        ?display_name
        ?from
        ~to_
        ~subject
        ?subject_prefix
        ~content
        ?signature
        ?cc
        ?bcc
        ()
    with
    | result -> Lwt.return result
    | exception exn ->
        if nb_future_tries >= 1 then
          let () =
            Log.logf
              "Email sending failed (%a), %d tries remaining.@."
              Exn.pp
              exn
              nb_future_tries
          in
          let%lwt () = Lwt_unix.sleep 1.0 in
          aux (nb_future_tries - 1)
        else Lwt.reraise exn
  in
  aux 10

let check () =
  (* Sending a dummy empty mail and hope no exception is raised. *)
  send
    ~to_:[ "pmp6@mailinator.com" ]
    ~from:"pmp6@dummy.dummy"
    ~display_name:"Le site PMP6"
    ~subject_prefix:"[PMP6] "
    ~subject:"Test"
    ~content:"Dummy check"
    ~signature:(Some "Le site PMP6")
    ()
