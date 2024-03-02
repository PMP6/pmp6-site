(* module User : sig module Id : sig type t val db_type : 'a end end *)
module User := Auth.Model.User

module Item : sig
  include Db_model.Data

  val title : t -> string
  val short_title : t -> string
  val pub_time : t -> Time.t
  val content : t -> Doc.t
  val author : t -> User.Id.t
  val is_visible : t -> bool
  val is_invisible : t -> bool

  val build_new :
    title:string ->
    short_title:string ->
    content:Doc.t ->
    author:User.Id.t ->
    is_visible:bool ->
    t

  val slug : t -> string

  module Private : sig
    val build :
      title:string ->
      short_title:string ->
      content:Doc.t ->
      pub_time:Time.t ->
      author:User.Id.t ->
      is_visible:bool ->
      t
  end
end

include Db_model.Data_with_id with type item := Item.t

(** {1 Utilities} *)

(** {2 Lifted} *)

val title : t -> string
val short_title : t -> string
val pub_time : t -> Time.t
val content : t -> Doc.t
val author : t -> User.Id.t
val is_visible : t -> bool
val is_invisible : t -> bool
val slug : t -> string
val content_as_md : t -> string
val content_as_html : t -> [> Html_types.div_content ] Html.elt list
val content_as_div : t -> [> Html_types.div ] Html.elt

(** {2 Misc} *)

val unique_slug : ?prefix:string -> t -> string
(** Guarantee to return different slugs when the ids are distinct *)

(** {2 Database-related functions} *)

val all : unit -> t list Lwt.t
val visible : unit -> t list Lwt.t
val find : Id.t -> t Lwt.t
val create_from_item : Item.t -> t Lwt.t

val create :
  title:string ->
  short_title:string ->
  content:Doc.t ->
  author:User.Id.t ->
  is_visible:bool ->
  t Lwt.t

val update_with_item : Id.t -> Item.t -> t Lwt.t

val update :
  Id.t ->
  ?title:string ->
  ?short_title:string ->
  ?pub_time:Time.t ->
  ?content:Doc.t ->
  ?author:User.Id.t ->
  ?is_visible:bool ->
  unit ->
  t Lwt.t

val find_and_delete : Id.t -> Item.t Lwt.t
val delete : Id.t -> unit Lwt.t
