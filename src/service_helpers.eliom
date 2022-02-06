module P = Eliom_parameter
module S = Eliom_service

module Timeout = struct

  type t = float

  let seconds_f s = s
  let seconds s = seconds_f (float s)

  let minutes_f m = seconds_f (m *. 60.)
  let minutes m = minutes_f (float m)

  let hours_f h = minutes_f (h *. 60.)
  let hours h = hours_f (float h)

  let t_f ?(h=0.) ?(m=0.) ?(s=0.) () = hours_f h +. minutes_f m +. seconds_f s
  let t ?(h=0) ?(m=0) ?(s=0) () = t_f ~h:(float h) ~m:(float m) ~s:(float s) ()

  let span s = seconds_f (Time.Span.to_sec s)

end
