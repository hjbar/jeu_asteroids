(* Type des textures *)
type t =
  | Color of Gfx.color
  | Image of Gfx.surface
  | Animation of
      { frames : Gfx.surface array
      ; frame_duration : int
      ; mutable current_frame : int
      ; mutable current_time : int
      }

(* Fonctions pour créer des textures *)
let color c = Color c

let image_from_surface ctx surface x y w h dw dh =
  let dst = Gfx.create_surface ctx dw dh in
  Gfx.blit_full ctx dst surface x y w h 0 0 dw dh;
  Image dst

let anim_from_surface ctx surface n w h dw dh frame_duration =
  let frames =
    Array.init n (fun i ->
        let dst = Gfx.create_surface ctx dw dh in
        Gfx.blit_full ctx dst surface (i * w) 0 w h 0 0 dw dh;
        dst )
  in
  Animation
    { frames; frame_duration; current_time = frame_duration; current_frame = 0 }

(* Fonctions pour load les textures *)

let load_all _dt =
  Gfx.debug "debut load_all\n%!";

  let ctx = Gfx.get_context (Global.window ()) in

  Global.set_texture Ovni (Gfx.load_image ctx "resources/anims/fusee.png");
  Global.set_texture Laser (Gfx.load_image ctx "resources/anims/laser.png");
  Global.set_texture Asteroid
    (Gfx.load_image ctx "resources/images/asteroid.png");

  Gfx.debug "fin load_all\n%!";

  false

let wait_all _dt = Global.textures_are_ready ()
