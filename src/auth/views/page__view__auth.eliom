module Widget = Widget__view__auth

module H = Html

let connection () =
  Template_lib.page
    ~title:"Connexion"
    [Widget.login_form ()]

let forbidden () =
  Template_lib.page
    ~title:"Accès interdit"
    [H.txt "Vous n'avez pas les autorisations nécessaires pour accéder \
            à la page demandée."]

let already_connected () =
  Template_lib.page
    ~title:"Vous êtes déjà connecté"
    [
      H.div
        ~a:[H.a_class ["callout"; "warning"]]
        [H.txt "Vous êtes déjà connecté."]
    ]
