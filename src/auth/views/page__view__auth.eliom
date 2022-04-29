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
      H.a
        ~service:Service.Settings.forgotten_password
        [H.txt "Mot de passe oublié ?"]
        ();
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

let forgotten_password () =
  Content.page
    ~title:"Mot de passe oublié"
    [
      H.h1 [H.txt "Mot de passe oublié"];
      H.p [
        H.txt "Vous pouvez utiliser ce formulaire pour réinitialiser \
               votre mot de passe, si par exemple vous l'avez \
               oublié. Saisissez l'adresse email attachée à votre \
               compte."
      ];
      H.p [
        H.txt "Une fois le formulaire envoyé, vous recevrez un email \
               contenant un lien pour valider votre demande."
      ];
      Widget.password_reset_form ();
    ]

let password_token_requested () =
  Content.page
    ~title:"Mot de passe oublié"
    [
      H.h1 [H.txt "Mot de passe oublié"];
      F.Callout.primary
        [
          H.p [
            H.txt "Un email a été envoyé à l'adresse indiqué. Il \
                   contient de plus amples instructions pour \
                   réinitialiser votre mot de passe. Si vous ne l'avez \
                   pas reçu, vérifiez vos spams et contactez le cas \
                   échéant un administrateur du site."
          ]
        ]
    ]

let password_reset token =
  Content.page
    ~title:"Réinitialisation du mot de passe"
    [
      H.h1 [H.txt "Réinitialisation du mot de passe"];
      Widget.password_change_form token;
    ]

let failed_password_reset () =
  Content.page
    ~title:"Échec de la réinitialisation"
    [
      H.h1 [H.txt "Réinitialisation du mot de passe"];
      F.Callout.alert
        [
          H.txt "Votre tentative de réinitialisation de votre mot de \
                 passe a échoué. Le lien que vous avez suivi était \
                 invalide ou a expiré. Nous vous invitons à ";
          H.a
            ~service:Service.Settings.forgotten_password
            [H.txt "soumettre une nouvelle demande"]
            ();
          H.txt " en vous assurant de confirmer votre requête dans le \
                 délai imparti.";
        ]
    ]

let successful_password_reset () =
  Content.page
    ~title:"Mot de passe réinitialisé"
    [
      H.h1 [H.txt "Réinitialisation du mot de passe"];
      F.Callout.success
        [
          H.txt "Votre mot de passe a bien été modifié. Vous allez \
                 recevoir un email de confirmation. Vous pouvez dès \
                 maintenant continuer à naviguer sur le site.";
        ]
    ]

let admin_main all_users =
  Content.page
    ~title:"Utilisateurs & permissions"
    [
      H.h1 [H.txt "Utilisateurs"];
      Widget.button_to_creation ();
      Widget.all_users_table all_users;
    ]

let user_creation () =
  Content.page
    ~title:"Nouvel utilisateur"
    [
      H.h1 [H.txt "Nouvel utilisateur"];
      Widget.user_admin_form ();
    ]

let user_edition user =
  Content.page
    ~title:"Modifier un utilisateur"
    [
      H.h1 [H.txt "Modifier un utilisateur"];
      Widget.user_admin_form ~user ();
    ]
