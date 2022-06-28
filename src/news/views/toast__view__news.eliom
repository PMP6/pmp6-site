module Model = Model__news

module H = Html

let created news =
  Toast.success [
    H.p [
      H.txt "L'actu ";
      H.em [H.txt @@ Model.short_title news];
      H.txt " a bien été créée.";
    ]
  ]

let deleted item =
  Toast.success [
    H.p [
      H.txt "L'actu ";
      H.em [H.txt @@ Model.Item.short_title item];
      H.txt " a bien été supprimée.";
      H.Raw.a [H.txt "TODO: Annuler."];
    ]
  ]

let updated news =
  Toast.success [
    H.p [
      H.txt "L'actu ";
      H.em [H.txt @@ Model.short_title news];
      H.txt " a bien été mise à jour.";
    ]
  ]
