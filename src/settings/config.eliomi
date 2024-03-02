(** Local configuration utilities *)

exception Undefined of string
(** When a variable has no definition nor default value *)

module Env : sig
  val get_opt : string -> string option
  val get : undefined:string -> string -> string
  val get_or_empty : string -> string
  val require : string -> string
end
