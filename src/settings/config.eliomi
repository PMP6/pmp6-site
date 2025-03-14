(** Local configuration utilities *)

exception Undefined of string
(** When a variable has no definition nor default value *)

module Env : sig
  val get : string -> string option
  val get_value : default:string -> string -> string
  val get_or_empty_string : string -> string
  val require : string -> string
  val require_bool : string -> bool
  val require_int : string -> int
end
