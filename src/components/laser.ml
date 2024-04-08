open Component_defs
open System_defs

(* Dimensions laser *)
let laser_long = 10 * 3

let laser_larg = 2 * 3

let nb_lasers = ref 1

let split_shoot = ref false

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

  let nb_lsrs = !nb_lasers + if !split_shoot && !nb_lasers = 1 then 1 else 0 in

  let lasers =
    Array.init nb_lsrs (fun i ->
        let id = Printf.sprintf "laser_%d_%d" uid i in
        Box.create id x y laser_larg laser_long mass drag rebound Laser texture )
  in

  let dif_x = float (Global.ovni_w / 2) -. float (laser_larg / 2) in
  let dif_y = -.float laser_long in
  let x = Ovni.get_x () +. dif_x in
  let y = Ovni.get_y () +. dif_y in

  let d = nb_lsrs / 2 in
  if nb_lsrs mod 2 = 0 then begin
    for i = 0 to d - 1 do
      let speed1, speed2 =
        if !split_shoot then
          ( Vector.{ x = 0.1 -. (0.2 *. float (i + 1)); y = -0.75 }
          , Vector.{ x = -0.1 +. (0.2 *. float (i + 1)); y = -0.75 } )
        else (Vector.{ x = 0.; y = -0.75 }, Vector.{ x = 0.; y = -0.75 })
      in

      let decal1, decal2 = if !split_shoot then (-5., 5.) else (5., -5.) in

      let l1 = lasers.(i) in
      l1#pos#set Vector.{ x = x +. decal1 -. (10. *. float (i + 1)); y };
      l1#velocity#set speed1;
      Entities.lasers#replace l1#id#get l1;

      let l2 = lasers.(d + i) in
      l2#pos#set Vector.{ x = x +. decal2 +. (10. *. float (i + 1)); y };
      l2#velocity#set speed2;
      Entities.lasers#replace l2#id#get l2
    done;

    if !split_shoot then begin
      let id = Printf.sprintf "laser_%d_%d" uid (nb_lsrs + 1) in
      let las =
        Box.create id 0 0 laser_larg laser_long mass drag rebound Laser texture
      in
      las#pos#set Vector.{ x; y };
      las#velocity#set Vector.{ x = 0.; y = -0.75 };
      Entities.lasers#replace las#id#get las
    end
  end
  else begin
    for i = 0 to d - 1 do
      let speed1, speed2 =
        if !split_shoot then
          ( Vector.{ x = 0.1 -. (0.2 *. float (i + 1)); y = -0.75 }
          , Vector.{ x = -0.1 +. (0.2 *. float (i + 1)); y = -0.75 } )
        else (Vector.{ x = 0.; y = -0.75 }, Vector.{ x = 0.; y = -0.75 })
      in

      let l1 = lasers.(i) in
      l1#pos#set Vector.{ x = x -. (10. *. float (i + 1)); y };
      l1#velocity#set speed1;
      Entities.lasers#replace l1#id#get l1;

      let l2 = lasers.(d + i + 1) in
      l2#pos#set Vector.{ x = x +. (10. *. float (i + 1)); y };
      l2#velocity#set speed2;
      Entities.lasers#replace l2#id#get l2
    done;

    let l = lasers.(d) in
    l#pos#set Vector.{ x; y };
    l#velocity#set Vector.{ x = 0.; y = -0.75 };
    Entities.lasers#replace l#id#get l
  end;

  Ovni.has_shot ()

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
          Entities.lasers#table []
      in
      List.iter
        (fun (k, v) ->
          Entities.lasers#remove k;
          v#is_offscreen#set true )
        old
    end
