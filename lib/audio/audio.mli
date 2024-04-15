type audio_kind =
  | Laser
  | Explosion
  | Bonus
  | Defeat

val play : audio_kind -> unit

val init : (audio_kind * string) list -> bool
