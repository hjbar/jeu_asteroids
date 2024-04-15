(* FONT *)
let font = ref None

let big_font = ref None

(* WINDOW *)
let window, init =
  let window_r = ref None in
  ( (fun () ->
      match !window_r with
      | Some w -> w
      | None -> failwith "Uninitialized window" )
  , fun str is_sdl->
      let w = Gfx.create str in
      window_r := Some w;
      let factor = if is_sdl then 2 else 1 in
      let font_family = if is_sdl then "resources/fonts/roboto_mono/RobotoMono-Regular.ttf" else "monospace" in
      font := Some (Gfx.load_font font_family "" (24*factor));
      big_font := Some (Gfx.load_font font_family "" (256*factor));)

(* DIMENSION SCREEN *)
let height = 900

let width = 2 * height

(* WALL *)
let wall_l = 80

(* OVNI *)
let ovni_w, ovni_h =
  let factor = 2.5 in
  (int_of_float (19. *. factor), int_of_float (32. *. factor))

let get_ovni_speed, set_ovni_speed =
  let speed = ref 0.1 in
  ((fun () -> !speed), fun s -> speed := s)

(* ASTEROIDS *)
let asteroid_size = 60

let no_spawn = ref false

(* GRAVITY *)
let gravity, set_gravity =
  let gravity_r = ref 0.015 in
  ((fun () -> !gravity_r), fun v -> gravity_r := v)
