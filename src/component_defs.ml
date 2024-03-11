open Ecs

(* Some type *)
type object_type_def =
  | Collidable
  | Asteroid
  | Ovni
  | Laser
  | Wall
  | Wall_bot
  | Screen

(* Some basic components *)
class object_type =
  object
    val object_type = Component.def Collidable

    method object_type = object_type
  end

class position =
  object
    val pos = Component.def Vector.zero

    method pos = pos
  end

class rect =
  object
    val rect = Component.def Rect.{ width = 0; height = 0 }

    method rect = rect
  end

class mass =
  object
    val mass = Component.def 0.

    method mass = mass
  end

class drag =
  object
    val drag = Component.def 0.

    method drag = drag
  end

class velocity =
  object
    val velocity = Component.def Vector.zero

    method velocity = velocity
  end

class sum_forces =
  object
    val sum_forces = Component.def Vector.zero

    method sum_forces = sum_forces
  end

class under_gravity =
  object
    val under_gravity = Component.def false

    method under_gravity = under_gravity
  end

class texture =
  object
    val texture = Component.def (Texture.color (Gfx.color 0 0 0 0))

    method texture = texture
  end

class id =
  object
    val id = Component.def ""

    method id = id
  end

class rebound =
  object
    val rebound = Component.def 0.

    method rebound = rebound
  end

class level =
  object
    val level = Component.def 0

    method level = level
  end

class hp =
  object
    val hp = Component.def 0

    method hp = hp
  end

class invincible =
  object
    val invincible = Component.def false

    method invincible = invincible
  end

class invincible_timer =
  object
    val invincible_timer = Component.def 0

    method invincible_timer = invincible_timer
  end

class laser_timer =
  object
    val laser_timer = Component.def 0

    method laser_timer = laser_timer
  end

(* Some complex components *)

class movable =
  object
    inherit position

    inherit drag

    inherit velocity

    inherit under_gravity
  end

class collidable =
  object
    inherit movable

    inherit mass

    inherit sum_forces

    inherit rebound

    inherit rect

    inherit object_type
  end

class drawable =
  object
    inherit position

    inherit rect

    inherit texture
  end

class offscreen =
  object
    val is_offscreen = Component.def false

    val is_dead = Component.def false

    val remove = Component.def (fun () -> ())

    method is_offscreen = is_offscreen

    method is_dead = is_dead

    method remove = remove
  end

class box =
  object
    inherit drawable

    inherit! collidable

    inherit id
  end

class offscreenable_box =
  object
    inherit box

    inherit offscreen

    inherit hp

    inherit level
  end

class ovni =
  object
    inherit box

    inherit hp

    inherit invincible

    inherit invincible_timer

    inherit laser_timer
  end

class box_collection (b : bool) =
  object (self)
    val table : (string, offscreenable_box) Hashtbl.t = Hashtbl.create 16

    val mutable is_asteroid : bool = false

    initializer is_asteroid <- b

    method length = Hashtbl.length table

    method replace (id : string) (e : offscreenable_box) : unit =
      Hashtbl.replace table id e

    method remove (id : string) : unit = Hashtbl.remove table id

    method table : (string, offscreenable_box) Hashtbl.t = table

    method unregister (e : box) =
      if Hashtbl.mem table e#id#get then begin
        let e = Hashtbl.find table e#id#get in

        if is_asteroid then begin
          e#hp#set (e#hp#get - 1);
          e#is_dead#set (e#hp#get <= 0)
        end
        else e#is_dead#set true;

        if e#is_dead#get then self#remove e#id#get
      end
  end
