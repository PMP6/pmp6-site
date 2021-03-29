module Model = News__model

module H = Html

module Deletion : sig
  val success : Model.Item.t -> [> Html_types.p ] H.elt list
  val error : Caqti_error.t -> [> Html_types.p ] H.elt list
end
