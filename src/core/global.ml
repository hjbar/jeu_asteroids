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
  , fun str is_sdl ->
      let w = Gfx.create str in
      window_r := Some w;
      let factor = if is_sdl then 0.8 else 1. in
      let font_family =
        if is_sdl then "resources/fonts/roboto_mono/RobotoMono-Regular.ttf"
        else "monospace"
      in
      font :=
        Some (Gfx.load_font font_family "" (int_of_float @@ (24. *. factor)));
      big_font :=
        Some (Gfx.load_font font_family "" (int_of_float @@ (256. *. factor)))
  )

(* DIMENSION SCREEN *)
let height = 900

let width = 2 * height

(* WALL *)
let wall_l = 80

(* OVNI *)
let ovni_w, ovni_h =
  let factor = 2.5 in
  (int_of_float (19. *. factor), int_of_float (32. *. factor))

let god_mode = ref false

let get_ovni_speed, set_ovni_speed =
  let speed = ref 0.1 in
  ((fun () -> !speed), fun s -> speed := s)

(* ASTEROIDS *)
let asteroid_size = 60

let no_spawn = ref false

let bonus_drop_rate, set_bonus_only, reset_bonus_drop_rate =
  let drop_rate = ref 5 in
  ( (fun () -> !drop_rate)
  , (fun () -> drop_rate := 100)
  , fun () -> drop_rate := 5 )

(* GRAVITY *)
let gravity, set_gravity =
  let gravity_r = ref 0.015 in
  ((fun () -> !gravity_r), fun v -> gravity_r := v)

(* UNDER GRAVITY *)
let is_ast_under_gravity, put_gravity, remove_gravity =
  let levels = [| true; true; false |] in
  ( (fun lvl -> levels.(lvl))
  , (fun () -> levels.(2) <- true)
  , fun () -> levels.(2) <- false )
