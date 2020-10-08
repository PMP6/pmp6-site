module%shared H = Html

open%client Js_of_ocaml
open%client Js_of_ocaml_lwt

let presentation_section () =
  let open H in
  let poulpe () =
    img
      ~src:(Skeleton.Static.img_uri ["pmp6-poulpe.png"])
      ~alt:"Le poulpe, notre mascotte"
      () in
  section ~a:[a_id "presentation"] [
    h1 [poulpe (); txt " Bienvenue à PMP6 ! "; poulpe ()];
    hr ();
    p [
      txt "Club de plongée associatif de Sorbonne Université, nous \
           sommes ouverts à tous les étudiants et personnels de \
           l'université ainsi qu'aux anciens inscrits.";
    ];
    p [
      txt "Encadrés par une vingtaine de moniteurs bénévoles, nous \
           proposons des formations à tous les niveaux de plongeur \
           ainsi qu'un accompagnement pour ceux qui désirent se \
           préparer aux niveaux d'encadrement."
    ];
    p [
      txt "Notre entraînement hebdomadaire se déroule à la piscine \
           Jean Taris, dans le V"; sup [txt "ème"];
      txt ". Nous proposons également des séances régulières en fosse \
           pour travailler la technique jusqu'à 20m de \
           profondeur. Enfin, nous organisons des stages en milieu \
           naturel pour valider les niveaux... et pour le plaisir de \
           plonger !"
    ];
    p [
      txt "N'hésitez pas à parcourir les différentes sections de ce \
           site pour plus d'informations. Si vous avez des questions, \
           vous pouvez aussi contacter nos délégués à l'adresse ";
      email "delegues@pmp6.fr" ();
      txt ".";
    ];
    Template.thumbnail_row
      ~max_size:4
      ~subdir:[]
      ["Un mola-mola à Banyuls", "mola-mola.jpg"];
  ]

let actu_slug actu_number actu =
  Printf.sprintf "actu-%d-%s" actu_number (Utils.slugify actu.Actu.title)

let actu_tab_title ~is_active ~slug actu =
  let open H in
  li ~a:[a_class ("tabs-title" :: Utils.is_active_class is_active)] [
    anchor_a ~anchor:slug ~a:[a_user_data "tabs-target" slug]
      [txt actu.Actu.short_title]
  ]

let ceil_minute time =
  Time.prev_multiple
    ~before:time
    ~base:Time.epoch
    ~interval:Time.Span.minute
    ~can_equal_before:true (* For good measure, only useful is s=ms=ns=0 *)
    ()

let ms time =
  (* Returns the number of seconds since epoch, as an int. *)
  time
  |> Time.to_span_since_epoch
  |> Time.Span.to_ms

let%client format_moment m =
  let open Moment in
  let today = new%js moment in
  let yesterday = new%js moment in yesterday##subtract 1. (Js.string "days");
  let isSameDay m1 m2 = Js.to_bool (m1##isSame_withUnit m2 (Js.string "day")) in
  if isSameDay m today
  then m##fromNow |> Js.to_string |> String.capitalize_ascii |> Js.string
  else if isSameDay m yesterday
  then m##format_withFormat (Js.string "[Hier à] H[h]mm")
  else m##format_withFormat (Js.string "[Le] Do MMMM Y à H[h]mm")

let actu_header (actu : Actu.t) =
  let open H in
  (* Title and pub-time must belong to the same hn class to be
     vertically aligned *)
  let datetime =
    Time.to_string_abs_trimmed
      ~zone:(Time.Zone.of_utc_offset ~hours:2)
      (ceil_minute actu.datetime) in
  let time_node = time ~a:[
    a_class ["pub-time"];
    a_datetime datetime;
  ] [txt datetime] in
  (* JS to show the time in client timezone. *)
  let time_value =
    ms actu.datetime in
  let _ = [%client (
    let%lwt () = Lwt_js_events.domContentLoaded () in
    let _ = Moment.locale (Js.string "fr") in
    let moment = new%js Moment.moment_fromTimeValue ~%time_value in
    let timenode = Eliom_content.Html.To_dom.of_time ~%time_node in
    timenode##.textContent := Js.some (format_moment moment);
    Lwt.return ()
    : unit Lwt.t
  )] in
  header ~a:[a_class ["grid-x"; "align-bottom"]] [
    h3 ~a:[a_class ["h4"; "cell"; "auto"]] [txt actu.title];
    div_classes ["h4"; "subheader"; "cell"; "shrink"] [
      time_node
    ]
  ]

let actu_tabs_panel ~is_active ~slug actu =
  let open H in
  div_classes ("tabs-panel" :: Utils.is_active_class is_active) ~a:[a_id slug] [
    article (
      actu_header actu ::
      actu.content
    )
  ]

let actu_elts make_elt actus =
  List.mapi
    ~f:(
      fun i actu ->
        make_elt ~is_active:(i = 0) ~slug:(actu_slug i actu) actu
    )
    actus

let actu_tabs actus =
  let open H in
  ul
    ~a:[a_class ["tabs"]; a_user_data "tabs" ""; a_id "tabs-actu"]
    (actu_elts actu_tab_title actus)

let actu_tabs_content actus =
  let open H in
  div_class "tabs-content"
    ~a:[a_user_data "tabs-content" "tabs-actu"]
    (actu_elts actu_tabs_panel actus)

let make_actu_section actus =
  let open H in
  section ~a:[a_id "section-actu"] [
    h2 [txt "Suivez l'actu..."];
    hr ();
    div_classes ["grid-x"; "grid-padding-x"] [
      div_classes ["large-auto"; "medium-12"; "cell"]
        [actu_tabs actus; actu_tabs_content actus];
      div_classes ["large-shrink"; "medium-12"; "cell"; "text-center"] [
        div_class "callout" [
          Facebook.page_widget ()
        ]
      ]
    ]
  ]

let actu_section () = make_actu_section (Actu.get ())

let home_page () =
  Lwt.return @@
  Template.make_page ~title:"PMP6" [
    presentation_section ();
    actu_section ();
  ]
