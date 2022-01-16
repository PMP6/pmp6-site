module Widget = Widget__view__auth

module H = Html

let connection ~next () =
  Content.page
    ~title:"Connexion"
    [Widget.login_form ~next ()]

let forbidden () =
  Content.page
    ~title:"Accès interdit"
    [
      H.div
        ~a:[H.a_class ["callout"; "alert"]]
        [H.txt "Vous n'avez pas les autorisations nécessaires pour accéder \
                à la page demandée."]
    ]

let already_connected () =
  Content.page
    ~title:"Vous êtes déjà connecté"
    [
      H.div
        ~a:[H.a_class ["callout"; "warning"]]
        [H.txt "Vous êtes déjà connecté."]
    ]

let email_edition user =
  Content.page
    ~title:"Modifier mon adresse email"
    [Widget.email_edition_form user]
