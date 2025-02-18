module P = Eliom_parameter
module S = Eliom_service

val ( ** ) :
  ('a, [ `WithoutSuffix ], 'b) P.params_type ->
  ('c, ([< `Endsuffix | `WithoutSuffix ] as 'd), 'e) P.params_type ->
  ('a * 'c, 'd, 'b * 'e) P.params_type
(** An alias of [P.( ** )] *)

module Subpath : sig
  type t

  val param :
    string -> (t, [ `WithoutSuffix ], [ `One of string ] P.param_name) P.params_type

  val get_service :
    t ->
    ( unit,
      unit,
      S.get,
      S.att,
      S.non_co,
      S.non_ext,
      S.reg,
      [ `WithoutSuffix ],
      unit,
      unit,
      S.non_ocaml )
    S.t

  val current : unit -> t option
end

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
  val span : Time_ns.Span.t -> t
end
