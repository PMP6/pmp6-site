let ( & ) = Db.Type.( & )

module User = Auth.Model.User

module Item = struct
  type t = {
    title : string;
    short_title : string;
    pub_time : Time_ns.t;
    content : Doc.t;
    author : User.Id.t;
    is_visible : bool;
  }

  let title { title; _ } = title
  let short_title { short_title; _ } = short_title
  let pub_time { pub_time; _ } = pub_time
  let content { content; _ } = content
  let author { author; _ } = author
  let is_visible { is_visible; _ } = is_visible
  let is_invisible news = not (is_visible news)

  module Private = struct
    let build ~title ~short_title ~content ~pub_time ~author ~is_visible =
      { title; short_title; content; pub_time; author; is_visible }
  end

  let build_new ~title ~short_title ~content ~author ~is_visible =
    let pub_time = Time_ns.now () in
    Private.build ~title ~short_title ~content ~pub_time ~author ~is_visible

  let slug news = Utils.slugify @@ title news
  let content_as_md item = Doc.to_md @@ content item
  let content_as_html item = Doc.to_html @@ content item
  let content_as_div item = Doc.to_div @@ content item

  let db_mapping =
    Db.Type.(hlist [ string; string; time; Doc.db_type; User.Id.db_type; bool ])

  let encode { title; short_title; pub_time; content; author; is_visible } =
    Ok Hlist.[ title; short_title; pub_time; content; author; is_visible ]

  let decode Hlist.[ title; short_title; pub_time; content; author; is_visible ] =
    Ok { title; short_title; pub_time; content; author; is_visible }

  let db_type = Db.Type.custom ~encode ~decode db_mapping
end

include Db_model.With_id (Item)

let title = lift Item.title
let short_title = lift Item.short_title
let content = lift Item.content
let pub_time = lift Item.pub_time
let author = lift Item.author
let is_visible = lift Item.is_visible
let is_invisible = lift Item.is_invisible
let content_as_md = lift Item.content_as_md
let content_as_html = lift Item.content_as_html
let content_as_div = lift Item.content_as_div
let slug = lift Item.slug

let unique_slug ?prefix model =
  let prefix = match prefix with None -> "" | Some prefix -> prefix ^ "-" in
  Fmt.str "%s%a-%s" prefix Id.pp (id model) (slug model)

module Request = struct
  open Db.Infix_request

  let all =
    (Db.Type.unit ->* db_type)
      {|
        SELECT id, title, short_title, pub_time, content, author, is_visible
          FROM news
          ORDER BY pub_time DESC
      |}
      ()

  let visible =
    (Db.Type.unit ->* db_type)
      {|
        SELECT id, title, short_title, pub_time, content, author, is_visible
          FROM news
          WHERE is_visible
          ORDER BY pub_time DESC
      |}
      ()

  let find id =
    (Id.db_type ->! db_type)
      {|
        SELECT id, title, short_title, pub_time, content, author, is_visible
        FROM news
        WHERE id = ?
        LIMIT 1
      |}
      id

  let create_from_item item =
    (Item.db_type ->! db_type)
      {|
        INSERT INTO news (title, short_title, pub_time, content, author, is_visible)
        VALUES (?, ?, ?, ?, ?, ?)
        RETURNING id, title, short_title, pub_time, content, author, is_visible
      |}
      item

  let create ~title ~short_title ~content ~author ~is_visible =
    create_from_item @@ Item.build_new ~title ~short_title ~content ~author ~is_visible

  let update_with_item id item =
    (Product.db_type ->! db_type)
      {|
        UPDATE news
        SET title = $2,
            short_title = $3,
            pub_time = $4,
            content = $5,
            author = $6,
            is_visible = $7
        WHERE id = $1
        RETURNING id, title, short_title, pub_time, content, author, is_visible
      |}
      (id, item)

  let update id ?title ?short_title ?pub_time ?content ?author ?is_visible () =
    let (Pack (types, values, names)) =
      Db.Dyn_param.(
        empty
        |> add_opt Db.Type.string title "title"
        |> add_opt Db.Type.string short_title "short_title"
        |> add_opt Db.Type.time pub_time "pub_time"
        |> add_opt Doc.db_type content "content"
        |> add_opt Auth.Model.User.Id.db_type author "author"
        |> add_opt Db.Type.bool is_visible "is_visible")
    in
    let columns = Db.Dyn_param.to_columns ~sep:`Comma ~starting_index:2 names in
    ((Id.db_type & types) ->! db_type)
      (Fmt.str
         {|
           UPDATE news
           SET %s
           WHERE id = $1
           RETURNING id, title, short_title, pub_time, content, author, is_visible
         |}
         columns)
      (id, values)

  let find_and_delete id =
    (Id.db_type ->! Item.db_type)
      {|
        DELETE FROM news
        WHERE id = ?
        RETURNING title, short_title, pub_time, content, author, is_visible
      |}
      id

  let delete id =
    (Id.db_type ->. Db.Type.unit)
      {|
        DELETE FROM news
        WHERE id = ?
      |}
      id
end

let all () = Db.run Request.all
let visible () = Db.run Request.visible
let find id = Db.run (Request.find id)
let create_from_item item = Db.run (Request.create_from_item item)

let create ~title ~short_title ~content ~author ~is_visible =
  Db.run (Request.create ~title ~short_title ~content ~author ~is_visible)

let update_with_item id item = Db.run (Request.update_with_item id item)

let update id ?title ?short_title ?pub_time ?content ?author ?is_visible () =
  Db.run (Request.update id ?title ?short_title ?pub_time ?content ?author ?is_visible ())

let find_and_delete id = Db.run (Request.find_and_delete id)
let delete id = Db.run (Request.delete id)
