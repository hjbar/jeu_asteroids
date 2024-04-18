type config =
  { up : string
  ; down : string
  ; left : string
  ; right : string
  ; space : string
  ; bind : string
  ; unbind : string
  ; break : string
  ; quit : string
  ; god : string
  ; bonus : string
  }

val set_key : string -> unit

val unset_key : string -> unit

val is_break : config -> bool

val not_break : config -> bool

val is_quit : config -> bool

val update : config -> unit
