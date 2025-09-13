module Smtp : sig
  type t = {
    host : string;
    port : int;
    username : string;
    password : string;
    use_starttls : bool;
  }
end

module Database : sig
  type t = { uri : string }
end

module Email : sig
  type t = {
    default_from_display_name : string;
    default_from_email : string;
    default_subject_prefix : string;
    default_signature : string option;
  }
end

val smtp : Smtp.t
val database : Database.t
val email : Email.t
