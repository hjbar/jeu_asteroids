let print () =
  (* hp *)
  let ctx = Gfx.get_context (Global.window ()) in
  Gfx.set_color ctx (Gfx.color 12 89 186 255);
  let s =
    Gfx.render_text ctx
      (Printf.sprintf "Points de vie : %d" (Ovni.get_hp ()))
      Global.font
  in
  Gfx.blit ctx (Gfx.get_surface (Global.window ())) s 10 10;

  (* score *)
  let s =
    Gfx.render_text ctx
      (Printf.sprintf "Score : %.2f" (Scoring.get ()))
      Global.font
  in
  Gfx.blit ctx (Gfx.get_surface (Global.window ())) s 10 35;

  (* wave count *)
  let s =
    Gfx.render_text ctx
      (Printf.sprintf "Vague numéro : %d" (Scoring.get_wave ()))
      Global.font
  in
  Gfx.blit ctx (Gfx.get_surface (Global.window ())) s 10 60

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
