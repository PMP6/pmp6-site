module type Id = sig
  type t
  val db_type : t Caqti_type.t
end

module Id : Id = struct
  type t = int
  let db_type = Caqti_type.int
end

module type Data = sig
  type t
  type mapping

  val db_type : mapping Caqti_type.t
  val db_map : t -> mapping
  val db_unmap : mapping -> t
end

module With_id (Data : Data) : sig
  module Id : Id
  type with_id
  type mapping_with_id

  val id : with_id -> Id.t
  val data : with_id -> Data.t
  val with_id : Id.t -> Data.t -> with_id

  val db_type_with_id : mapping_with_id Caqti_type.t
  val db_map_with_id : with_id -> mapping_with_id
  val db_unmap_with_id : mapping_with_id -> with_id
end
=
struct
  module Id = Id

  type with_id = Id.t * Data.t

  type mapping_with_id = Id.t * Data.mapping

  let db_type_with_id =
    Db.Type.(Id.db_type & Data.db_type)

  let id (id, _) =
    id

  let data (_, data) =
    data

  let with_id id data =
    (id, data)

  let db_unmap_with_id (id, data_repr) =
    (id, Data.db_unmap data_repr)

  let db_map_with_id (id, data) =
    (id, Data.db_map data)
end
