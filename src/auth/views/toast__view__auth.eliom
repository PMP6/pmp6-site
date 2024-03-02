module Model = Model__auth
module H = Html

let login_required () =
  Toast.warning_msg "Vous devez être connecté pour accéder à la page demandée."

let non_existent_user () = Toast.alert_msg "Ce nom d'utilisateur n'existe pas."

let non_existent_email () =
  Toast.alert_msg "Cette adresse email ne correspond à aucun utilisateur."

let incorrect_password () = Toast.alert_msg "Mot de passe incorrect."
let login_success () = Toast.success_msg "Vous êtes maintenant connecté."

let email_is_the_same () =
  Toast.secondary_msg "Cette adresse est identique à la précédente."

let email_not_available () = Toast.alert_msg "Cette adresse email est indisponible."
let username_not_available () = Toast.alert_msg "Ce nom d'utilisateur est indisponible."

let conflict = function
  | `Email_already_exists -> email_not_available ()
  | `Username_already_exists -> username_not_available ()

let email_successfully_changed () =
  Toast.success_msg
    "Votre adresse a bien été modifiée. Vous allez recevoir un email de confirmation. \
     Dans le cas contraire, contactez l'administrateur."

let password_successfully_changed () =
  Toast.success_msg "Votre mot de passe a bien été modifié."

let user_created user =
  Toast.success
    [
      H.txt "L'utilisateur ";
      H.em [ H.txt @@ Model.User.username user ];
      H.txt " a bien été créé.";
    ]

let user_updated user =
  Toast.success
    [
      H.txt "L'utilisateur ";
      H.em [ H.txt @@ Model.User.username user ];
      H.txt " a bien été mis à jour.";
    ]

let user_deleted user =
  Toast.success
    [
      H.txt "L'utilisateur ";
      H.em [ H.txt @@ Model.User.Item.username user ];
      H.txt " a bien été supprimé.";
    ]
