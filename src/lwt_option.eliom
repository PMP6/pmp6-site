type 'a t = 'a option Lwt.t

include Monad.Make (struct
  type nonrec 'a t = 'a t

  let return x = Lwt.return (Some x)
  let bind x ~f = match%lwt x with None -> Lwt.return None | Some x -> f x
  let map x ~f = Lwt.map (Option.map ~f) x
  let map = `Custom map
end)

let bind_lwt x ~f =
  match%lwt x with None -> Lwt.return None | Some x -> Lwt.map Option.some (f x)

let get_or_404 x =
  match%lwt x with None -> Lwt.fail Eliom_common.Eliom_404 | Some x -> Lwt.return x

let get_exn x = Lwt.map (fun opt -> Option.value_exn opt) x
