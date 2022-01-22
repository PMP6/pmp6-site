module Model := Model__auth

val send_user_email :
  user:Model.User.t ->
  ?forced_address:string ->
  ?forced_username:string ->
  subject:string ->
  content:string ->
  unit ->
  unit Lwt.t
