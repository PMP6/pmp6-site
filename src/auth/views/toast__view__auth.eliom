module Model = Model__auth

module H = Html

let login_required () =
  Toast.simple_message "Vous devez être connecté pour accéder à la page demandée."

let non_existent_user () =
  Toast.simple_message "Ce nom d'utilisateur n'existe pas."

let incorrect_password () =
  Toast.simple_message "Mot de passe incorrect."

let login_success () =
  Toast.simple_message "Vous êtes maintenant connecté."

let already_connected () =
  Toast.simple_message "Vous êtes déjà connecté."
