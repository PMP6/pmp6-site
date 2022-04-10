module H = Html

module User = Auth.Model.User

module Item = struct
  type t = {
    title : string;
    short_title : string;
    pub_time : Time.t;
    content : Html_types.div_content_fun H.elt;
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
    let pub_time = Time.now () in
    Private.build ~title ~short_title ~content ~pub_time ~author ~is_visible

  let slug news =
    Utils.slugify @@ title news

  let content_as_string item =
    Html.elt_to_string (content item)

  type mapping =
    (string -> string -> Time.t -> string -> User.Id.t -> bool -> unit) Hlist.t

  let db_type =
    Db.Type.(hlist [ string; string; time; string; User.Id.db_type; bool ])

  let db_unmap Hlist.[ title; short_title; pub_time; content; author; is_visible ] =
    {
      title;
      short_title;
      pub_time;
      content = Html.Unsafe.data content;
      author;
      is_visible;
    }

  let db_map { title; short_title; pub_time; content; author; is_visible } =
    Hlist.[
      title;
      short_title;
      pub_time;
      Html.elt_to_string content;
      author;
      is_visible;
    ]
end

include Db_model.With_id (Item)

let title =
  lift Item.title

let short_title =
  lift Item.short_title

let content =
  lift Item.content

let pub_time =
  lift Item.pub_time

let author =
  lift Item.author

let is_visible =
  lift Item.is_visible

let is_invisible =
  lift Item.is_invisible

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
    Db.collect_all
      ~out:(db_type, db_unmap)
      {|
        SELECT id, title, short_title, pub_time, content, author, is_visible
          FROM news
          ORDER BY pub_time DESC
      |}

  let visible =
    Db.collect_all
      ~out:(db_type, db_unmap)
      {|
        SELECT id, title, short_title, pub_time, content, author, is_visible
          FROM news
          WHERE is_visible
          ORDER BY pub_time DESC
      |}

  let find id =
    Db.find
      ~in_:(Id.db_type, id)
      ~out:(db_type, db_unmap)
      {|
        SELECT id, title, short_title, pub_time, content, author, is_visible
        FROM news
        WHERE id = ?
        LIMIT 1
      |}

  let create_from_item item =
    Db.find
      ~in_:(Item.db_type, Item.db_map item)
      ~out:(db_type, db_unmap)
      {|
        INSERT INTO news (title, short_title, pub_time, content, author, is_visible)
        VALUES (?, ?, ?, ?, ?, ?)
        RETURNING id, title, short_title, pub_time, content, author, is_visible
      |}

  let create ~title ~short_title ~content ~author ~is_visible =
    create_from_item @@
    Item.build_new ~title ~short_title ~content ~author ~is_visible

  let update_with_item id item =
    Db.find
      ~in_:(Product.db_type, Product.db_map (id, item))
      ~out:(db_type, db_unmap)
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

  let update id ?title ?short_title ?pub_time ?content ?author ?is_visible () =
    let Pack (types, values, names) = Db.Dyn_param.(
      empty
      |> add_opt Db.Type.string title "title"
      |> add_opt Db.Type.string short_title "short_title"
      |> add_opt Db.Type.time pub_time "pub_time"
      |> add_opt Db.Type.string (Option.map ~f:Html.elt_to_string content) "content"
      |> add_opt Auth.Model.User.Id.db_type author "author"
      |> add_opt Db.Type.bool is_visible "is_visible"
    ) in
    let set_fields = Db.Dyn_param.set ~from:2 names in
    Db.find
      ~in_:(Db.Type.(Id.db_type & types), (id, values))
      ~out:(db_type, db_unmap)
      (Fmt.str
         {|
           UPDATE news
           SET %s
           WHERE id = $1
           RETURNING id, title, short_title, pub_time, content, author, is_visible
         |} set_fields)

  let find_and_delete id =
    Db.find
      ~in_:(Id.db_type, id)
      ~out:(Item.db_type, Item.db_unmap)
      {|
        DELETE FROM news
        WHERE id = ?
        RETURNING title, short_title, pub_time, content, author, is_visible
      |}

  let delete id =
    Db.exec
      ~in_:(Id.db_type, id)
      {|
        DELETE FROM news
        WHERE id = ?
      |}

end

let all () =
  Db.run Request.all

let visible () =
  Db.run Request.visible

let find id =
  Db.run (Request.find id)

let create_from_item item =
  Db.run (Request.create_from_item item)

let create ~title ~short_title ~content ~author ~is_visible =
  Db.run (Request.create ~title ~short_title ~content ~author ~is_visible)

let update_with_item id item =
  Db.run (Request.update_with_item id item)

let update id ?title ?short_title ?pub_time ?content ?author ?is_visible () =
  Db.run (Request.update id ?title ?short_title ?pub_time ?content ?author ?is_visible ())

let find_and_delete id =
  Db.run (Request.find_and_delete id)

let delete id =
  Db.run (Request.delete id)
