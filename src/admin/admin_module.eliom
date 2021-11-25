type service =
  (unit, unit, Eliom_service.get, Eliom_service.att, Eliom_service.non_co,
   Eliom_service.non_ext, Eliom_service.reg, [ `WithoutSuffix ], unit,
   unit, Eliom_service.non_ocaml)
    Eliom_service.t

let modules : (string * service) list Eliom_reference.eref =
  Eliom_reference.eref ~scope:Eliom_common.global_scope []

let all () =
  Eliom_reference.get modules

let register name service =
  Eliom_reference.modify modules (fun modules -> (name, service) :: modules)
