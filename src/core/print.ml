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
  Gfx.blit ctx (Gfx.get_surface (Global.window ())) s 10 70

  (* bonuses *)
  

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
