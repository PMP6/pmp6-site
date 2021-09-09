type encoded = Argon2.encoded (* = string *)

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

let verify encoded attempt =
  Argon2.verify ~kind:Argon2.ID ~encoded ~pwd:attempt
  |> ok_or_argon2_error
