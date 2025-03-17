module App = Eliom_registration.App (struct
  let application_name = "pmp6"
  let global_data_path = Some [ "__global_data__" ]
end)
