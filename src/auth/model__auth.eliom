module Password = Password__auth

let ( & ) x y = (x, y)

module User = struct

  module Item = struct
    type t = {
      username : string;
      email : string;
      password : Password.encoded;
      is_superuser : bool;
      is_staff : bool;
      joined_time : Time.t;
    }

    type mapping = string * (string * (Password.encoded * (bool * (bool * (Time.t)))))

    let username { username; _ } = username
    let email { email; _ } = email
    let password { password; _ } = password
    let is_superuser { is_superuser; _ } = is_superuser
    let is_staff { is_staff; _ } = is_staff
    let joined_time { joined_time; _ } = joined_time

    let build_new ~username ~email ~password ~is_superuser ~is_staff =
      let joined_time = Time.now () in
      let password = Password.encode password in
      { username; email; password; is_superuser; is_staff; joined_time }

    let db_type =
      Db.Type.(string & string & Password.db_type & bool & bool & time)

    let db_unmap
        (username, (email, (password, (is_superuser, (is_staff, (joined_time)))))) =
      {
        username;
        email;
        password;
        is_superuser;
        is_staff;
        joined_time;
      }

    let db_map { username; email; password; is_superuser; is_staff; joined_time } =
      username &
      email &
      password &
      is_superuser &
      is_staff &
      joined_time

    let verify_password { password; _ } attempt =
      Password.verify password attempt
  end

  include Db_utils.With_id (Item)

  let username =
    lift Item.username

  let email =
    lift Item.email

  let password =
    lift Item.password

  let verify_password =
    lift Item.verify_password

  let is_superuser =
    lift Item.is_superuser

  let is_staff =
    lift Item.is_staff

  let joined_time =
    lift Item.joined_time

  module Request = struct

    let all =
      Db.collect
        ~out:(db_type, db_unmap)
        {|
          SELECT id, username, email, password, is_superuser, is_staff, joined_time
          FROM auth_user
          ORDER BY joined_time
        |}

    let find id =
      Db.find
        ~in_:(Id.db_type, id)
        ~out:(db_type, db_unmap)
        {|
          SELECT id, username, email, password, is_superuser, is_staff, joined_time
          FROM auth_user
          WHERE id = ?
          LIMIT 1
        |}

    let find_by_username username =
      Db.find_opt
        ~in_:(Db.Type.string, username)
        ~out:(db_type, db_unmap)
        {|
          SELECT id, username, email, password, is_superuser, is_staff, joined_time
          FROM auth_user
          WHERE username = ? COLLATE NOCASE
          LIMIT 1
        |}

    let create_from_item item =
      Db.find
        ~in_:(Item.db_type, Item.db_map item)
        ~out:(db_type, db_unmap)
        {|
          INSERT INTO auth_user (username, email, password, is_superuser, is_staff, joined_time)
          VALUES (?, ?, ?, ?, ?, ?)
          RETURNING id, username, email, password, is_superuser, is_staff, joined_time
        |}

    let create ~username ~email ~password ~is_superuser ~is_staff =
      create_from_item @@
      Item.build_new ~username ~email ~password ~is_superuser ~is_staff

    let find_and_delete id =
      Db.find
        ~in_:(Id.db_type, id)
        ~out:(Item.db_type, Item.db_unmap)
        {|
          DELETE FROM auth_user
          WHERE id = ?
          RETURNING username, email, password, is_superuser, is_staff, joined_time
        |}

    let delete id =
      Db.exec
        ~in_:(Id.db_type, id)
        {|
          DELETE FROM auth_user
          WHERE id = ?
        |}

  end

  let all () =
    Db.run Request.all

  let find id =
    Db.run (Request.find id)

  let find_by_username username =
    Db.run (Request.find_by_username username)

  let create_from_item item =
    Db.run (Request.create_from_item item)

  let create ~username ~email ~password ~is_superuser ~is_staff =
    Db.run (Request.create ~username ~email ~password ~is_superuser ~is_staff)

  let find_and_delete id =
    Db.run (Request.find_and_delete id)

  let delete id =
    Db.run (Request.delete id)

end
