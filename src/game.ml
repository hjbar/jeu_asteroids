(* Game state *)
let break = ref false

(* On crée une fenêtre *)
let init_window is_sdl _dt =
  Global.init
    (Format.sprintf "game_canvas:%dx%d:r=presentvsync" Global.width
       Global.height )
    is_sdl;
  false

(* On crée la config *)
type config =
  { up : string
  ; down : string
  ; left : string
  ; right : string
  ; space : string
  ; ctrl : string
  ; enter : string
  ; break : string
  ; quit : string
  ; un : string
  ; deux : string
  ; quatre : string
  ; cinq : string
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

  (* On vérifie si on doit mettre le jeu en pause *)
  if has_key config.ctrl && has_key config.break then break := true;

  if has_key config.ctrl && has_key config.enter then break := false;

  (* On choisit quoi faire selon l'état du jeu *)
  if has_key config.ctrl && has_key config.quit then false
  else if !break then true
  else begin
    (* On regarde si on doit activer un mode *)
    if has_key config.ctrl && has_key config.un then Global.god_mode := true;

    if has_key config.ctrl && has_key config.quatre then
      Global.god_mode := false;

    if has_key config.ctrl && has_key config.deux then Global.set_bonus_only ();

    if has_key config.ctrl && has_key config.cinq then
      Global.reset_bonus_drop_rate ();

    (* On update les mouvements *)
    let dx = ref 0. in
    let dy = ref 0. in

    let v = Global.get_ovni_speed () in

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

    (* On vérifie si on doit continuer *)
    if Ovni.is_alive () then true
    else (
      Print.game_over ();
      false )
  end

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

(* La liste des sons utilisés *)
let init_audio _ =
  Audio.init
    [ (Laser, "resources/sounds/laser.wav")
    ; (Explosion, "resources/sounds/explosion.wav")
    ; (Bonus, "resources/sounds/bonus.wav")
    ; (Defeat, "resources/sounds/laser.wav")
    ]

(* On lance le jeu *)
let run is_sdl config =
  Gfx.main_loop
    (chain_functions
       [ init_audio
       ; init_window is_sdl
       ; Texture.load_all
       ; Texture.wait_all
       ; init
       ; update config
       ] )
