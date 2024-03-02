module type Id = sig
  type t

  val db_type : t Caqti_type.t
  val pp : t Fmt.t

  val param :
    string ->
    ( t,
      [ `WithoutSuffix ],
      [ `One of t ] Eliom_parameter.param_name )
    Eliom_parameter.params_type

  val form_param : t Html.Form.param

  val hidden_input :
    [< t Eliom_parameter.setoneradio ] Eliom_parameter.param_name ->
    t ->
    [> Html_types.input ] Html.elt
end

module type Data = sig
  type t
  type mapping

  val db_type : mapping Caqti_type.t
  val db_map : t -> mapping
  val db_unmap : mapping -> t
end

module type Data_with_id = sig
  module Id : Id

  type item

  include Data
  module Product : Data with type t = Id.t * item

  val id : t -> Id.t
  val item : t -> item
  val lift : (item -> 'a) -> t -> 'a

  val id_hidden_input :
    [< Id.t Eliom_parameter.setoneradio ] Eliom_parameter.param_name ->
    t ->
    [> Html_types.input ] Html.elt
end

module With_id (Item : Data) : Data_with_id with type item := Item.t = struct
  module Id = struct
    type t = int

    let db_type = Caqti_type.int
    let param = Eliom_parameter.int
    let pp = Fmt.int
    let form_param = Html.Form.int

    let hidden_input name value =
      Html.Form.input ~input_type:`Hidden ~name ~value form_param
  end

  module Product = struct
    type t = Id.t * Item.t
    type mapping = Id.t * Item.mapping

    let db_type = Db.Type.(Id.db_type & Item.db_type)
    let db_map (id, item) = (id, Item.db_map item)
    let db_unmap (id, item_repr) = (id, Item.db_unmap item_repr)
  end

  include Product

  let id (id, _) = id
  let item (_, item) = item
  let lift f = Fn.compose f item
  let id_hidden_input name x = Id.hidden_input name (id x)
end
