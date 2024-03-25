let ovni () = match !Entities.ovni with Some o -> o | None -> assert false

let set_sum_forces v = (ovni ())#sum_forces#set v

let get_x () = (ovni ())#pos#get.x

let get_y () = (ovni ())#pos#get.y

let get_hp () = (ovni ())#hp#get

let incr_hp () = (ovni ())#hp#set ((ovni ())#hp#get + 1)

let decr_hp () =
  if (ovni ())#invincible_timer#get = 0 then begin
    (ovni ())#hp#set ((ovni ())#hp#get - 1);
    (ovni ())#invincible_timer#set 160
  end

let is_alive () = (ovni ())#hp#get > 0

let decr_invincible_timer () =
  let timer = (ovni ())#invincible_timer#get in
  if timer > 0 then (ovni ())#invincible_timer#set (timer - 1)

let is_invincible () = (ovni ())#invincible_timer#get > 0

let allow_to_shoot () = (ovni ())#laser_timer#get = 0

let delay = ref 20

let reset_laser_timer () = (ovni ())#laser_timer#set !delay

let decr_laser_timer () =
  let timer = (ovni ())#laser_timer#get in
  if timer > 0 then (ovni ())#laser_timer#set (timer - 1)
