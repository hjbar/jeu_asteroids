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

(* Stuff pour créer les textures *)
type kind_texture =
  | Ovni
  | Ovni_invincible
  | Ovni_star
  | Asteroid
  | Asteroid_common
  | Asteroid_uncommon
  | Asteroid_rare
  | Asteroid_epic
  | Asteroid_legendary
  | Laser
  | Background
  | Background_bomb
  | Icon_heart
  | Icon_nb_lasers
  | Icon_split_shoot
  | Icon_star
  | Icon_speed_boost_common
  | Icon_speed_boost_uncommon
  | Icon_speed_boost_rare
  | Icon_2x
  | Icon_bomb

let textures = Hashtbl.create 16

let get kind_texture = Hashtbl.find textures kind_texture

(* Fonctions pour load les textures *)
let load_all _dt =
  let ctx = Gfx.get_context (Global.window ()) in

  Hashtbl.replace textures Ovni (Gfx.load_image ctx "resources/anims/fusee.png");
  Hashtbl.replace textures Ovni_invincible (Gfx.load_image ctx "resources/anims/fusee_invincible.png");
  Hashtbl.replace textures Ovni_star (Gfx.load_image ctx "resources/anims/fusee_star.png");

  Hashtbl.replace textures Asteroid
    (Gfx.load_image ctx "resources/images/asteroid.png");
  Hashtbl.replace textures Asteroid_common
    (Gfx.load_image ctx "resources/images/asteroid_common.png");
  Hashtbl.replace textures Asteroid_uncommon
    (Gfx.load_image ctx "resources/images/asteroid_uncommon.png");
  Hashtbl.replace textures Asteroid_rare
    (Gfx.load_image ctx "resources/images/asteroid_rare.png");
  Hashtbl.replace textures Asteroid_epic
    (Gfx.load_image ctx "resources/images/asteroid_epic.png");
  Hashtbl.replace textures Asteroid_legendary
    (Gfx.load_image ctx "resources/images/asteroid_legendary.png");

  Hashtbl.replace textures Laser
    (Gfx.load_image ctx "resources/anims/laser.png");

  Hashtbl.replace textures Background
    (Gfx.load_image ctx "resources/images/background.png");
  Hashtbl.replace textures Background_bomb
    (Gfx.load_image ctx "resources/images/background_bomb.png");

  Hashtbl.replace textures Icon_heart
    (Gfx.load_image ctx "resources/images/icon_heart.png");
  Hashtbl.replace textures Icon_nb_lasers
    (Gfx.load_image ctx "resources/images/icon_nb_lasers.png");
  Hashtbl.replace textures Icon_split_shoot
    (Gfx.load_image ctx "resources/images/icon_split_shoot.png");
  Hashtbl.replace textures Icon_star
    (Gfx.load_image ctx "resources/images/icon_star.png");
  Hashtbl.replace textures Icon_speed_boost_common
    (Gfx.load_image ctx "resources/images/icon_speed_common.png");
  Hashtbl.replace textures Icon_speed_boost_uncommon
    (Gfx.load_image ctx "resources/images/icon_speed_uncommon.png");
  Hashtbl.replace textures Icon_speed_boost_rare
    (Gfx.load_image ctx "resources/images/icon_speed_rare.png");
    Hashtbl.replace textures Icon_2x
      (Gfx.load_image ctx "resources/images/icon_2x.png");
      Hashtbl.replace textures Icon_bomb
        (Gfx.load_image ctx "resources/images/icon_bomb.png");

  false

let wait_all _dt =
  Hashtbl.fold
    (fun _key value acc -> acc || not (Gfx.resource_ready value))
    textures false
