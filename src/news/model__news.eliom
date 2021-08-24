module H = Html

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

  module Private = struct
    let build ~title ~short_title ~content ~pub_time =
      { title; short_title; content; pub_time }
  end

  let build_new ~title ~short_title ~content =
    let pub_time = Time.now () in
    Private.build ~title ~short_title ~content ~pub_time

  let slug news =
    Utils.slugify @@ title news

  let content_as_string item =
    Html.elt_to_string (content item)

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

let content_as_string =
  lift Item.content_as_string

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

module Request = struct

  let all =
    Db.collect
      ~out:(db_type, db_unmap)
      {|
        SELECT id, title, short_title, pub_time, content
          FROM news
          ORDER BY pub_time DESC
      |}

  let find id =
    Db.find
      ~in_:(Id.db_type, id)
      ~out:(db_type, db_unmap)
      {|
        SELECT id, title, short_title, pub_time, content
        FROM news
        WHERE id = ?
        LIMIT 1
      |}

  let create_from_item item =
    Db.find
      ~in_:(Item.db_type, Item.db_map item)
      ~out:(db_type, db_unmap)
      {|
        INSERT INTO news (title, short_title, pub_time, content)
        VALUES (?, ?, ?, ?)
        RETURNING id, title, short_title, pub_time, content
      |}

  let create ~title ~short_title ~content =
    create_from_item @@
    Item.build_new ~title ~short_title ~content

  let update_with_item id item =
    Db.find
      ~in_:(Product.db_type, Product.db_map (id, item))
      ~out:(db_type, db_unmap)
      {|
        UPDATE news
        SET title = $2,
            short_title = $3,
            pub_time = $4,
            content = $5
        WHERE id = $1
        RETURNING id, title, short_title, pub_time, content
      |}

  let update_as_new id ~title ~short_title ~content =
    let item = Item.build_new ~title ~short_title ~content in
    update_with_item id item

  let find_and_delete id =
    Db.find
      ~in_:(Id.db_type, id)
      ~out:(Item.db_type, Item.db_unmap)
      {|
        DELETE FROM news
        WHERE id = ?
        RETURNING title, short_title, pub_time, content
      |}

end

let all () =
  Db.run Request.all

let find id =
  Db.run (Request.find id)

let create_from_item item =
  Db.run (Request.create_from_item item)

let create ~title ~short_title ~content =
  Db.run (Request.create ~title ~short_title ~content)

let update_with_item id item =
  Db.run (Request.update_with_item id item)

let update_as_new id ~title ~short_title ~content =
  Db.run (Request.update_as_new id ~title ~short_title ~content)

let find_and_delete id =
  Db.run (Request.find_and_delete id)

