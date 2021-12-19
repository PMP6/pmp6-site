module Service = Service__auth

module H = Html

let connection_icon () =
  let icon = Icon.solid ~a:[H.a_class ["icon"; "show-for-large"]] "fa-user" () in
  H.a
    ~service:(Service.connection)
    [icon; H.span ~a:[H.a_class ["hide-for-large"]] [H.txt "Connexion"]]
    (Option.try_with Eliom_request_info.get_current_sub_path)

let logout_icon () =
  let icon =
    Icon.solid ~a:[H.a_class ["icon"; "logout"; "show-for-large"]] "fa-user-times" () in
  H.Form.post_form
    ~service:Service.logout
    (fun () ->
       [H.Form.button_no_value
          ~button_type:`Submit
          [icon; H.span ~a:[H.a_class ["hide-for-large"]] [H.txt "Déconnexion"]]
       ])
    ()

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
