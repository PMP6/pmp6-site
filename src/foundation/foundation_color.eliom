[%%shared.start]

type t =
  | Primary
  | Secondary
  | Success
  | Warning
  | Alert

let to_class_name = function
  | Primary -> "primary"
  | Secondary -> "secondary"
  | Success -> "success"
  | Warning -> "warning"
  | Alert -> "alert"

let to_class self = Html.a_class [ to_class_name self ]
