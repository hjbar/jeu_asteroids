open Component_defs
open System_defs

let create id x y w h mass drag rebound obj_type texture =
  Gfx.debug "create\n%!";
  let box = new offscreenable_box in

  box#id#set id;
  box#pos#set Vector.{ x = float x; y = float y };
  box#rect#set Rect.{ width = w; height = h };
  box#mass#set mass;
  box#drag#set drag;
  box#rebound#set rebound;
  box#object_type#set obj_type;
  box#texture#set texture;

  box#remove#set (fun () -> Gfx.debug "removing %s\n%!" id;
  Collision_system.unregister (box :> box);
  Forces_system.unregister (box :> collidable);
  Draw_system.unregister (box :> drawable);
  Move_system.unregister (box :> movable);
  Cancellable_system.unregister (box););
  
  Collision_system.register (box :> box);
  Forces_system.register (box :> collidable);
  Draw_system.register (box :> drawable);
  Move_system.register (box :> movable);
  Cancellable_system.register (box);

  box

let invisible id x y w h =
  let box = new box in

  box#id#set id;
  box#pos#set Vector.{ x = float x; y = float y };
  box#rect#set Rect.{ width = w; height = h };

  box
