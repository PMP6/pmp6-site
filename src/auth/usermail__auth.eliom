module Model = Model__auth

let send
    ~user
    ?(forced_address = Model.User.email user)
    ?(forced_username = Model.User.username user)
    ~subject
    ~content
    () =
  let to_ = [ forced_address ] in
  Email.send
    ~auto_generated:()
    ~to_
    ~subject
    ~content:(Fmt.str "Bonjour %s,@.@.@[%a@]" forced_username Fmt.text content)
    ()

let send_async ~user ?forced_address ?forced_username ~subject ~content () =
  Lwt.async @@ fun () -> send ~user ?forced_address ?forced_username ~subject ~content ()
