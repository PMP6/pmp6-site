module Model = Model__auth
module Service = Service__auth

module H = Html
module F = Foundation

let connection_icon () =
  let icon = Icon.solid ~a:[H.a_class ["icon"; "action"; "show-for-large"]] "user" () in
  H.a
    ~service:(Service.connection)
    [icon; H.span ~a:[H.a_class ["hide-for-large"]] [H.txt "Connexion"]]
    (Option.try_with Eliom_request_info.get_current_sub_path)

let logout_button () =
  H.post_pseudo_link
    ~service:Service.logout
    [H.txt "Déconnexion"]
    ()

let user_menu_icon () =
    Icon.solid ~a:[H.a_class ["icon"; "action"]] "user-cog" ()

let user_menu () =
  H.li
    ~a:[H.a_class ["is-dropdown-submenu-parent"]]
    [
      H.Raw.a [user_menu_icon ()];
      H.ul
        ~a:[H.a_class ["menu"]]
        [
          H.li [H.a ~service:Service.Settings.email_edition [H.txt "Paramètres"] ()];
          H.li [logout_button ()];
        ]
    ]

let login_form ~next () =
  let open H in
  let span_form_error text =
    H.span ~a:[H.a_class ["form-error"]] [H.txt text]
  in
  let make_form (username, password) =
    [
      label [
        txt "Nom d'utilisateur";
        Form.input
          ~input_type:`Text
          ~name:username
          ~a:[F.Abide.required ()]
          Form.string;
        span_form_error "Vous devez renseigner votre nom d'utilisateur.";
      ];

      label [
        txt "Mot de passe";
        Form.input
          ~input_type:`Password
          ~name:password
          ~a:[F.Abide.required ()]
          Form.string;
        span_form_error "Vous devez renseigner votre mot de passe.";
      ];

      Form.button_no_value
        ~button_type:`Submit
        ~a:[a_class ["button"; "small-only-expanded"]]
        [txt "Se connecter"];
    ] in
  F.Abide.post_form ~service:Service.login make_form next

let email_edition_form user =
  let open H in
  let span_form_error text =
    H.span ~a:[H.a_class ["form-error"]] [H.txt text]
  in
  let make_form new_email =
    [
      label [
        txt "Mon adresse email";
        Form.input
          ~input_type:`Email
          ~name:new_email
          ~value:(Model.User.email user)
          ~a:[F.Abide.required ()]
          Form.string;
        span_form_error "Vous devez entrer une adresse email valide.";
      ];

      Form.button_no_value
        ~button_type:`Submit
        ~a:[a_class ["button"; "small-only-expanded"]]
        [txt "Enregistrer"];
    ] in
  F.Abide.post_form ~service:Service.Settings.save_email make_form ()

let password_reset_form () =
  let open H in
  let span_form_error text =
    H.span ~a:[H.a_class ["form-error"]] [H.txt text]
  in
  let make_form new_email =
    [
      label [
        txt "Votre adresse email";
        Form.input
          ~input_type:`Email
          ~name:new_email
          ~a:[F.Abide.required ()]
          Form.string;
        span_form_error "Vous devez entrer une adresse email valide.";
      ];

      Form.button_no_value
        ~button_type:`Submit
        ~a:[a_class ["button"; "small-only-expanded"]]
        [txt "Envoyer"];
    ] in
  F.Abide.post_form
    ~service:Service.Settings.request_password_token
    make_form
    ()

let password_change_form token =
  let open H in
  let pwd_input_id = new_id () in
  let make_form new_password =
    [
      label [
        txt "Votre nouveau mot de passe";
        Form.input
          ~input_type:`Password
          ~name:new_password
          ~a:[F.Abide.required (); a_id pwd_input_id]
          Form.string;
        F.Abide.form_error "Vous devez entrer un mot de passe.";
      ];

      label [
        txt "Confirmez votre mot de passe";
        Form.input
          ~input_type:`Password
          ~a:[F.Abide.required (); F.Abide.equalto ~id:pwd_input_id]
          Form.string;
        F.Abide.form_error "Les deux mots de passe doivent être identiques !";
      ];

      Form.button_no_value
        ~button_type:`Submit
        ~a:[a_class ["button"; "small-only-expanded"]]
        [txt "Enregistrer"];
    ] in
  F.Abide.post_form
    ~service:Service.Settings.validate_password_reset
    make_form
    token

let user_admin_form ?user () =
  (* If user is passed, edition form. Otherwise, creation. *)
  let open H in
  let help_text text =
    H.p ~a:[H.a_class ["help-text"]] [H.txt text]
  in
  let is_creation = Option.is_none user in
  let prefilled_with f =
    Option.value_map ~default:"" ~f user in
  let prechecked_with f =
    Option.value_map ~default:false ~f user in
  let form (username, (email, (password, (is_superuser, (is_staff))))) =
    [
      F.Abide.abide_error [ H.txt "Le formulaire contient des erreurs." ];

      label [
        txt "Nom d'utilisateur";
        Form.input
          ~input_type:`Text
          ~name:username
          ~a:[F.Abide.required ()]
          ~value:(prefilled_with Model.User.username)
          Form.string;
        F.Abide.form_error "Vous devez renseigner un nom d'utilisateur.";
      ];

      label [
        txt "Adresse email";
        Form.input
          ~input_type:`Email
          ~name:email
          ~a:[F.Abide.required ()]
          ~value:(prefilled_with Model.User.email)
          Form.string;
        F.Abide.form_error "Vous devez renseigner une adresse email.";
      ];

      label [
        txt "Mot de passe";
        Form.input
          ~a:(if is_creation then [ F.Abide.required () ] else [])
          ~input_type:`Password
          ~name:password
          Form.string;
        F.Abide.form_error "Vous devez renseigner un mot de passe.";
      ];
    ]
    @ (if is_creation
       then []
       else [ help_text "Laissez vide pour ne pas changer le mot de passe." ])
    @
    [
      fieldset ~legend:(legend [txt "Permissions"]) (
        [
          label [
            Form.bool_checkbox_one
              ~checked:(prechecked_with Model.User.is_superuser)
              ~name:is_superuser
              ();

            txt "Super-utilisateur";
          ];
          help_text "Confère automatiquement toutes les permissions.";

          label [
            Form.bool_checkbox_one
              ~checked:(prechecked_with Model.User.is_staff)
              ~name:is_staff
              ();

            txt "Membre de l'équipe";
          ];
          help_text "Donne accès à la plupart des fonctionnalités du site.";

        ]
      );

      Form.button_no_value
        ~button_type:`Submit
        ~a:[a_class ["button"; "small-only-expanded"]]
        [txt "Valider"];
    ]
  in
  match user with
  | Some user ->
    F.Abide.post_form ~service:Service.Admin.update_user form (Model.User.id user)
  | None ->
    F.Abide.post_form ~service:Service.Admin.create_user form ()
