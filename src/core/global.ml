(* WINDOW *)
let window, init =
  let window_r = ref None in
  ( (fun () ->
      match !window_r with
      | Some w -> w
      | None -> failwith "Uninitialized window" )
  , fun str ->
      let w = Gfx.create str in
      window_r := Some w )

(* DIMENSION SCREEN *)
let height = 900

let width = 2 * height

(* FONT *)
let font = Gfx.load_font "monospace" "" 24

let big_font = Gfx.load_font "monospace" "" 256

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

(* GRAVITY *)
let gravity, set_gravity =
  let gravity_r = ref 0.015 in
  ((fun () -> !gravity_r), fun v -> gravity_r := v)
