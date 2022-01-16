module Model = Model__auth
module Service = Service__auth

module H = Html

let connection_icon () =
  let icon = Icon.solid ~a:[H.a_class ["icon"; "action"; "show-for-large"]] "fa-user" () in
  H.a
    ~service:(Service.connection)
    [icon; H.span ~a:[H.a_class ["hide-for-large"]] [H.txt "Connexion"]]
    (Option.try_with Eliom_request_info.get_current_sub_path)

let logout_button () =
  H.Form.post_form
    ~service:Service.logout
    (fun () ->
       [H.Form.button_no_value
          ~a:[H.a_class ["action-button"]]
          ~button_type:`Submit
          [H.txt "Déconnexion"]
       ])
    ()

let user_menu_icon () =
    Icon.solid ~a:[H.a_class ["icon"; "action"]] "fa-user-cog" ()

let user_menu () =
  H.li
    ~a:[H.a_class ["is-dropdown-submenu-parent"]]
    [
      H.Raw.a [user_menu_icon ()];
      H.ul
        ~a:[H.a_class ["menu"]]
        [
          H.li [H.a ~service:Service.Settings.email_edition [H.txt "Paramètres"] ()];
          H.li ~a:[H.a_class ["menu-text"]] [logout_button ()];
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
          ~a:[a_required ()]
          Form.string;
        span_form_error "Vous devez renseigner votre nom d'utilisateur.";
      ];

      label [
        txt "Mot de passe";
        Form.input
          ~input_type:`Password
          ~name:password
          ~a:[a_required ()]
          Form.string;
        span_form_error "Vous devez renseigner votre mot de passe.";
      ];

      Form.button_no_value
        ~button_type:`Submit
        ~a:[a_class ["button"; "small-only-expanded"]]
        [txt "Se connecter"];
    ] in
  Form.post_form
    ~service:Service.login
    ~xhr:false (* Mandatory to go through Abide form validation *)
    ~a:[
      a_user_data "abide" "";
      a_novalidate ();
    ]
    make_form
    next

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
          ~input_type:`Text
          ~name:new_email
          ~value:(Model.User.email user)
          ~a:[a_required (); a_pattern "email"]
          Form.string;
        span_form_error "Vous devez entrer une adresse email valide.";
      ];

      Form.button_no_value
        ~button_type:`Submit
        ~a:[a_class ["button"; "small-only-expanded"]]
        [txt "Enregistrer"];
    ] in
  Form.post_form
    ~service:Service.Settings.save_email
    ~xhr:false (* Mandatory to go through Abide form validation *)
    ~a:[
      a_user_data "abide" "";
      a_novalidate ();
    ]
    make_form
    ()
