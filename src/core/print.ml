let print () =
  let ctx = Gfx.get_context (Global.window ()) in
  Gfx.set_color ctx (Gfx.color 255 255 255 255);

  (* hp *)
  let icon = Gfx.get_resource (Texture.get Icon_heart) in
  Gfx.blit_full ctx
    (Gfx.get_surface (Global.window ()))
    icon 0 0 32 32 10 10 24 24;

  let s =
    Gfx.render_text ctx
      (Printf.sprintf "%d" (Ovni.get_hp ()))
      (Option.get !Global.font)
  in
  Gfx.blit ctx (Gfx.get_surface (Global.window ())) s 44 10;

  (* score *)
  let s =
    Gfx.render_text ctx
      (Printf.sprintf "%.2f" (Scoring.get ()))
      (Option.get !Global.font)
  in
  Gfx.blit ctx (Gfx.get_surface (Global.window ())) s 120 10;

  (* shoot rate *)
  let icon = Gfx.get_resource (Texture.get Icon_nb_lasers) in
  Gfx.blit_full ctx
    (Gfx.get_surface (Global.window ()))
    icon 0 0 32 32 10 40 24 24;

  let s =
    Gfx.render_text ctx
      (Printf.sprintf "%.2f/s"
         (float !Laser.nb_lasers *. (60. /. float !Ovni.delay)) )
      (Option.get !Global.font)
  in
  Gfx.blit ctx (Gfx.get_surface (Global.window ())) s 44 40;

  (* wave count *)
  let s =
    Gfx.render_text ctx
      (Printf.sprintf "Vague numéro : %d" (Scoring.get_wave ()))
      (Option.get !Global.font)
  in
  Gfx.blit ctx (Gfx.get_surface (Global.window ())) s 10 70;

  (* bonuses *)
  let f i ((v, t) : Timer.kind_timer * int) =
    let (resource : Texture.kind_texture) =
      match v with
      | SplitShoot -> Icon_split_shoot
      | MarioKartStar -> Icon_star
      | SpeedBoostCommon -> Icon_speed_boost_common
      | SpeedBoostUncommon -> Icon_speed_boost_uncommon
      | SpeedBoostRare -> Icon_speed_boost_rare
      | DoubleScore -> Icon_2x
      | Nuke -> Icon_bomb
      | _ -> failwith "wont happen"
    in
    let size = 48 in
    let x = Global.width - 60 in
    let y = 10 + ((size + 10) * i) in
    let icon = Gfx.get_resource (Texture.get resource) in
    Gfx.blit_full ctx
      (Gfx.get_surface (Global.window ()))
      icon 0 0 32 32 (x - 75) y size size;
    let s =
      Gfx.render_text ctx
        (Printf.sprintf "%ds" ((t / 60) + 1))
        (Option.get !Global.font)
    in
    Gfx.blit ctx (Gfx.get_surface (Global.window ())) s x (y + (size / 4))
  in
  List.iteri (fun i v -> f i v) (Timer.active_bonuses ());

  let size = 48 in
  (* GOD MODE *)
  if !Global.god_mode then begin
    let icon = Gfx.get_resource (Texture.get Icon_god_mode) in
    let x = Global.width - 10 - size in
    let y = Global.height - 10 - size in
    Gfx.blit_full ctx
      (Gfx.get_surface (Global.window ()))
      icon 0 0 32 32 x y size size
  end;

  (* FULL BONUS *)
  if Global.bonus_drop_rate () = 100 then begin
    let icon = Gfx.get_resource (Texture.get Icon_background) in
    let x = Global.width - 10 - size in
    let y = Global.height - (2 * 10) - (2 * size) in
    Gfx.blit_full ctx
      (Gfx.get_surface (Global.window ()))
      icon 0 0 32 32 x y size size;
    let icon = Gfx.get_resource (Texture.get Asteroid_rare) in
    Gfx.blit_full ctx
      (Gfx.get_surface (Global.window ()))
      icon 0 0 32 32 (x + 4) (y + 8) (size - 18) (size - 18);
    let icon = Gfx.get_resource (Texture.get Asteroid_epic) in
    Gfx.blit_full ctx
      (Gfx.get_surface (Global.window ()))
      icon 0 0 32 32 (x + 8) (y + 8) (size - 18) (size - 18);
    let icon = Gfx.get_resource (Texture.get Asteroid_legendary) in
    Gfx.blit_full ctx
      (Gfx.get_surface (Global.window ()))
      icon 0 0 32 32 (x + 12) (y + 8) (size - 18) (size - 18)
  end;
  Gfx.commit ctx

let pause_screen () =
  let img = Gfx.get_resource (Texture.get Pause_screen) in
  let ctx = Gfx.get_context (Global.window ()) in
  Gfx.blit_full ctx
    (Gfx.get_surface (Global.window ()))
    img 0 0 2048 1024 0 0 Global.width Global.height;
  Gfx.commit ctx

let game_over () =
  let ctx = Gfx.get_context (Global.window ()) in
  Gfx.set_color ctx (Gfx.color 22 196 53 255);
  let txt = Printf.sprintf "%.2f" (Scoring.get ()) in
  let s = Gfx.render_text ctx txt (Option.get !Global.big_font) in
  let w, h = Gfx.measure_text txt (Option.get !Global.big_font) in
  let x = (Global.width - w) / 2 in
  let y = ((Global.height - h) / 2) + 40 in

  Audio.play Defeat;
  let img = Gfx.get_resource (Texture.get Final_screen) in
  Gfx.blit_full ctx
    (Gfx.get_surface (Global.window ()))
    img 0 0 2048 1024 0 0 Global.width Global.height;
  Gfx.blit ctx (Gfx.get_surface (Global.window ())) s x y;
  Gfx.commit ctx
