type audio_kind =
  | Laser
  | Explosion
  | Bonus
  | Defeat
  | Damage
  | Bomb

val play : audio_kind -> unit

val init : (audio_kind * string) list -> unit
