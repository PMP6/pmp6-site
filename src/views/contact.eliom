module H = Html

let contact_page () () =
  Content.page ~title:"Contact" H.[
    h1 [txt "Contact"];
    p [
      txt "Vous voulez vous inscrire, avez des questions sur nos \
           activités ou souhaitez des renseignements supplémentaires \
           sur notre club ? N'hésitez pas à joindre nos délégués par \
           mail :";
    ];
    p ~a:[a_class ["text-center"]] [
      mailto_a
        "delegues@pmp6.fr"
        [
          Icon.solid "envelope" ();
          txt " delegues@pmp6.fr";
        ]
    ];
    p [
      txt "Vous pouvez également nous contacter directement sur notre \
           page Facebook ou via Messenger :";
    ];
    p ~a:[a_class ["text-center"]] [
      a
        ~service:(Facebook.page_service ())
        ~a:[a_target "_blank"] [
        Icon.brands "facebook-square" ();
        txt " as.pmp6";
      ] ();
      br ();
      a
        ~service:(Facebook.messenger_service ())
        ~a:[a_target "_blank"] [
        Icon.brands "facebook-messenger" ();
        txt " as.pmp6";
      ] ();
    ]
  ]
