type t =
  | Color of Gfx.color
  | Image of Gfx.surface
  | Animation of
      { frames : Gfx.surface array
      ; frame_duration : int
      ; mutable current_frame : int
      ; mutable current_time : int
      }

val color : Gfx.color -> t

val image_from_surface :
  Gfx.context -> Gfx.surface -> int -> int -> int -> int -> int -> int -> t

val anim_from_surface :
  Gfx.context -> Gfx.surface -> int -> int -> int -> int -> int -> int -> t

type kind_texture =
  | Ovni
  | Asteroid
  | Asteroid_common
  | Asteroid_uncommon
  | Asteroid_rare
  | Asteroid_epic
  | Asteroid_legendary
  | Laser

val get : kind_texture -> Gfx.surface Gfx.resource

val load_all : float -> bool

val wait_all : float -> bool
