module Smtp : sig
  val host : string
  val port : int
  val username : string
  val password : string
  val use_starttls : bool
end

module Database : sig
  val uri : string
end

module Email : sig
  val default_from_display_name : string
  val default_from_email : string
  val default_subject_prefix : string
  val default_signature : string option
end
