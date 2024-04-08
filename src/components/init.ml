open Component_defs
open System_defs

let init_walls l =
  let width = Global.width in
  let height = Global.height in
  let texture = Texture.color (Gfx.color 0 0 0 0) in

  ignore
    (Box.create "wall_top" (-l) (-l)
       (width + (2 * l))
       l infinity 0. 0.01 Wall texture );
  ignore
    (Box.create "wall_bot" (-l) height
       (width + (2 * l))
       l infinity 0. 1.25 Wall_bot texture );
  ignore (Box.create "wall_left" (-l) 0 l height infinity 0. 0.01 Wall texture);
  ignore
    (Box.create "wall_right" width 0 l height infinity 0. 0.01 Wall texture)

let init_ovni x y =
  let create_ovni id x y =
    let ovni = new ovni in

    ovni#id#set id;
    ovni#pos#set Vector.{ x = float x; y = float y };
    ovni#rect#set Rect.{ width = Global.ovni_w; height = Global.ovni_h };
    ovni#mass#set 100.;
    ovni#drag#set 0.02;
    ovni#under_gravity#set true;
    ovni#rebound#set 0.;
    ovni#object_type#set Ovni;

    let ctx = Gfx.get_context (Global.window ()) in
    let surface = Gfx.get_resource (Texture.get Ovni) in
    ovni#texture#set
      (Texture.anim_from_surface ctx surface 6 19 32 Global.ovni_w Global.ovni_h
         10 );

    ovni#hp#set 5;
    ovni#invincible#set false;
    ovni#allow_to_shoot#set true;

    Collision_system.register (ovni :> box);
    Forces_system.register (ovni :> collidable);
    Draw_system.register (ovni :> drawable);
    Move_system.register (ovni :> movable);

    ovni
  in
  Entities.ovni := Some (create_ovni "ovni" x y)

let init_bg () =
  let bg = new drawable in

  bg#pos#set Vector.{ x = 0.; y = float (-Global.height) };

  bg#rect#set Rect.{ width = Global.width; height = 2 * Global.height };

  let ctx = Gfx.get_context (Global.window ()) in
  let surface = Gfx.get_resource (Texture.get Background) in
  bg#texture#set
    (Texture.image_from_surface ctx surface 0 0 2048 2048 Global.width
       Global.height );

  Entities.background := Some bg

let init_all dt =
  Random.self_init ();

  init_walls Global.wall_l;
  init_ovni (Global.width / 2) (3 * Global.height / 4);
  init_bg ();
  Asteroid.init_asteroids ();

  Ecs.System.init_all dt
