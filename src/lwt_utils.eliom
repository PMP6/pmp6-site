(* Interval in seconds *)
let rec every interval f : never_returns Lwt.t =
  let%lwt () = f () in
  let%lwt () = Lwt_unix.sleep (Time.Span.to_sec interval) in
  every interval f
