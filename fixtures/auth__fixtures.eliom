let pacha =
  Auth.Model.User.Item.build_new
    ~is_superuser:true
    ~is_staff:true
    ~username:"pacha"
    ~email:"pacha@pmp6.fr"
    ~password:"ppacha"

let staff =
  Auth.Model.User.Item.build_new
    ~is_superuser:false
    ~is_staff:true
    ~username:"staff"
    ~email:"staff@pmp6.fr"
    ~password:"pstaff"

let poulpe =
  Auth.Model.User.Item.build_new
    ~is_superuser:false
    ~is_staff:false
    ~username:"poulpe"
    ~email:"poulpito@pmp6.fr"
    ~password:"ppoulpe"

let flush () =
  Fixture_utils.delete_all (module Auth.Model.User)

let load () =
  let%lwt pacha = Auth.Model.User.create_from_item pacha in
  let%lwt staff = Auth.Model.User.create_from_item staff in
  let%lwt poulpe = Auth.Model.User.create_from_item poulpe in
  Lwt.return @@ object
    method pacha = pacha
    method staff = staff
    method poulpe = poulpe
  end
