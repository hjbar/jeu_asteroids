let common_bonus = [| (fun () -> ()) |]

let uncommon_bonus = [| (fun () -> ()) |]

let rare_bonus = [| (fun () -> ()) |]

let epic_bonus = [| (fun () -> ()) |]

let legendary_bonus = [| (fun () -> ()) |]

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
