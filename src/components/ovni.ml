open Component_defs
open System_defs

let ovni = ref (new box)

let create id x y =
  let ovni = new box in

  ovni#id#set id;
  ovni#pos#set Vector.{ x = float x; y = float y };
  ovni#rect#set Rect.{ width = Global.ovni_w; height = Global.ovni_h };
  ovni#mass#set 100.;
  ovni#drag#set 0.02;
  ovni#rebound#set 0.;
  ovni#object_type#set Ovni;

  (* ovni#texture#set (Texture.color (Gfx.color 255 0 0 255)); *)
  let ctx = Gfx.get_context (Global.window ()) in
  let surface = Gfx.get_resource (Global.get_texture Ovni) in
  ovni#texture#set
    (Texture.anim_from_surface ctx surface 6 19 32 Global.ovni_w Global.ovni_h
       10 );

  Collision_system.register ovni;
  Forces_system.register (ovni :> collidable);
  Draw_system.register (ovni :> drawable);
  Move_system.register (ovni :> movable);

  ovni

let init_ovni x y = ovni := create "ovni" x y

let set_sum_forces v = !ovni#sum_forces#set v

let get_x () = !ovni#pos#get.x

let get_y () = !ovni#pos#get.y
