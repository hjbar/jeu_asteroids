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

(* Some complex components *)

class movable =
  object
    inherit position

    inherit drag

    inherit velocity
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

class box =
  object
    inherit drawable

    inherit! collidable

    inherit id
  end

class box_collection (b : bool) =
  object (self)
    val table : (string, box) Hashtbl.t = Hashtbl.create 16

    val mutable is_asteroid : bool = false

    initializer is_asteroid <- b

    method length = Hashtbl.length table

    method replace (id : string) (e : box) : unit = Hashtbl.replace table id e

    method remove (id : string) : unit = Hashtbl.remove table id

    method table : (string, box) Hashtbl.t = table

    method unregister (e : box) =
      if Hashtbl.mem table e#id#get then begin
        let x, y = (e#pos#get.x, e#pos#get.y) in
        self#remove e#id#get;
        e#pos#set Vector.{ x = -100.; y = -100. };
        if is_asteroid then begin
          let ast_size = float Global.asteroid_size in
          let y = y +. ast_size in
          (* ajout des 3 asteroides *)
          Global.add_asteroid (e#id#get ^ "0") (-0.6) (x -. (1.5 *. ast_size), y);
          Global.add_asteroid (e#id#get ^ "1") 0. (x, y);
          Global.add_asteroid (e#id#get ^ "2") 0.3 (x +. (1.5 *. ast_size), y)
        end
      end
  end
