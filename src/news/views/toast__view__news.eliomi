module Model = Model__news

module H = Html

val created : Model.t -> [> Html_types.p ] H.elt list

val deleted : Model.Item.t -> [> Html_types.p ] H.elt list

val updated : Model.t -> [> Html_types.p ] H.elt list
