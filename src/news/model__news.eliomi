module Item : sig
  include Db_utils.Data

  val title : t -> string
  val short_title : t -> string
  val pub_time : t -> Time.t
  val content : t -> Html_types.div_content_fun Html.elt

  val build_new :
    title:string ->
    short_title:string ->
    content:Html_types.div_content_fun Html.elt ->
    t

  val slug : t -> string
  val content_as_string : t -> string

  module Private : sig
    val build :
      title:string ->
      short_title:string ->
      content:Html_types.div_content_fun Html.elt ->
      pub_time:Time.t ->
      t
  end
end

include Db_utils.Data_with_id with type item := Item.t

(** {1 Utilities} *)

(** {2 Lifted } *)

val title : t -> string
val short_title : t -> string
val pub_time : t -> Time.t
val content : t -> Html_types.div_content_fun Html.elt

val slug : t -> string
val content_as_string : t -> string

(** {2 Misc } *)

(** Guarantee to return different slugs when the ids are distinct *)
val unique_slug : ?prefix:string -> t -> string

(** {2 Database-related functions } *)

val get_all : unit -> t list Lwt.t

val get : Id.t -> t Lwt.t

val create_from_item : Item.t -> t Lwt.t

val create :
  title:string ->
  short_title:string ->
  content:Html_types.div_content_fun Html.elt ->
  t Lwt.t

val update_with_item : Id.t -> Item.t -> t Lwt.t

val update_as_new :
  Id.t ->
  title:string ->
  short_title:string ->
  content:Html_types.div_content_fun Html.elt ->
  t Lwt.t

val delete : Id.t -> Item.t Lwt.t
