module H = Html

let help_text ?(a=[]) content =
  H.p ~a:(H.a_class ["help-text"] :: a) content

let help_txt txt =
  help_text [ H.txt txt ]
