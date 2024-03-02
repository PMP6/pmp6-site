[%%client.start]

open Js_of_ocaml

class type moment = object
  method add : float -> Js.js_string Js.t -> unit Js.meth
  method subtract : float -> Js.js_string Js.t -> unit Js.meth
  method format : Js.js_string Js.t Js.meth
  method format_withFormat : Js.js_string Js.t -> Js.js_string Js.t Js.meth
  method fromNow : Js.js_string Js.t Js.meth
  method calendar : Js.js_string Js.t Js.meth
  method calendar_withReferenceTime : moment Js.t -> Js.js_string Js.t Js.meth

  method calendar_withFormats :
    moment Js.t -> calendarFormat Js.t -> Js.js_string Js.t Js.meth

  method isSame : moment Js.t -> bool Js.t Js.meth
  method isSame_withUnit : moment Js.t -> Js.js_string Js.t -> bool Js.t Js.meth
end

and calendarFormat = object
  method sameDay : moment Js.t -> Js.js_string Js.t Js.meth
  method nextDay : moment Js.t -> Js.js_string Js.t Js.meth
  method nextWeek : moment Js.t -> Js.js_string Js.t Js.meth
  method lastDay : moment Js.t -> Js.js_string Js.t Js.meth
  method lastWeek : moment Js.t -> Js.js_string Js.t Js.meth
  method sameElse : moment Js.t -> Js.js_string Js.t Js.meth
end
