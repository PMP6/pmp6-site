module Model = News__model

module H = Html

module Deletion = struct
  let success news =
    [
      H.p [
        H.txt "L'actu ";
        H.em [H.txt @@ Model.Item.short_title news];
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
