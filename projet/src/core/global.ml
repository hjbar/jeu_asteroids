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
let ovni_l = 50

(* GRAVITY *)
let gravity, set_gravity =
  let gravity_r = ref 0.015 in
  ((fun () -> !gravity_r), fun v -> gravity_r := v)

(* SCORING *)
let scoring, increase_scoring =
  let scoring_r = ref 0. in
  ((fun () -> !scoring_r), fun n -> scoring_r := !scoring_r +. n)

(* WAVE COUNTER *)
let get_wave, incr_wave =
  let wc = ref 0 in
  ((fun () -> !wc), fun () -> incr wc)

(* HASHTABL TEXTURES *)
type kind_texture =
  | Ovni
  | Asteroid
  | Bullet

let get_texture, set_texture, textures_are_ready =
  let (htbl : (kind_texture, Gfx.surface Gfx.resource) Hashtbl.t) =
    Hashtbl.create 16
  in
  ( (fun s -> Hashtbl.find htbl s)
  , (fun s t -> Hashtbl.replace htbl s t)
  , fun () ->
      Hashtbl.fold
        (fun _key value acc -> acc || not (Gfx.resource_ready value))
        htbl false )

(* HP *)
let get_hp, alive, incr_hp, decr_hp =
  let hp = ref 5 in
  ( (fun () -> !hp)
  , (fun () -> !hp > 0)
  , (fun () -> incr hp)
  , let dt0 = ref 0. in
    fun dt ->
      if dt -. !dt0 > 2000. then begin
        decr hp;
        dt0 := dt
      end )
