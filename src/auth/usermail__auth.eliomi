module Model := Model__auth

val send :
  user:Model.User.t ->
  ?forced_address:string ->
  ?forced_username:string ->
  subject:string ->
  content:string ->
  unit ->
  unit Lwt.t

(** Calls send in a background task and return immediately. *)
val send_async :
  user:Model.User.t ->
  ?forced_address:string ->
  ?forced_username:string ->
  subject:string ->
  content:string ->
  unit ->
  unit
