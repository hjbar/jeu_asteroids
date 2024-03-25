val set_sum_forces : Vector.t -> unit

val get_x : unit -> float

val get_y : unit -> float

val get_hp : unit -> int

val incr_hp : unit -> unit

val decr_hp : unit -> unit

val is_alive : unit -> bool

val decr_invincible_timer : unit -> unit

val is_invincible : unit -> bool

val allow_to_shoot : unit -> bool

val delay : int ref

val reset_laser_timer : unit -> unit

val decr_laser_timer : unit -> unit
