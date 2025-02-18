exception Undefined of string

module Env = struct
  let get var = Sys.getenv var
  let get_value ~default var = Option.value ~default (get var)
  let get_or_empty_string var = get_value ~default:"" var

  let require var =
    match get var with None -> raise (Undefined var) | Some value -> value

  let require_bool var =
    bool_of_string (require var)
end
