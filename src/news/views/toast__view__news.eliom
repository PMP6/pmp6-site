module Model = Model__news

module H = Html

module Creation = struct
  let success news =
    [
      H.p [
        H.txt "L'actu ";
        H.em [H.txt @@ Model.short_title news];
        H.txt " a bien été créée.";
      ]
    ]
end

module Deletion = struct
  let success item =
    [
      H.p [
        H.txt "L'actu ";
        H.em [H.txt @@ Model.Item.short_title item];
        H.txt " a bien été supprimée.";
        H.Raw.a [H.txt "TODO: Annuler."];
      ]
    ]
end

module Update = struct
  let success news =
    [
      H.p [
        H.txt "L'actu ";
        H.em [H.txt @@ Model.short_title news];
        H.txt " a bien été mise à jour.";
      ]
    ]
end
