open Component_defs

type t = drawable

let init _ = ()

let white = Gfx.color 255 255 255 255

let black = Gfx.color 0 0 0 255

let background = Gfx.color 22 18 41 255

let draw ctx win_surf (e : t) =
  let Vector.{ x; y } = e#pos#get in
  let x = int_of_float x in
  let y = int_of_float y in
  let Rect.{ width; height } = e#rect#get in
  match e#texture#get with
  | Texture.Color color ->
    Gfx.set_color ctx color;
    Gfx.fill_rect ctx win_surf x y width height
  | Texture.Image surface ->
    Gfx.blit_scale ctx win_surf surface x y width height
  | Texture.Animation r ->
    r.current_time <- r.current_time - 1;
    if r.current_time = 0 then begin
      r.current_time <- r.frame_duration;
      r.current_frame <- (r.current_frame + 1) mod Array.length r.frames
    end;
    let surface = r.frames.(r.current_frame) in
    Gfx.blit_scale ctx win_surf surface x y width height

let update _dt el =
  let window = Global.window () in
  let ctx = Gfx.get_context window in
  let win_surf = Gfx.get_surface window in

  begin
    match !Entities.background with
    | None -> failwith "background not init"
    | Some b -> draw ctx win_surf b
  end;

  Seq.iter (draw ctx win_surf) el;

  if !Global.no_spawn then begin
    match !Entities.nuclear_background with
    | None -> failwith "nuclear_background not init"
    | Some b -> draw ctx win_surf b
  end;

  Gfx.commit ctx
