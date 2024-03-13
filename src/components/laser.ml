open Component_defs
open System_defs

(* Dimensions laser *)
let laser_long = 10 * 3

let laser_larg = 2 * 3

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
  let id = Printf.sprintf "laser_%d" uid in
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

  let laser =
    Box.create id x y laser_larg laser_long mass drag rebound Laser texture
  in

  let dif_x = float (Global.ovni_w / 2) -. float (laser_larg / 2) in
  let dif_y = -.float laser_long in
  let x = Ovni.get_x () +. dif_x in
  let y = Ovni.get_y () +. dif_y in
  laser#pos#set Vector.{ x; y };

  let speed = Vector.{ x = 0.; y = -0.75 } in
  laser#velocity#set speed;

  Entities.lasers#replace id laser;
  Ovni.reset_laser_timer ()

(* Maj les lasers *)
let remove_old_lasers =
  let screen =
    Box.invisible "screen" (-Global.wall_l) (-Global.wall_l)
      (Global.width + (2 * Global.wall_l))
      (Global.height + (2 * Global.wall_l))
  in

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
