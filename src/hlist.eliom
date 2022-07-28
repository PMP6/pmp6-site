module%shared Make (M : sig type 'a t end) = struct
  type _ t =
    | [] : unit t
    | ( :: ) : 'a M.t * 'b t -> ('a -> 'b) t
end

include%shared Make (struct type 'a t = 'a end)
