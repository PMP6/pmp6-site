module type Standard_model = sig
  type t

  module Id : sig
    type t
  end

  val all : unit -> t list Lwt.t
  val id : t -> Id.t
  val delete : Id.t -> unit Lwt.t
end

let delete_all (module Model : Standard_model) =
  let%lwt all = Model.all () in
  let delete x = Model.(delete @@ id x) in
  Lwt_list.iter_s delete all

let print x = print_endline ("hello" ^ x)
