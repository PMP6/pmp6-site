[%%client.start]

open Js_of_ocaml
open Moment_intf

(* Parse (constructors) *)

val moment : moment Js.t Js.constr
val moment_fromString : (Js.js_string Js.t -> moment Js.t) Js.constr

val moment_fromStringFormat :
  (Js.js_string Js.t -> Js.js_string Js.t -> moment Js.t) Js.constr

val moment_fromStringFormatLocale :
  (Js.js_string Js.t -> Js.js_string Js.t -> Js.js_string Js.t -> moment Js.t) Js.constr

val moment_fromStringFormatStrict :
  (Js.js_string Js.t -> Js.js_string Js.t -> bool Js.t -> moment Js.t) Js.constr

val moment_fromStringFormatLocaleStrict :
  (Js.js_string Js.t ->
  Js.js_string Js.t ->
  bool Js.t ->
  Js.js_string Js.t ->
  moment Js.t)
  Js.constr

val moment_fromTimeValue : (float -> moment Js.t) Js.constr
val moment_fromDate : (Js.date_constr Js.t -> moment Js.t) Js.constr
val unix : (float -> moment Js.t) Js.constr

(* Locale *)

val locale : Js.js_string Js.t -> Js.js_string Js.t
