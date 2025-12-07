module H = Html

let create ?(a = []) contents = H.div ~a:(H.a_class [ "card" ] :: a) contents
let divider ?(a = []) contents = H.div ~a:(H.a_class [ "card-divider" ] :: a) contents
let section ?(a = []) contents = H.div ~a:(H.a_class [ "card-section" ] :: a) contents
