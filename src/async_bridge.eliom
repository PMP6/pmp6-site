let run f = Lwt_preemptive.detach (fun () -> Async.Thread_safe.run_in_async_wait_exn f) ()
let run_exn f = run f |> Lwt_result.map_error Error.to_exn |> Lwt_result.get_exn
