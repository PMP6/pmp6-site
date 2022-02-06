module P = Eliom_parameter
module S = Eliom_service

module Timeout : sig
  (** Helpers for easier-to-read service timeouts *)

  type t = float

  val seconds : int -> t
  val minutes : int -> t
  val hours : int -> t

  val seconds_f : float -> t
  val minutes_f : float -> t
  val hours_f : float -> t

  val t : ?h:int -> ?m:int -> ?s:int -> unit -> t
  val t_f : ?h:float -> ?m:float -> ?s:float -> unit -> t

  val span : Time.Span.t -> t
end
