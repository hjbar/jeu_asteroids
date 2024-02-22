open System_defs
open Component_defs

(* On crée une fenêtre *)
let () =
  Global.init
    (Format.sprintf "game_canvas:%dx%d:r=presentvsync" Global.width
       Global.height )

(* On crée la config *)
type config =
  { up : string
  ; down : string
  ; left : string
  ; right : string
  }

let has_key, set_key, unset_key =
  let h = Hashtbl.create 16 in
  ( (fun s -> Hashtbl.mem h s)
  , (fun s -> Hashtbl.replace h s ())
  , fun s -> Hashtbl.remove h s )

(* On initialise le jeu *)
let init dt =
  Random.self_init ();

  Wall.init_walls 80;
  Ovni.init_ovni (Global.width / 2) (Global.height / 2);
  Asteroid.init_asteroids ();

  Ecs.System.init_all dt;
  false

(* On update le jeu *)
let update config dt =
  (* On update les inputs *)
  let () =
    match Gfx.poll_event () with
    | KeyDown s -> set_key s
    | KeyUp s -> unset_key s
    | _ -> ()
  in

  (* On update les mouvements *)
  let dx = ref 0. in
  let dy = ref 0. in

  let v = 0.1 in

  if has_key config.up then dy := !dy -. v;
  if has_key config.down then dy := !dy +. v;
  if has_key config.left then dx := !dx -. v;
  if has_key config.right then dx := !dx +. v;

  Ovni.set_sum_forces Vector.{ x = !dx; y = !dy };

  (* On update le reste du jeu *)
  Asteroid.remove_old_asteroids ();
  Scoring.update_scoring ();
  Ecs.System.update_all dt;
  Print.print ();
  if Global.alive () then true
  else (
    Print.game_over ();
    false )

(* On lance le jeu *)
let run config =
  Texture.load ();
  Gfx.main_loop init;
  Gfx.main_loop (update config)
