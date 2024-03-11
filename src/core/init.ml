open Component_defs
open System_defs

let create_ovni id x y =
  let ovni = new ovni in

  ovni#id#set id;
  ovni#pos#set Vector.{ x = float x; y = float y };
  ovni#rect#set Rect.{ width = Global.ovni_w; height = Global.ovni_h };
  ovni#mass#set 100.;
  ovni#drag#set 0.02;
  ovni#rebound#set 0.;
  ovni#object_type#set Ovni;

  let ctx = Gfx.get_context (Global.window ()) in
  let surface = Gfx.get_resource (Global.get_texture Ovni) in
  ovni#texture#set
    (Texture.anim_from_surface ctx surface 6 19 32 Global.ovni_w Global.ovni_h
       10 );

  ovni#hp#set 5;
  ovni#invincible#set false;
  ovni#invincible_timer#set 0;
  ovni#laser_timer#set 0;

  Collision_system.register (ovni :> box);
  Forces_system.register (ovni :> collidable);
  Draw_system.register (ovni :> drawable);
  Move_system.register (ovni :> movable);

  ovni

let init_ovni x y = Entities.ovni := Some (create_ovni "ovni" x y)
