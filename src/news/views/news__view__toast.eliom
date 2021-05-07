module Model = News__model

module H = Html

module Creation = struct
  let success news =
    [
      H.p [
        H.txt "L'actu ";
        H.em [H.txt @@ Model.short_title news];
        H.txt " a bien été créée !";
      ]
    ]

  let error (_e : Caqti_error.t) =
    [
      H.p [
        H.txt "Une erreur est survenue lors de la création de \
               l'actu. Si cette situation se reproduit, contactez \
               l'administrateur."
      ]
    ]
end

module Deletion = struct
  let success item =
    [
      H.p [
        H.txt "L'actu ";
        H.em [H.txt @@ Model.Item.short_title item];
        H.txt " a bien été supprimée ! ";
        H.Raw.a [H.txt "TODO: Annuler."];
      ]
    ]

  let error (_e : Caqti_error.t) =
    [
      H.p [
        H.txt "Une erreur est survenue lors de la suppression de \
               l'actu. Si cette situation se reproduit, contactez \
               l'administrateur."
      ]
    ]
end

module Update = struct
  let success news =
    [
      H.p [
        H.txt "L'actu ";
        H.em [H.txt @@ Model.short_title news];
        H.txt " a bien été mise à jour !";
      ]
    ]

  let error (_e : Caqti_error.t) =
    [
      H.p [
        H.txt "Une erreur est survenue lors de la mise à jour de \
               l'actu. Si cette situation se reproduit, contactez \
               l'administrateur."
      ]
    ]
end
