(* common_bonus *)

let common_bonus = [| (fun () -> ()) |]

(* uncommon_bonus *)

let uncommon_bonus = [| (fun () -> ()) |]

(* rare_bonus *)

let rare_bonus = [| (fun () -> ()) |]

(* epic_bonus *)

let epic_bonus = [| (fun () -> ()) |]

(* legendary_bonus *)

let increase_nb_lasers () = Laser.nb_lasers := min 8 (!Laser.nb_lasers + 1)

let increase_shoot_speed () = Ovni.delay := max 5 (!Ovni.delay - 3)

let legendary_bonus = [| increase_nb_lasers; increase_shoot_speed |]

(* get_bonus *)

let get_bonus () =
  let nb = Random.int 100 in

  let bonus, texture =
    if nb < 5 then
      (* 5% legendary *)
      (legendary_bonus, Texture.Asteroid_legendary)
    else if nb < 15 then (* 10% epic *)
      (epic_bonus, Texture.Asteroid_epic)
    else if nb < 30 then (* 15% rare *)
      (rare_bonus, Texture.Asteroid_rare)
    else if nb < 60 then
      (* 30% uncommon *)
      (uncommon_bonus, Texture.Asteroid_uncommon)
    else (* 40% common *)
      (common_bonus, Texture.Asteroid_common)
  in

  let rd = Random.int (Array.length bonus) in
  (bonus.(rd), texture)
