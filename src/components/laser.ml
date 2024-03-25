open Component_defs
open System_defs

(* Dimensions laser *)
let laser_long = 10 * 3

let laser_larg = 2 * 3

let nb_lasers = ref 1

(* Générateur d'uid *)
let uid =
  let cpt = ref (-1) in
  fun () ->
    begin
      if !cpt >= 4096 then cpt := -1;
      incr cpt;
      !cpt
    end

(* Création de laser *)
let create () =
  let uid = uid () in
  let x = 0 in
  let y = 0 in
  let mass = 1. in
  let drag = 0. in
  let rebound = 0. in

  let ctx = Gfx.get_context (Global.window ()) in
  let surface = Gfx.get_resource (Texture.get Laser) in
  let texture =
    Texture.anim_from_surface ctx surface 3 3 32 laser_larg laser_long 5
  in

  let lasers = Array.init !nb_lasers (fun i -> let id = Printf.sprintf "laser_%d_%d" uid i in Box.create id x y laser_larg laser_long mass drag rebound Laser texture) in

  let dif_x = float (Global.ovni_w / 2) -. float (laser_larg / 2) in
  let dif_y = -.float laser_long in
  let x = Ovni.get_x () +. dif_x in
  let y = Ovni.get_y () +. dif_y in
  
  let d = !nb_lasers / 2 in
  if !nb_lasers mod 2 = 0 then
    for i = 0 to d - 1 do
      lasers.(i)#pos#set Vector.{ x = x +. 5. -. 10. *. (float (i+1)); y };
      lasers.(d + i)#pos#set Vector.{ x = x -. 5.0 +. 10. *. (float (i+1)); y };
    done
  else
    begin
      for i = 0 to d - 1 do
        lasers.(i)#pos#set Vector.{ x = x -. 10. *. (float (i+1)); y };
        lasers.(d + i + 1)#pos#set Vector.{ x = x +. 10. *.  (float (i+1)); y };
      done;
      lasers.(d)#pos#set Vector.{ x ; y }
    end;

  let speed = Vector.{ x = 0.; y = -0.75 } in
  Array.iter (fun v -> v#velocity#set speed; Entities.lasers#replace v#id#get v) lasers;

  Ovni.reset_laser_timer ()

(* Maj les lasers *)
let remove_old_lasers =
  let screen = Box.invisible "screen" 0 0 Global.width Global.height in

  (* si collision avec zone d'affichage, alors ils sont encore visibles donc on les garde
      sinon ils sont hors écrans et on les vire *)
  fun () ->
    begin
      let old =
        Hashtbl.fold
          (fun k v init ->
            if
              Rect.intersect v#pos#get v#rect#get screen#pos#get screen#rect#get
            then init
            else (k, v) :: init )
          (* Global.lasers_table *) Entities.lasers#table []
      in
      List.iter
        (fun (k, v) ->
          (* Hashtbl.remove Global.lasers_table k; *)
          Entities.lasers#remove k;
          v#is_offscreen#set true;
          Gc.full_major () )
        old
    end
