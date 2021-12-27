module Hash = struct
  type t = Argon2.encoded (* = string *)

  let db_type = Caqti_type.string

  let ok_or_argon2_error result =
    result
    |> Result.map_error ~f:Argon2.ErrorCodes.message
    |> Result.ok_or_failwith

  let random_salt salt_len =
    String.init salt_len ~f:(fun _ -> Random.char ())

  let encode password =
    (* Parameters tuned to take ~0.5s on entry-level OVH VPS, using
       less than half of available RAM as of running the test *)
    let salt_len = 16 (* bytes *) in
    let hash_len = 16 (* bytes *) in
    let t_cost = 1 in
    let m_cost = 250_000 in
    let parallelism = 1 in
    let encoded_len =
      Argon2.encoded_len
        ~t_cost
        ~m_cost
        ~parallelism
        ~salt_len
        ~hash_len
        ~kind:Argon2.ID in
    let salt = random_salt salt_len in
    Argon2.hash
      ~version:Argon2.VERSION_13
      ~kind:Argon2.ID
      ~t_cost
      ~m_cost
      ~parallelism
      ~pwd:password
      ~salt
      ~hash_len
      ~encoded_len
    |> Result.map ~f:snd
    |> ok_or_argon2_error

  let verify hash attempt =
    match Argon2.verify ~kind:Argon2.ID ~encoded:hash ~pwd:attempt with
    | Ok true -> true
    | Ok false
    | Error VERIFY_MISMATCH -> false
    | Error e -> failwith (Argon2.ErrorCodes.message e)

end

let%shared key_of_url_string string =
  Base64.decode_exn
    ~pad:false
    ~alphabet:Base64.uri_safe_alphabet
    string

let%shared key_to_url_string key =
  Base64.encode_exn
    ~pad:false
    ~alphabet:Base64.uri_safe_alphabet
    key

module Key = struct
  type t = string

  let create () =
    Ocsigen_lib.make_cryptographic_safe_string ()

  let hash key =
    Hash.encode key

  let verify hash key =
    Hash.verify hash key

  let param name =
    let client_to_and_of =
      Caml.(
        [%client
        Eliom_parameter.{
          of_string = key_of_url_string;
          to_string = key_to_url_string;
        }]) in
    Eliom_parameter.user_type
      ~client_to_and_of
      ~of_string:key_of_url_string
      ~to_string:key_to_url_string
      name

end
