module H = Html
open Lwt.Infix

let ( & ) x y = (x, y)

module Data = struct
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

include Data
include Db_utils.With_id (Data)

let create ~title ~short_title ~content =
  { title; short_title; content; pub_time = Time.now (); }

let title =
  lift Data.title

let short_title =
  lift Data.short_title

let content =
  lift Data.content

let pub_time =
  lift Data.pub_time

let slug =
  lift Data.slug

let unique_slug ?prefix news_with_id =
  let prefix = match prefix with
    | None -> ""
    | Some prefix -> prefix ^ "-" in
  Fmt.str "%s%a-%s"
    prefix
    Id.pp (id news_with_id)
    (slug news_with_id)

let get_all () =
  Db.get_all
    db_unmap_with_id
    db_type_with_id
    {|
      SELECT id, title, short_title, pub_time, content
        FROM news
        ORDER BY pub_time DESC
    |}

let get_all_exn () =
  get_all () >|=
  Db.or_exn

let get_all_data () =
  Db.get_all
    db_unmap
    db_type
    {|
      SELECT title, short_title, pub_time, content
        FROM news
        ORDER BY pub_time DESC
    |}

let get_all_data_exn () =
  get_all_data () >|=
  Db.or_exn

let get_one id =
  Db.get_one db_unmap_with_id Id.db_type id db_type_with_id
    {|
        SELECT id, title, short_title, pub_time, content
        FROM news
        WHERE id = ?
        LIMIT 1
      |}

let get_one_exn id =
  get_one id >|=
  Db.or_exn

let insert news =
  Db.exec
    db_type
    (db_map news)
    {|
      INSERT INTO news (title, short_title, pub_time, content)
      VALUES (?, ?, ?, ?)
    |}

let insert_exn news =
  insert news >|=
  Db.or_exn

let update news_with_id =
  Db.exec
    db_type_with_id
    (db_map_with_id news_with_id)
    {|
      UPDATE news
      SET title = $2,
          short_title = $3,
          pub_time = $4,
          content = $5
      WHERE id = $1
    |}

let update_exn news_with_id =
  update news_with_id >|=
  Db.or_exn

let delete id =
  Db.exec Id.db_type id
    {| DELETE FROM news WHERE id = ? |}

let delete_exn id =
  delete id >|=
  Db.or_exn
