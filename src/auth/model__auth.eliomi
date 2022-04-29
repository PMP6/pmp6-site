module User : sig
  module Item : sig
    include Db_model.Data

    val username : t -> string
    val email : t -> string
    val password : t -> Secret.Hash.t
    val is_superuser : t -> bool
    val is_staff : t -> bool
    val joined_time : t -> Time.t

    val build_new :
      username:string ->
      email:string ->
      password:string ->
      is_superuser:bool ->
      is_staff:bool ->
      t

    val verify_password : t -> string -> bool
  end

  include Db_model.Data_with_id with type item := Item.t

  val id : t -> Id.t
  val item : t -> Item.t
  val username : t -> string
  val email : t -> string
  val password : t -> Secret.Hash.t
  val is_superuser : t -> bool
  val is_staff : t -> bool
  val joined_time : t -> Time.t

  val verify_password : t -> string -> bool

  val all : unit -> t list Lwt.t

  val find : Id.t -> t Lwt.t

  val find_by_username : string -> t option Lwt.t

  val find_by_email : string -> t option Lwt.t

  (** Will raise on conflict *)
  val create_from_item_exn : Item.t -> t Lwt.t

  val create :
    username:string ->
    email:string ->
    password:string ->
    is_superuser:bool ->
    is_staff:bool ->
    (t, [> `Email_already_exists | `Username_already_exists ] list) result Lwt.t

  val find_and_delete : Id.t -> Item.t Lwt.t

  val delete : Id.t -> unit Lwt.t

  val email_exists : string -> bool Lwt.t

  val update_email :
    Id.t -> string -> (unit, [> `Email_already_exists ]) result Lwt.t

  val update_password :
    Id.t -> string -> unit Lwt.t

  val update :
    Id.t ->
    ?username:string ->
    ?email:string ->
    ?password:string ->
    ?is_superuser:bool ->
    ?is_staff:bool ->
    unit ->
    (t, [> `Email_already_exists | `Username_already_exists ] list) result Lwt.t

end

module Password_token : sig

  val create : User.Id.t -> Secret.Token.t Lwt.t

  val validate_password_reset :
    Secret.Token.t ->
    password:string ->
    (User.Id.t, [> `Token_absent_or_expired | `Unexpected ]) result Lwt.t

end
