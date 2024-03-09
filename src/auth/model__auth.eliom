let ( & ) = Db.Type.( & )

open Db.Let_syntax

module User = struct
  module Item = struct
    type t = {
      username : string;
      email : string;
      password : Secret.Hash.t;
      is_superuser : bool;
      is_staff : bool;
      joined_time : Time.t;
    }

    let username { username; _ } = username
    let email { email; _ } = email
    let password { password; _ } = password
    let is_superuser { is_superuser; _ } = is_superuser
    let is_staff { is_staff; _ } = is_staff
    let joined_time { joined_time; _ } = joined_time

    let build_new ~username ~email ~password ~is_superuser ~is_staff =
      let joined_time = Time.now () in
      let password = Secret.Hash.encode password in
      { username; email; password; is_superuser; is_staff; joined_time }

    let db_mapping =
      Db.Type.(hlist [ string; string; Secret.Hash.db_type; bool; bool; time ])

    let encode { username; email; password; is_superuser; is_staff; joined_time } =
      Ok Hlist.[ username; email; password; is_superuser; is_staff; joined_time ]

    let decode Hlist.[ username; email; password; is_superuser; is_staff; joined_time ] =
      Ok { username; email; password; is_superuser; is_staff; joined_time }

    let db_type = Db.Type.custom ~encode ~decode db_mapping
    let verify_password { password; _ } attempt = Secret.Hash.verify password attempt
  end

  include Db_model.With_id (Item)

  let username = lift Item.username
  let email = lift Item.email
  let password = lift Item.password
  let verify_password = lift Item.verify_password
  let is_superuser = lift Item.is_superuser
  let is_staff = lift Item.is_staff
  let joined_time = lift Item.joined_time

  module Request = struct
    open Db.Infix_request

    let all =
      (Db.Type.unit ->* db_type)
        {|
          SELECT id, username, email, password, is_superuser, is_staff, joined_time
          FROM auth_user
          ORDER BY joined_time
        |}
        ()

    let find id =
      (Id.db_type ->? db_type)
        {|
          SELECT id, username, email, password, is_superuser, is_staff, joined_time
          FROM auth_user
          WHERE id = ?
          LIMIT 1
        |}
        id

    let find_by_username username =
      (Db.Type.string ->? db_type)
        {|
          SELECT id, username, email, password, is_superuser, is_staff, joined_time
          FROM auth_user
          WHERE username = ?
          LIMIT 1
        |}
        username

    let find_by_email email =
      (Db.Type.string ->? db_type)
        {|
          SELECT id, username, email, password, is_superuser, is_staff, joined_time
          FROM auth_user
          WHERE email = ?
          LIMIT 1
        |}
        email

    let create_from_item item =
      (Item.db_type ->! db_type)
        {|
          INSERT INTO auth_user (username, email, password, is_superuser, is_staff, joined_time)
          VALUES (?, ?, ?, ?, ?, ?)
          RETURNING id, username, email, password, is_superuser, is_staff, joined_time
        |}
        item

    let create ~username ~email ~password ~is_superuser ~is_staff =
      create_from_item
      @@ Item.build_new ~username ~email ~password ~is_superuser ~is_staff

    let find_and_delete id =
      (Id.db_type ->! Item.db_type)
        {|
          DELETE FROM auth_user
          WHERE id = ?
          RETURNING username, email, password, is_superuser, is_staff, joined_time
        |}
        id

    let delete id =
      (Id.db_type ->. Db.Type.unit)
        {|
          DELETE FROM auth_user
          WHERE id = ?
        |}
        id

    let email_exists email =
      (Db.Type.string ->! Db.Type.bool)
        {| SELECT EXISTS (SELECT 1 FROM auth_user WHERE email = ?) |}
        email

    let find_conflicts ?exclude ?username ?email () =
      let (Pack (types, values, names)) =
        Db.Dyn_param.(
          empty
          |> add_opt Db.Type.string username "username"
          |> add_opt Db.Type.string email "email")
      in
      let columns = Db.Dyn_param.to_columns ~sep:`Or ~starting_index:2 names in
      ((Db.Type.option Id.db_type & types) ->* db_type)
        (Fmt.str
           {|
             SELECT id, username, email, password, is_superuser, is_staff, joined_time
             FROM auth_user
             WHERE (%s) AND id IS NOT $1
           |}
           columns)
        (exclude, values)

    let update_exn id ?username ?email ?password ?is_superuser ?is_staff () =
      let (Pack (types, values, names)) =
        Db.Dyn_param.(
          empty
          |> add_opt Db.Type.string username "username"
          |> add_opt Db.Type.string email "email"
          |> add_opt
               Secret.Hash.db_type
               (Option.map ~f:Secret.Hash.encode password)
               "password"
          |> add_opt Db.Type.bool is_superuser "is_superuser"
          |> add_opt Db.Type.bool is_staff "is_staff")
      in
      let columns = Db.Dyn_param.to_columns ~sep:`Comma ~starting_index:2 names in
      (Db.Type.(Id.db_type & types) ->! db_type)
        (Fmt.str
           {|
             UPDATE auth_user
             SET %s
             WHERE id = $1
             RETURNING id, username, email, password, is_superuser, is_staff, joined_time
           |}
           columns)
        (id, values)

    let update_email_exn id email =
      ((Id.db_type & Db.Type.string) ->. Db.Type.unit)
        {|
          UPDATE auth_user
          SET email = $2
          WHERE id = $1
        |}
        (id, email)

    let update_password id password =
      let hash = Secret.Hash.encode password in
      ((Id.db_type & Secret.Hash.db_type) ->. Db.Type.unit)
        {|
          UPDATE auth_user
          SET password = $2
          WHERE id = $1
        |}
        (id, hash)
  end

  let all () = Db.run Request.all
  let find id = Db.run (Request.find id)
  let find_exn id = Lwt_option.get_exn @@ find id
  let find_or_404 id = Lwt_option.get_or_404 @@ find id
  let find_by_username username = Db.run (Request.find_by_username username)
  let find_by_email email = Db.run (Request.find_by_email email)
  let find_and_delete id = Db.run (Request.find_and_delete id)
  let delete id = Db.run (Request.delete id)
  let email_exists email = Db.run (Request.email_exists email)

  let with_email_check email request =
    Db.with_transaction
      (if%bind Request.email_exists email then return (Error `Email_already_exists)
       else
         let%map result = request () in
         Ok result)

  let classify_conflict ?username:username_ ?email:email_ existing_user =
    []
    |> Utils.cons_if
         (Option.equal String.equal email_ (Some (email existing_user)))
         `Email_already_exists
    |> Utils.cons_if
         (Option.equal String.equal username_ (Some (username existing_user)))
         `Username_already_exists

  let with_conflict_check ?exclude ?username ?email request =
    Db.with_transaction
      (match%bind Request.find_conflicts ?exclude ?username ?email () with
      | [] ->
          let%map result = request () in
          Ok result
      | existing_users ->
          let conflicts =
            List.concat_map ~f:(classify_conflict ?username ?email) existing_users
          in
          return (Error conflicts))

  let create_from_item_exn ({ Item.email; username; _ } as item) =
    Lwt_result.get_exn
    @@ Lwt_result.map_error (fun _ -> Failure "Conflict")
    @@ Db.run
    @@ with_conflict_check ~username ~email
    @@ fun () -> Request.create_from_item item

  let create ~username ~email ~password ~is_superuser ~is_staff =
    Db.run
    @@ with_conflict_check ~username ~email
    @@ fun () -> Request.create ~username ~email ~password ~is_superuser ~is_staff

  let update_email id email =
    Db.run @@ with_email_check email @@ fun () -> Request.update_email_exn id email

  let update_password id password = Db.run (Request.update_password id password)

  let update id ?username ?email ?password ?is_superuser ?is_staff () =
    Db.run
    @@ with_conflict_check ~exclude:id ?username ?email
    @@ fun () ->
    Request.update_exn id ?username ?email ?password ?is_superuser ?is_staff ()
end

module Password_token = struct
  module Item = struct
    type t = {
      hash : Secret.Hash.t;
      user : User.Id.t;
      expiry_time : Time.t;
    }

    let build_new ~hash ~user =
      let expiry_time = Time.add (Time.now ()) Time.Span.hour in
      { hash; user; expiry_time }

    let db_mapping = Db.Type.(hlist [ Secret.Hash.db_type; User.Id.db_type; time ])
    let encode { hash; user; expiry_time } = Ok Hlist.[ hash; user; expiry_time ]
    let decode Hlist.[ hash; user; expiry_time ] = Ok { hash; user; expiry_time }
    let db_type = Db.Type.custom ~encode ~decode db_mapping
  end

  include Db_model.With_id (Item)

  module Request = struct
    open Db.Infix_request

    let create_from_item item =
      (Item.db_type ->! Db.Type.unit)
        {|
          INSERT INTO auth_password_token (hash, user, expiry_time)
          VALUES (?, ?, ?)
        |}
        item

    let create_new user hash = create_from_item @@ Item.build_new ~user ~hash

    let get_all_valid () =
      (Db.Type.time ->* (User.Id.db_type & Secret.Hash.db_type))
        {|
          SELECT user, hash
          FROM auth_password_token
          WHERE expiry_time > ?
        |}
        (Time.now ())

    let delete_for_user user =
      (User.Id.db_type ->. Db.Type.unit)
        {|
          DELETE FROM auth_password_token
          WHERE user = ?
        |}
        user

    let prune_expired () =
      (Db.Type.time ->.& Db.Type.unit)
        {|
          DELETE FROM auth_password_token
          WHERE expiry_time <= ?
        |}
        (Time.now ())
  end

  let create user =
    let token = Secret.Token.create () in
    let hash = Secret.Token.hash token in
    let%lwt () = Db.run @@ Request.create_new user hash in
    Lwt.return token

  let validate_password_reset token ~password =
    let open Db.Let_syntax in
    Db.run
    @@ Db.with_transaction
         (let%bind valid_tokens = Request.get_all_valid () in
          let valid_users =
            List.filter_map
              ~f:(fun (user, hash) ->
                if Secret.Token.verify hash token then Some user else None)
              valid_tokens
          in
          match valid_users with
          | [] -> return (Error `Token_absent_or_expired)
          | _ :: _ :: _ -> return (Error `Unexpected) (* Hash collision ? *)
          | [ user ] ->
              let%bind () = User.Request.update_password user password in
              let%bind () = Request.delete_for_user user in
              return (Ok user))

  let prune_expired () =
    Log.log "Pruning expired password tokens...";
    let%lwt count = Db.run (Request.prune_expired ()) in
    Log.logf "... pruned %i token(s)." count;
    Lwt.return ()

  let _prune_daily : never_returns Lwt.t =
    Log.log "Scheduling a daily expired tokens pruning";
    Lwt_utils.every Time.Span.day prune_expired
end
