module H = Html
open Lwt.Infix

let ( & ) x y = (x, y)

module Item = struct
  type t = {
    title : string;
    short_title : string;
    pub_time : Time.t;
    content : Html_types.div_content_fun H.elt;
  }

  type mapping = string * (string * (Time.t * string))

  let title { title; _ } = title
  let short_title { short_title; _ } = short_title
  let pub_time { pub_time; _ } = pub_time
  let content { content; _ } = content

  let build ~title ~short_title ~content ~pub_time =
    { title; short_title; content; pub_time }

  let build_now =
    build ~pub_time:(Time.now ())

  let slug news =
    Utils.slugify @@ title news

  let db_type =
    Db.Type.(string & string & time & string)

  let db_unmap (title, (short_title, (pub_time, (content)))) =
    {
      title;
      short_title;
      pub_time;
      content = Html.Unsafe.data content;
    }

  let db_map { title; short_title; pub_time; content } =
    title &
    short_title &
    pub_time &
    Html.elt_to_string content
end

include Db_utils.With_id (Item)

let title =
  lift Item.title

let short_title =
  lift Item.short_title

let content =
  lift Item.content

let pub_time =
  lift Item.pub_time

let slug =
  lift Item.slug

let unique_slug ?prefix model =
  let prefix = match prefix with
    | None -> ""
    | Some prefix -> prefix ^ "-" in
  Fmt.str "%s%a-%s"
    prefix
    Id.pp (id model)
    (slug model)

let get_all () =
  Db.get_all
    db_unmap
    db_type
    {|
      SELECT id, title, short_title, pub_time, content
        FROM news
        ORDER BY pub_time DESC
    |}

let get_all_exn () =
  get_all () >|=
  Db.or_exn

let get_all_items () =
  Db.get_all
    Item.db_unmap
    Item.db_type
    {|
      SELECT title, short_title, pub_time, content
        FROM news
        ORDER BY pub_time DESC
    |}

let get_all_items_exn () =
  get_all_items () >|=
  Db.or_exn

let get_one_sql =
    {|
        SELECT id, title, short_title, pub_time, content
        FROM news
        WHERE id = ?
        LIMIT 1
      |}

let get_one id =
  Db.get_one db_unmap Id.db_type id db_type get_one_sql

let get_one_exn id =
  get_one id >|=
  Db.or_exn

let create_with_item item =
  Db.exec
    Item.db_type
    (Item.db_map item)
    {|
      INSERT INTO news (title, short_title, pub_time, content)
      VALUES (?, ?, ?, ?)
    |}

let create_with_item_exn item =
  create_with_item item >|=
  Db.or_exn

let create ~title ~short_title ~content =
  create_with_item (Item.build_now ~title ~short_title ~content)

let create_exn ~title ~short_title ~content =
  create ~title ~short_title ~content >|=
  Db.or_exn

let update_with_item id item =
  Db.exec
    Product.db_type
    (Product.db_map (id, item))
    {|
      UPDATE news
      SET title = $2,
          short_title = $3,
          pub_time = $4,
          content = $5
      WHERE id = $1
    |}

let update_with_item_exn id item =
  update_with_item id item >|=
  Db.or_exn

let delete_sql =
  {| DELETE FROM news WHERE id = ? |}

let delete id =
  Db.exec Id.db_type id delete_sql

let delete_exn id =
  delete id >|=
  Db.or_exn

let delete_and_return id =
  (* TODO: this shows that the above abstraction for requests is not
     flexible enough. *)
  (* Also TODO: some helpers for transactions *)
  let open Lwt_result.Infix in
  let exec (module C : Caqti_lwt.CONNECTION) =
    C.start () >>= fun () ->
    let%lwt result =
      C.find (Caqti_request.find Id.db_type db_type get_one_sql) id >>= fun model ->
      C.exec (Caqti_request.exec Id.db_type delete_sql) id >|= fun () ->
      model in
    match result with
    | Ok model ->
      C.commit () >>= fun () ->
      Lwt_result.return @@ item @@ db_unmap model
    | Error e ->
      C.rollback () >>= fun () ->
      Lwt_result.fail e
  in
  Db.run exec

let delete_and_return_exn id =
  delete_and_return id >|=
  Db.or_exn
