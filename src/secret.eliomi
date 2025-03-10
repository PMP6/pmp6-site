module Hash : sig
  type t

  val db_type : t Caqti_type.t

  val encode : string -> t
  (** Raises if the encoding fails *)

  val verify : t -> string -> bool
  (** Raises if the verification fails due to an internal error *)
end

module Token : sig
  type t

  val create : unit -> t
  val hash : t -> Hash.t
  val verify : Hash.t -> t -> bool

  val param :
    string ->
    ( t,
      [ `WithoutSuffix ],
      [ `One of t ] Eliom_parameter.param_name )
    Eliom_parameter.params_type
end
