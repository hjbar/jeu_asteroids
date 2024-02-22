open System_defs
open Component_defs

let (asteroids : (int, Component_defs.box) Hashtbl.t) = Hashtbl.create 16

let asteroid_l = 25

let uid =
  let cpt = ref (-1) in
  fun () ->
    begin
      if !cpt >= 2048 then cpt := -1;
      incr cpt;
      !cpt
    end

let create_asteroid x y =
  let uid = uid () in
  let id = Printf.sprintf "asteroid_%d" uid in
  let l = asteroid_l in
  let mass = 10000. in
  let drag = 0. in
  let rebound = 0.5 in
  ( uid
  , Box.create id x y l l mass drag rebound Asteroid
      (Texture.color (Gfx.color 0 255 0 255)) )

(* Les différents paterns des asteroids *)
let pattern_1 () =
  let space = (Global.ovni_w / 2) + 10 + asteroid_l in
  let nb = Global.width / space in
  let rand = Random.int nb in
  let speed = Vector.{ x = 0.; y = 0.1 } in
  let x = ref ((10 + asteroid_l) / 2) in
  for i = 0 to nb - 1 do
    if i <> rand then begin
      let id, ast =
        create_asteroid (!x + Random.int 5) (Random.int 25 - 25 - asteroid_l)
      in
      ast#velocity#set speed;
      Hashtbl.replace asteroids id ast
    end;
    x := !x + space
  done

let paterns = [| pattern_1 |]

(* Lance l'init des asteroids *)
let init_asteroids () =
  Global.incr_wave ();
  let rand = Random.int (Array.length paterns) in
  paterns.(rand) ()

(* Maj les asteorids *)
let remove_old_asteroids =
  let screen =
    Box.invisible "screen" (-Global.wall_l) (-Global.wall_l)
      (Global.width + (2 * Global.wall_l))
      (Global.height + (2 * Global.wall_l))
  in

  let bot_mid_screen =
    Box.invisible "bot_mid_screen" 0
      (3 * Global.height / 4)
      Global.width (Global.height / 2)
  in
  (* si collision avec zone d'affichage, alors ils sont encore visibles donc on les garde
     sinon ils sont hors écrans et on les vire *)
  fun () ->
    begin
      let cpt = ref (Hashtbl.length asteroids) in
      let old =
        Hashtbl.fold
          (fun k v init ->
            if
              Rect.intersect v#pos#get v#rect#get bot_mid_screen#pos#get
                bot_mid_screen#rect#get
            then decr cpt;
            if
              Rect.intersect v#pos#get v#rect#get screen#pos#get screen#rect#get
            then init
            else (k, v) :: init )
          asteroids []
      in
      List.iter
        (fun (k, v) ->
          Hashtbl.remove asteroids k;
          Collision_system.unregister (v :> collidable);
          Forces_system.unregister (v :> collidable);
          Draw_system.unregister (v :> drawable);
          Move_system.unregister (v :> movable);
          Gc.full_major () )
        old;
      if !cpt < 16 then init_asteroids ()
    end
