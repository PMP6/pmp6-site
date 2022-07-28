type service =
  (unit, unit, Eliom_service.get, Eliom_service.att, Eliom_service.non_co,
   Eliom_service.non_ext, Eliom_service.reg, [ `WithoutSuffix ], unit,
   unit, Eliom_service.non_ocaml)
    Eliom_service.t

type t = {
  name : string;
  service : service;
  is_visible : unit -> bool Lwt.t;
}

let name { name; _ } = name

let service { service; _ } = service

let modules : t list Eliom_reference.eref =
  Eliom_reference.eref ~scope:Eliom_common.global_scope []

let all () =
  Eliom_reference.get modules

let all_visible () =
  let%lwt all_modules = all () in
  Lwt_list.filter_s (fun m -> m.is_visible ()) all_modules

let attach ?(is_visible = fun () -> Lwt.return true) name service =
  Eliom_reference.modify
    modules
    (fun modules -> { name; service; is_visible } :: modules)

module Private = struct
  let all = all
end
