module Model = Model__news
module H = Html

val created : Model.t -> Toast.t
val deleted : Model.Item.t -> Toast.t
val updated : Model.t -> Toast.t
