module Model = News__model

module H = Html

module Creation : sig
  val success : Model.t -> [> Html_types.p ] H.elt list
  val error : Caqti_error.t -> [> Html_types.p ] H.elt list
end

module Deletion : sig
  val success : Model.Item.t -> [> Html_types.p ] H.elt list
  val error : Caqti_error.t -> [> Html_types.p ] H.elt list
end

module Update : sig
  val success : Model.t -> [> Html_types.p ] H.elt list
  val error : Caqti_error.t -> [> Html_types.p ] H.elt list
end
