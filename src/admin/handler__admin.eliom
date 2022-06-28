module View = View__admin

open Auth.Require.Syntax

let main =
  let$ _user = Auth.Require.staff in
  fun () () ->
    View.main ()
