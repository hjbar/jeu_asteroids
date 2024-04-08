(* On crée une fenêtre *)
let init_window _dt =
  Global.init
    (Format.sprintf "game_canvas:%dx%d:r=presentvsync" Global.width
       Global.height );
  false

(* On crée la config *)
type config =
  { up : string
  ; down : string
  ; left : string
  ; right : string
  ; space : string
  }

let has_key, set_key, unset_key =
  let h = Hashtbl.create 16 in
  ( (fun s -> Hashtbl.mem h s)
  , (fun s -> Hashtbl.replace h s ())
  , fun s -> Hashtbl.remove h s )

(* On initialise le jeu *)
let init dt =
  Init.init_all dt;
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

  (* On update les lasers *)
  if has_key config.space && Ovni.allow_to_shoot () then Laser.create ();

  (* On update le reste du jeu *)
  Asteroid.remove_old_asteroids ();
  Laser.remove_old_lasers ();
  Scoring.update ();
  Timer.update_all ();
  Background.update ();
  Ecs.System.update_all dt;
  Print.print ();

  if Ovni.is_alive () then true
  else (
    Print.game_over ();
    false )

(* Fonction utilitaire pour gérer Gfx.main_loop *)
let chain_functions l =
  let todo = ref l in
  fun dt ->
    match !todo with
    | [] -> false
    | f :: ll ->
      let res = f dt in
      if res then true
      else begin
        todo := ll;
        true
      end

(* On lance le jeu *)
let run config =
  Gfx.main_loop
    (chain_functions
       [ init_window; Texture.load_all; Texture.wait_all; init; update config ] )
