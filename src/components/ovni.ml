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

let set_invincibility b = (ovni ())#invincible#set b

(* To manage ovni's hp *)
let get_hp () = (ovni ())#hp#get

let is_alive () = (ovni ())#hp#get > 0

let incr_hp () = (ovni ())#hp#set ((ovni ())#hp#get + 1)

let decr_hp () =
  if not (is_invincible ()) then begin
    (ovni ())#hp#set ((ovni ())#hp#get - 1);
    (ovni ())#invincible#set true;
    let f () =
      if not (Scoring.mk_star ()) then (ovni ())#invincible#set false
    in
    Timer.add Timer.OvniInvicible 160 f
  end

(* To manage ovni's shooting *)
let delay = ref 30

let allow_to_shoot () = (ovni ())#allow_to_shoot#get

let has_shot () =
  (ovni ())#allow_to_shoot#set false;
  let f () = (ovni ())#allow_to_shoot#set true in
  Timer.add Timer.OvniDelayShoot !delay f
