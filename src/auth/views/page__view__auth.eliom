module Service = Service__auth
module Widget = Widget__view__auth

module F = Foundation
module H = Html

let connection ~next () =
  Content.page
    ~title:"Connexion"
    [
      H.h1 [H.txt "Connexion"];
      Widget.login_form ~next ();
    ]

let forbidden () =
  Content.page
    ~title:"Accès interdit"
    [
      H.h1 [H.txt "Accès interdit"];
      F.Callout.alert [
        H.txt "Vous n'avez pas les autorisations nécessaires pour \
               accéder à la page demandée."
      ]
    ]

let already_connected () =
  Content.page
    ~title:"Vous êtes déjà connecté"
    [ F.Callout.warning [ H.txt "Vous êtes déjà connecté." ] ]

let email_edition user =
  Content.page
    ~title:"Modifier mon adresse email"
    [
      H.h1 [H.txt "Modifier mon adresse email"];
      Widget.email_edition_form user
    ]
