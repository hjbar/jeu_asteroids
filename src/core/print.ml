let print () =
  let ctx = Gfx.get_context (Global.window ()) in
  Gfx.set_color ctx (Gfx.color 255 255 255 255);

  (* hp *)
  let icon = Gfx.get_resource (Texture.get Icon_heart) in
  Gfx.blit_full ctx (Gfx.get_surface (Global.window ())) icon 0 0 32 32 10 10 24 24;
  
  let s =
    Gfx.render_text ctx
      (Printf.sprintf "%d" (Ovni.get_hp ()))
      Global.font
  in
  Gfx.blit ctx (Gfx.get_surface (Global.window ())) s 44 10;
  
  (* score *)
  let s =
    Gfx.render_text ctx
      (Printf.sprintf "%.2f" (Scoring.get ()))
      Global.font
  in
  Gfx.blit ctx (Gfx.get_surface (Global.window ())) s 120 10;

  (* shoot rate *)
  let icon = Gfx.get_resource (Texture.get Icon_nb_lasers) in
  Gfx.blit_full ctx (Gfx.get_surface (Global.window ())) icon 0 0 32 32 10 40 24 24;
  
  let s =
    Gfx.render_text ctx
      (Printf.sprintf "%.2f/s" (float !Laser.nb_lasers *. (60. /. float !Ovni.delay)))
      Global.font
  in
  Gfx.blit ctx (Gfx.get_surface (Global.window ())) s 44 40;

  (* wave count *)
  let s =
    Gfx.render_text ctx
      (Printf.sprintf "Vague numéro : %d" (Scoring.get_wave ()))
      Global.font
  in
  Gfx.blit ctx (Gfx.get_surface (Global.window ())) s 10 70;

  (* bonuses *)
  let f i ((v, t): Timer.kind_timer * int) =
    let (resource : Texture.kind_texture) = match v with
    | SplitShoot -> Icon_split_shoot
    | MarioKartStar -> Icon_star
    | SpeedBoostCommon -> Icon_speed_boost_common
    | SpeedBoostUncommon -> Icon_speed_boost_uncommon
    | SpeedBoostRare -> Icon_speed_boost_rare
    | _ -> failwith "wont happen"
  in
    let size = 48 in
    let x = (Global.width - (60)) in
    let y = (10 + (size + 10)*i) in
    let icon = Gfx.get_resource (Texture.get resource) in
    Gfx.blit_full ctx (Gfx.get_surface (Global.window ())) icon 0 0 32 32 (x-75) y size size;
    let s =
      Gfx.render_text ctx
        (Printf.sprintf "%ds" (t / 60 + 1))
        Global.font
    in
    Gfx.blit ctx (Gfx.get_surface (Global.window ())) s x (y+size/4);
  in
  List.iteri (fun i v -> f i v) (Timer.active_bonuses ())

let game_over () =
  let ctx = Gfx.get_context (Global.window ()) in
  Gfx.set_color ctx (Gfx.color 196 26 242 255);
  let txt = "TROP NUL !" in
  let s = Gfx.render_text ctx txt Global.big_font in
  let w, h = Gfx.measure_text txt Global.big_font in
  let x = (Global.width - w) / 2 in
  let y = (Global.height - h) / 2 in
  Gfx.blit ctx (Gfx.get_surface (Global.window ())) s x y;
  Gfx.commit ctx
