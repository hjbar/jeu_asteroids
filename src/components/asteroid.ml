open System_defs
open Component_defs

(* Générateur d'uid *)
let uid =
  let cpt = ref (-1) in
  fun () ->
    begin
      if !cpt >= 2048 then cpt := -1;
      incr cpt;
      !cpt
    end

(* Création d'asteroid *)
let rec create_asteroid x y id level =
  let l = Global.asteroid_size in
  let l =
    [| int_of_float (float l *. 0.6); int_of_float (float l *. 0.8); l |].(level)
  in
  let mass = [| 120.; 160.; 200. |].(level) in
  let drag = 0. in
  let rebound = 0.25 in

  let is_bonus = Random.int 100 < 500 in
  let f_bonus, kind_texture =
    if is_bonus then Bonus.get_bonus () else ((fun () -> ()), Asteroid)
  in

  let ctx = Gfx.get_context (Global.window ()) in
  let surface = Gfx.get_resource (Texture.get kind_texture) in
  let texture = Texture.image_from_surface ctx surface 0 0 32 32 l l in

  let ast = Box.create id x y l l mass drag rebound Asteroid texture in
  let f = ast#remove#get in
  ast#hp#set [| 1; 2; 4 |].(level);
  ast#level#set level;

  ast#under_gravity#set [| true; true; false |].(level);

  ast#remove#set (fun () ->
      f ();

      if ast#is_dead#get then begin
        f_bonus ();

        let lvl = ast#level#get - 1 in
        if lvl >= 0 && not !Global.no_spawn then
          let ast_size = Global.asteroid_size in

          let x = int_of_float ast#pos#get.x in
          let y = int_of_float ast#pos#get.y in

          let lvl = ast#level#get - 1 in

          let factor = [| 10.; 1. |].(lvl) in
          let vx = 0.5 /. factor in
          let vy = 1. /. factor in

          if lvl >= 0 then begin
            create_asteroid_with_sumforces (x - ast_size) (y - ast_size)
              (id ^ "_0")
              Vector.{ x = -1. *. vx; y = -0.75 *. vy }
              lvl;
            create_asteroid_with_sumforces (x + ast_size) (y - ast_size)
              (id ^ "_1")
              Vector.{ x = vx; y = -0.75 *. vy }
              lvl;
            create_asteroid_with_sumforces (x - ast_size) (y + ast_size)
              (id ^ "_2")
              Vector.{ x = -1. *. vx; y = vy }
              lvl;
            create_asteroid_with_sumforces (x + ast_size) (y + ast_size)
              (id ^ "_3")
              Vector.{ x = vx; y = vy }
              lvl
          end
      end );
  Entities.asteroids#replace id ast;
  ast

and create_asteroid_with_velocity x y id velocity level =
  let ast = create_asteroid x y id level in
  ast#velocity#set velocity

and create_asteroid_with_sumforces x y id sum_forces level =
  let ast = create_asteroid x y id level in
  ast#sum_forces#set sum_forces

(* Les différents paterns des asteroids *)
let pattern_1 () =
  let space = (Global.ovni_w / 2) + 10 + Global.asteroid_size in
  let nb = Global.width / space in
  let rand = Random.int nb in

  let speed =
    Vector.{ x = 0.; y = 3.75 +. (0.4 *. float (Scoring.get_wave ())) }
  in
  let speed = Vector.mult 0.25 speed in

  let x = ref ((10 + Global.asteroid_size) / 2) in
  for i = 0 to nb - 1 do
    if i <> rand then begin
      let id = Printf.sprintf "asteroids_%d" (uid ()) in
      create_asteroid_with_sumforces
        (!x + Random.int 5)
        (Random.int 25 - 25 - Global.asteroid_size)
        id speed 2
    end;
    x := !x + space
  done

let pattern_2 () =
  let decal () = (float (Random.int 50) -. 25.) /. 100. in
  let space = 2 * Global.asteroid_size in
  let nb = Global.width / space in

  let factor = 8. +. (0.4 *. float (Scoring.get_wave ())) in

  let x1 = ref (-Global.width / 2) in
  let y1 = ref (-Global.height / 4) in

  let x2 = ref (Global.width + (Global.width / 8)) in
  let y2 = ref (-Global.height / 2) in

  for _ = 1 to nb do
    let id1 = Printf.sprintf "asteroids_%d" (uid ()) in
    let speed1 =
      Vector.mult
        (factor +. decal ())
        (Vector.normalize Vector.{ x = 1.; y = 1. })
    in
    let speed1 = Vector.mult 0.25 speed1 in

    create_asteroid_with_sumforces !x1 !y1 id1 speed1 2;

    let id2 = Printf.sprintf "asteroids_%d" (uid ()) in
    let speed2 =
      Vector.mult
        (factor +. decal ())
        (Vector.normalize Vector.{ x = -3.; y = 1. })
    in
    let speed2 = Vector.mult 0.25 speed2 in

    create_asteroid_with_sumforces !x2 !y2 id2 speed2 2;

    x1 := !x1 + space;
    x2 := !x2 + space;
    y2 := !y2 + space
  done

let pattern_3 () =
  let space = (Global.ovni_w / 2) + 10 + Global.asteroid_size in
  let nb = Global.width / space in
  let rand = Random.int 2 in
  let x = ref ((10 + Global.asteroid_size) / 2) in
  for i = 0 to nb - 1 do
    let id = Printf.sprintf "asteroids_%d" (uid ()) in
    let speed =
      Vector.
        { x = 0.
        ; y =
            (if i mod 2 = rand then 3.75 else 7.5)
            +. (0.4 *. float (Scoring.get_wave ()))
            +. Random.float 2.0
        }
    in
    let speed = Vector.mult 0.25 speed in

    create_asteroid_with_sumforces
      (!x + Random.int 5)
      (Random.int 25 - 25 - Global.asteroid_size)
      id speed 2;
    x := !x + space
  done

let pattern_4 () =
  let space = (Global.ovni_w / 2) + 10 + Global.asteroid_size in
  let width = (5 * space) + 10 in
  let x = ref (Random.int ((Global.width / 2) - width)) in
  for v = 0 to 1 do
    for i = 0 to 4 do
      let id = Printf.sprintf "asteroids_%d" (uid ()) in
      let speed1 =
        Vector.{ x = 0.; y = 3.75 +. (0.4 *. float (Scoring.get_wave ())) }
      in
      let speed1 = Vector.mult 0.25 speed1 in

      create_asteroid_with_sumforces (!x + (i * space)) (-space * 4) id speed1 2
    done;
    x := !x + (2 * space);
    for i = 0 to 2 do
      let id = Printf.sprintf "asteroids_%d" (uid ()) in
      let speed2 =
        Vector.{ x = 0.; y = 3.75 +. (0.4 *. float (Scoring.get_wave ())) }
      in
      let speed2 = Vector.mult 0.25 speed2 in

      create_asteroid_with_sumforces !x
        ((-space * 4) + ((i + 1) * space))
        id speed2 2
    done;
    x := Random.int ((Global.width / 2) - width) + (Global.width / 2)
  done

(* Z pattern *)
let pattern_5 () =
  let size = Global.asteroid_size in
  let factor = 7 in

  let space = (Global.ovni_w / 2) + 10 + size in
  let nb = Global.width / space in
  let limit = 1 + Random.int (nb - 2) in

  let speed =
    Vector.{ x = 0.; y = 3.75 +. (0.4 *. float (Scoring.get_wave ())) }
  in
  let speed = Vector.mult 0.25 speed in

  let x = ref ((10 + size) / 2) in
  for i = 0 to nb - 1 do
    if i = limit then begin
      let decal_top = ref (size + (factor * size)) in
      let decal_bot = ref size in
      for j = 0 to factor / 4 do
        let id1 = Printf.sprintf "asteroids_%d_1_%d" (uid ()) j in

        create_asteroid_with_sumforces
          (!x + Random.int 10 - 5)
          (Random.int 5 - !decal_top - size)
          id1 speed 2;

        decal_top := !decal_top - size - 25;

        let id2 = Printf.sprintf "asteroids_%d_2_%d" (uid ()) j in

        create_asteroid_with_sumforces
          (!x + Random.int 10 - 5)
          (Random.int 5 - !decal_bot - size)
          id2 speed 2;

        decal_bot := !decal_bot + size + 25
      done
    end
    else begin
      let id = Printf.sprintf "asteroids_%d" (uid ()) in
      let decal = size + if i < limit then factor * size else 0 in

      create_asteroid_with_sumforces
        (!x + Random.int 5)
        (Random.int 25 - decal - size)
        id speed 2
    end;

    x := !x + space
  done

let paterns = [| pattern_1; pattern_2; pattern_3; pattern_4; pattern_5 |]

(* Lance l'init des asteroids *)
let init_asteroids () =
  Scoring.incr_wave ();
  let rand = Random.int (Array.length paterns) in
  paterns.(rand) ()

(* Maj les asteorids *)
let remove_old_asteroids =
  let valid_pos =
    Box.invisible "valid_pos" (-Global.width / 2) (-Global.height)
      (2 * Global.width) (2 * Global.height)
  in

  let bot_mid_screen =
    Box.invisible "bot_mid_screen" 0
      (3 * Global.height / 4)
      Global.width (Global.height / 4)
  in

  (* si collision avec zone d'affichage, alors ils sont encore visibles donc on les garde
     sinon ils sont hors écrans et on les vire *)
  fun () ->
    if !Global.no_spawn then ()
    else begin
      let asteroids_required =
        min (max 1 (int_of_float (Global.gravity ()))) 32
      in

      let cpt = ref Entities.asteroids#length in
      let old =
        Hashtbl.fold
          (fun k v init ->
            if
              Rect.intersect v#pos#get v#rect#get bot_mid_screen#pos#get
                bot_mid_screen#rect#get
            then decr cpt;

            if
              Rect.intersect v#pos#get v#rect#get valid_pos#pos#get
                valid_pos#rect#get
            then init
            else (k, v) :: init )
          Entities.asteroids#table []
      in
      List.iter
        (fun (k, v) ->
          Entities.asteroids#remove k;
          v#is_offscreen#set true )
        old;
      if !cpt < asteroids_required then init_asteroids ()
    end
