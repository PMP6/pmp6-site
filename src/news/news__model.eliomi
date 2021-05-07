module Item : sig
  include Db_utils.Data

  val title : t -> string
  val short_title : t -> string
  val pub_time : t -> Time.t
  val content : t -> Html_types.div_content_fun Html.elt

  val build :
    title:string ->
    short_title:string ->
    content:Html_types.div_content_fun Html.elt ->
    pub_time:Time.t ->
    t


  val build_now :
    title:string ->
    short_title:string ->
    content:Html_types.div_content_fun Html.elt ->
    t

  val slug : t -> string
  val content_as_string : t -> string
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

val get_all : unit -> t list Db.request_result
val get_all_exn : unit -> t list Lwt.t

val get_all_items : unit -> Item.t list Db.request_result
val get_all_items_exn : unit -> Item.t list Lwt.t

val get_one : Id.t -> t Db.request_result
val get_one_exn : Id.t -> t Lwt.t

val create_with_item : Item.t -> unit Db.request_result
val create_with_item_exn : Item.t -> unit Lwt.t

val create_now :
  title:string ->
  short_title:string ->
  content:Html_types.div_content_fun Html.elt ->
  unit Db.request_result

val create_now_exn :
  title:string ->
  short_title:string ->
  content:Html_types.div_content_fun Html.elt ->
  unit Lwt.t

val create_now_and_return :
  title:string ->
  short_title:string ->
  content:Html_types.div_content_fun Html.elt ->
  t Db.request_result

val create_now_and_return_exn :
  title:string ->
  short_title:string ->
  content:Html_types.div_content_fun Html.elt ->
  t Lwt.t

val update_with_item_and_return : Id.t -> Item.t -> t Db.request_result
val update_with_item_and_return_exn : Id.t -> Item.t -> t Lwt.t

val update_now_and_return :
  Id.t ->
  title:string ->
  short_title:string ->
  content:Html_types.div_content_fun Html.elt ->
  t Db.request_result

val update_now_and_return_exn :
  Id.t ->
  title:string ->
  short_title:string ->
  content:Html_types.div_content_fun Html.elt ->
  t Lwt.t

val delete : Id.t -> unit Db.request_result
val delete_exn : Id.t -> unit Lwt.t

val delete_and_return : Id.t -> Item.t Db.request_result
val delete_and_return_exn : Id.t -> Item.t Lwt.t
