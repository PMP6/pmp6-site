module P = Eliom_parameter
module S = Eliom_service

let ( ** ) = P.( ** )

module Subpath = struct
  type t = string

  let param = P.string

  let get_service path =
    let path = Eliom_lib.Url.split_path path in
    Eliom_service.create
      ~path:(Eliom_service.Path path)
      ~meth:(Eliom_service.Get Eliom_parameter.unit)
      ()

  let current () =
    Option.try_with Eliom_request_info.get_current_sub_path
    |> Option.map ~f:(Eliom_lib.Url.string_of_url_path ~encode:false)
end

module Timeout = struct
  type t = float

  let seconds_f s = s
  let seconds s = seconds_f (float s)
  let minutes_f m = seconds_f (m *. 60.)
  let minutes m = minutes_f (float m)
  let hours_f h = minutes_f (h *. 60.)
  let hours h = hours_f (float h)
  let t_f ?(h = 0.) ?(m = 0.) ?(s = 0.) () = hours_f h +. minutes_f m +. seconds_f s
  let t ?(h = 0) ?(m = 0) ?(s = 0) () = t_f ~h:(float h) ~m:(float m) ~s:(float s) ()
  let span s = seconds_f (Time_ns.Span.to_sec s)
end
