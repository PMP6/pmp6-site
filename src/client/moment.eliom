[%%client.start]

open Js_of_ocaml
open Moment_intf

(* Parse *)

let moment = Js.Unsafe.global##.moment
let moment_fromString = moment
let moment_fromStringFormat = moment
let moment_fromStringFormatLocale = moment
let moment_fromStringFormatStrict = moment
let moment_fromStringFormatLocaleStrict = moment
let moment_fromTimeValue = moment
let moment_fromDate = moment
let unix = moment##.unix

(* Locale *)

let locale l = moment##locale l
