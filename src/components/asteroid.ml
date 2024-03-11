open System_defs
open Component_defs

(* Générateur d'uid *)
let uid =
  let cpt = ref (-1) in
  fun () ->
    begin
      if !cpt >= 2048 then cpt := -1;
      incr cpt;
      !cpt
    end

(* Création d'asteroid *)
let rec create_asteroid x y id level =
  let l = Global.asteroid_size in
  let l =
    [| int_of_float (float l *. 0.6); int_of_float (float l *. 0.8); l |].(level)
  in
  let mass = [| 10.; 100.; 1000. |].(level) in
  let drag = 0. in
  let rebound = 0.5 in

  let ctx = Gfx.get_context (Global.window ()) in
  let surface = Gfx.get_resource (Texture.get Asteroid) in
  let texture = Texture.image_from_surface ctx surface 0 0 32 32 l l in

  let ast = Box.create id x y l l mass drag rebound Asteroid texture in
  let f = ast#remove#get in
  ast#hp#set [| 1; 2; 4 |].(level);
  ast#level#set level;

  ast#under_gravity#set [| true; true; false |].(level);

  ast#remove#set (fun () ->
      f ();
      if ast#is_dead#get then
        let ast_size = Global.asteroid_size in

        let x = int_of_float ast#pos#get.x in
        let y = int_of_float ast#pos#get.y in

        let lvl = ast#level#get - 1 in

        let factor = [| 10.; 1. |].(lvl) in
        let vx = 0.5 /. factor in
        let vy = 1. /. factor in

        if lvl >= 0 then begin
          create_asteroid_with_sumforces (x - ast_size) (y - ast_size)
            (id ^ "_0")
            Vector.{ x = -1. *. vx; y = -1. *. vy }
            lvl;
          create_asteroid_with_sumforces (x + ast_size) (y - ast_size)
            (id ^ "_1")
            Vector.{ x = vx; y = -1. *. vy }
            lvl;
          create_asteroid_with_sumforces (x - ast_size) (y + ast_size)
            (id ^ "_2")
            Vector.{ x = -1. *. vx; y = vy }
            lvl;
          create_asteroid_with_sumforces (x + ast_size) (y + ast_size)
            (id ^ "_3")
            Vector.{ x = vx; y = vy }
            lvl
        end );
  Box_collection.asteroids#replace id ast;
  ast

and create_asteroid_with_velocity x y id velocity level =
  let ast = create_asteroid x y id level in
  ast#velocity#set velocity

and create_asteroid_with_sumforces x y id sum_forces level =
  let ast = create_asteroid x y id level in
  ast#sum_forces#set sum_forces

(* Les différents paterns des asteroids *)
let pattern_1 () =
  let space = (Global.ovni_w / 2) + 10 + Global.asteroid_size in
  let nb = Global.width / space in
  let rand = Random.int nb in
  let speed = Vector.{ x = 0.; y = 3.75 } in
  let x = ref ((10 + Global.asteroid_size) / 2) in
  for i = 0 to nb - 1 do
    if i <> rand then begin
      let id = Printf.sprintf "asteroids_%d" (uid ()) in
      create_asteroid_with_sumforces
        (!x + Random.int 5)
        (Random.int 25 - 25 - Global.asteroid_size)
        id speed 2
    end;
    x := !x + space
  done

let paterns = [| pattern_1 |]

(* Lance l'init des asteroids *)
let init_asteroids () =
  Scoring.incr_wave ();
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

  let asteroids_required =
    (Global.width / Global.asteroid_size)
    - (Global.width / Global.asteroid_size / 2)
  in
  (* si collision avec zone d'affichage, alors ils sont encore visibles donc on les garde
     sinon ils sont hors écrans et on les vire *)
  fun () ->
    begin
      (* add_new_asteroids (); *)
      let cpt = ref Box_collection.asteroids#length in
      (* let cpt = ref (Hashtbl.length Global.asteroids_table) in *)
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
          (* Global.asteroids_table *) Box_collection.asteroids#table []
      in
      List.iter
        (fun (k, v) ->
          (* Hashtbl.remove Global.asteroids_table k; *)
          Box_collection.asteroids#remove k;
          v#is_offscreen#set true )
        old;
      if !cpt < asteroids_required then init_asteroids ()
    end
