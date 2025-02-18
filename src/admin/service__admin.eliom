let path = Skeleton.admin_path

let main =
  Eliom_service.create ~path:(path []) ~meth:(Eliom_service.Get Eliom_parameter.unit) ()
