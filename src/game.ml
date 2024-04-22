open Keys

(* On crée une fenêtre *)
let init_window is_sdl _dt =
  Global.init
    (Format.sprintf "game_canvas:%dx%d:r=presentvsync" Global.width
       Global.height )
    is_sdl;
  false

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
  if is_break config then Global.break := true;

  if not_break config then Global.break := false;

  (* On choisit quoi faire selon l'état du jeu *)
  if is_quit config then begin
    Print.game_over ();
    false
  end
  else if !Global.break then begin
    Print.pause_screen ();
    true
  end
  else begin
    (* On update le jeu *)
    Keys.update config;
    Asteroid.remove_old_asteroids ();
    Laser.remove_old_lasers ();
    Scoring.update ();
    Timer.update_all ();
    Background.update ();
    Ecs.System.update_all dt;
    Print.print ();

    (* On vérifie si on doit continuer *)
    let res = if Ovni.is_alive () then true
    else begin
      Print.game_over ();
      false
    end in
    Gfx.commit (Gfx.get_context (Global.window ()));
    res
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
    ; (Defeat, "resources/sounds/loose.wav")
    ; (Damage, "resources/sounds/damage.wav")
    ; (Bomb, "resources/sounds/bomb.wav")
    ];
  false

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
