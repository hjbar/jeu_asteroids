(* Getter of the ovni reference *)
let ovni () = match !Entities.ovni with Some o -> o | None -> assert false

(* To manage ovni's movements *)
let set_sum_forces v = (ovni ())#sum_forces#set v

let set_under_gravity b = (ovni ())#under_gravity#set b

(* Getter of position *)
let get_x () = (ovni ())#pos#get.x

let get_y () = (ovni ())#pos#get.y

(* To manage ovni's invicibility *)
let is_invincible () = (ovni ())#invincible#get || !Global.god_mode

let set_invincibility b =
  (ovni ())#invincible#set b;
  if b then
    let ctx = Gfx.get_context (Global.window ()) in
    let surface = Gfx.get_resource (Texture.get Ovni_invincible) in
    (ovni ())#texture#set
      (Texture.anim_from_surface ctx surface 6 19 32 Global.ovni_w Global.ovni_h
         10 )
  else
    let ctx = Gfx.get_context (Global.window ()) in
    let surface = Gfx.get_resource (Texture.get Ovni) in
    (ovni ())#texture#set
      (Texture.anim_from_surface ctx surface 6 19 32 Global.ovni_w Global.ovni_h
         10 )

(* To manage ovni's hp *)
let get_hp () = (ovni ())#hp#get

let is_alive () = (ovni ())#hp#get > 0

let incr_hp () = (ovni ())#hp#set ((ovni ())#hp#get + 1)

let decr_hp () =
  if not (is_invincible ()) then begin
    (ovni ())#hp#set ((ovni ())#hp#get - 1);
    set_invincibility true;
    let f () =
      if not (Scoring.mk_star ()) then set_invincibility false
    in
    Audio.play Damage;
    Timer.add Timer.OvniInvicible 160 f
  end

(* To manage ovni's shooting *)
let delay = ref 30

let allow_to_shoot () = (ovni ())#allow_to_shoot#get

let has_shot () =
  (ovni ())#allow_to_shoot#set false;
  let f () = (ovni ())#allow_to_shoot#set true in
  Timer.add Timer.OvniDelayShoot !delay f
