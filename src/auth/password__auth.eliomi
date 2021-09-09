type encoded

val db_type : encoded Caqti_type.t

(** Raises if the encoding fails *)
val encode : string -> encoded

(** Raises if the verification fails due to an internal error *)
val verify : encoded -> string -> bool
