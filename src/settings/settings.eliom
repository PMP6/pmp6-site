module Smtp = struct
  type t = {
    host : string;
    port : int;
    username : string;
    password : string;
    use_starttls : bool;
  }
  [@@deriving sexp]
end

module Database = struct
  type t = { uri : string } [@@deriving sexp]
end

module Email = struct
  module Default = struct
    let default_from_display_name = "PMP6"
    let default_from_email = "noreply@pmp6.fr"

    let default_subject_prefix =
      (* Don't forget to add a trailing space if desired *)
      "[Site web PMP6] "

    let default_signature = Some "L'équipe du site web PMP6\nhttps://pmp6.fr"
  end

  type t = {
    default_from_display_name : string; [@default Default.default_from_display_name]
    default_from_email : string; [@default Default.default_from_email]
    default_subject_prefix : string; [@default Default.default_subject_prefix]
    default_signature : string option; [@default Default.default_signature]
  }
  [@@deriving sexp]

  let default = t_of_sexp Sexp.unit
end

type t = {
  smtp : Smtp.t;
  database : Database.t;
  email : Email.t; [@default Email.default]
}
[@@deriving sexp]

let get_settings_file () =
  (* Temporary implementation: find APPNAME.sexp in the same directory as the ocsigen
     config file *)
  let server_conf_file = Ocsigen_config.get_config_file () in
  let dirname = Filename.dirname server_conf_file in
  let basename = Pmp6.App.application_name ^ ".sexp" in
  Filename.concat dirname basename

let load_settings () = t_of_sexp @@ Sexp.load_sexp @@ get_settings_file ()
let ({ smtp; database; email } as foo) = load_settings ()
