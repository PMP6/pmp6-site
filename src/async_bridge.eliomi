val run : (unit -> 'a Async.Deferred.t) -> 'a Lwt.t
val run_exn : (unit -> ('a, Core_kernel.Error.t) result Async.Deferred.t) -> 'a Lwt.t
