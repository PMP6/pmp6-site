exception Undefined of string

module Env = struct
  let get_opt var = Sys.getenv_opt var

  let get ~undefined var =
    match get_opt var with None -> undefined | Some value -> value

  let get_or_empty var = get ~undefined:"" var

  let require var =
    match get_opt var with None -> raise (Undefined var) | Some value -> value
end
