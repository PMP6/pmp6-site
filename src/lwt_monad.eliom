include Monad.Make (struct

    include Lwt

    let bind x ~f = Lwt.bind x f

    let map x ~f = Lwt.map f x

    let map = `Custom map

end)
