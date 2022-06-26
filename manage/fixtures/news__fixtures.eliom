module H = Html

let content_expo_photos =
{|L'exposition de photos sous-marines de PMP6 fait son grand retour !

Au programme : (re)découvrir les magnifiques créatures capturées
par l'objectif de nos plongeurs, tout en en apprenant plus sur
elles et leurs milieux.

Cette exposition se tiendra du 11 au 29 novembre 2019 à l'Atrium
Café du campus Jussieu, lieu de convivialité pour de nombreux
étudiants. Elle sera ensuite déplacée le temps d'une journée à la
piscine Jean Taris, à l'occasion du Téléthon (7 décembre 2019), où
petits et grands pourront en profiter lors de leurs
baptêmes... sous l'eau ! La boucle est bouclée.

<img class="float-center" src="/media/Flyers_PMP6_2020.png"
  alt="Affiche de l'expo photos" />
|}

let content_rentree =
  {|<p class="callout alert">
  La réunion est annulée en raison des mesures sanitaires !
</p>

C'est la rentrée !

Les séances de piscine ont déjà repris pour les anciens aux [horaires
habituels](/informations-pratiques/piscine).

Dans ce contexte sanitaire particulier, des règles sont en place pour
pratiquer en toute sécurité. En particulier, n'oubliez pas de remplir
votre [autoquestionnaire](/media/Autoquestionnaire_FFESSM.docx) et de
l'envoyer aux [délégués](mailto:delegues@pmp6.fr) ou de venir avec
à la piscine.

Par ailleurs, une réunion de rentrée et d'information, à laquelle tous
les plongeurs, anciens comme nouveaux, sont conviés, se déroulera sur
le campus Jussieu le mercredi 7 octobre à 18 h 15.

Enfin, n'oubliez pas de vous inscrire ! Vous devez d'abord vous
préinscrire sur le site du [DAPS](https://daps.upmc.fr), puis venir
régler au secrétariat. Les tarifs d'inscription pour l'année
comprennent la cotisation de base à l'AS (à ne payer qu'une fois pour
tous les sports, sauf pour les inscrits Splash qui ne payent pas)
ainsi qu'une cotisation supplémentaire pour financer le matériel et
les séances spécifiques. Les deux montants dépendent de votre statut :

- Pour les étudiants du campus Jussieu, 45 € de base + 65 € plongée ;
- Pour les membres du personnel Jussieu, 55 € de base + 85 € plongée ;
- Pour les membres extérieurs anciens de la section, 65 € de base +
  95 € plongée ;
- Pour les encadrants (E2 + permis bateau), la cotisation de base ne
  change pas, mais la cotisation supplémentaire est fixée à 65 € quel
  que soit votre statut.

Pour plus d'informations, vous pouvez consulter la
[plaquette](/media/PMP6_plaquetteAS_2020-2021.pdf) de rentrée de la
section, ou écrire un mail aux délégués à l'adresse
<delegues@pmp6.fr>.

À très bientôt pour de nouvelles aventures sous-marines !

<img
  class="float-center"
  src="/media/Flyers_PMP6_2020.png"
  alt="Flyer de la réunion de rentrée"
/>
|}

let content_piscine =
  {|Nos entraînements en piscine ont lieu à la piscine Jean Taris, au 16
rue Thouin (Paris V<sup>ème</sup>). Ils se déroulent sur les créneaux
suivants :

- Le mardi de 21h à 22h
- Le samedi de 18h à 19h30

Les deux créneaux sont ouverts à tous les membres.
|}

let content_fosse =
  {|Les séances de fosse permettent de travailler jusqu'à 20m de
profondeur. Ils sont ouverts à tous, avec accord préalable d'un
moniteur pour les préparants Niveau 1.

Elles se déroulent à l'Espace Plongée d'Antony, à l'adresse suivante :

Centre Aquatique Pajeaud <br>
104 rue Adolphe Pajeaud <br>
92160 ANTONY <br>
RER B, direction St Rémy, station Les Baconnets puis 5-10 min à pieds

Nous ne savons pas encore quand les séances de fosse pourront
reprendre pour la saison 2020-2021. Dès qu'elles seront connues, les
dates seront disponibles sur [la page
dédiée](/informations-pratiques/fosse/).

Les inscriptions se feront comme d'habitude en remplissant le
formulaire envoyé par mail avant chaque séance.
|}

let deploy_time = Time.now ()

let expo_photo auth =
  News.Model.Item.Private.build
    ~title:"Expo photos"
    ~short_title:"Expo photos"
    ~pub_time:(deploy_time |> Fn.flip Time.sub Time.Span.minute)
    ~content:(Doc.of_md content_expo_photos)
    ~author:(Auth.Model.User.id auth#poulpe)
    ~is_visible:true

let rentree auth =
  News.Model.Item.Private.build
    ~title:"Rentrée 2020"
    ~short_title:"Rentrée 2020"
    ~pub_time:(deploy_time |> Fn.flip Time.sub Time.Span.minute)
    ~content:(Doc.of_md content_rentree)
    ~author:(Auth.Model.User.id auth#poulpe)
    ~is_visible:false

let piscine auth =
  News.Model.Item.Private.build
    ~title:"Horaires de piscine"
    ~short_title:"Piscine"
    ~pub_time:(deploy_time |> Fn.flip Time.sub Time.Span.hour)
    ~content:(Doc.of_md content_piscine)
    ~author:(Auth.Model.User.id auth#staff)
    ~is_visible:true

let fosses auth =
  News.Model.Item.Private.build
    ~title:"Dates des fosses"
    ~short_title:"Fosses"
    ~pub_time:(Time.now () |> Fn.flip Time.sub Time.Span.day)
    ~content:(Doc.of_md content_fosse)
    ~author:(Auth.Model.User.id auth#staff)
    ~is_visible:true

let flush () =
  Fixture_utils.delete_all (module News.Model)

let load auth =
  let%lwt rentree = News.Model.create_from_item @@ rentree auth in
  let%lwt piscine = News.Model.create_from_item @@ piscine auth in
  let%lwt fosses = News.Model.create_from_item @@ fosses auth in
  let%lwt expo_photo = News.Model.create_from_item @@ expo_photo auth in

  Lwt.return @@ object
    method expo_photo = expo_photo
    method rentree = rentree
    method piscine = piscine
    method fosses = fosses
  end
