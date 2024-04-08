(* Some types *)

type kind_bonus =
  | UnknownBonus
  | IncreaseNbLasers
  | IncreaseShootSpeed
  | SplitShoot
  | MarioKartStar

type bonus_htbl = (kind_bonus, unit -> unit) Hashtbl.t

(* Some utils fucntions *)
let bonus_to_timer (bonus : kind_bonus) : Timer.kind_timer =
  match bonus with
  | SplitShoot -> SplitShoot
  | MarioKartStar -> MarioKartStar
  | IncreaseNbLasers -> failwith " IncreaseNbLasers  has no timer"
  | IncreaseShootSpeed -> failwith "IncreaseShootSpeed has no timer"
  | UnknownBonus -> failwith "Unknown bonus"

let add_bonus_list ht l =
  List.iter (fun (kind, f) -> Hashtbl.replace ht kind f) l

let chose_elt ht =
  let opt =
    Hashtbl.fold
      (fun _key value acc ->
        if Random.int 2 = 0 || Option.is_none acc then Some value else acc )
      ht None
  in
  match opt with None -> failwith "Any bonus available" | Some f -> f

(* common_bonus *)

let common_bonus : bonus_htbl = Hashtbl.create 16

let () = add_bonus_list common_bonus [ (UnknownBonus, fun () -> ()) ]

(* uncommon_bonus *)

let uncommon_bonus : bonus_htbl = Hashtbl.create 16

let () = add_bonus_list uncommon_bonus [ (UnknownBonus, fun () -> ()) ]

(* rare_bonus *)

let rare_bonus : bonus_htbl = Hashtbl.create 16

let split_shoot () =
  if not !Laser.split_shoot then Laser.split_shoot := true;
  let f () = Laser.split_shoot := false in
  Timer.add (bonus_to_timer SplitShoot) 300 f

let () = add_bonus_list rare_bonus [ (SplitShoot, split_shoot) ]

(* epic_bonus *)

let epic_bonus : bonus_htbl = Hashtbl.create 16

let () = add_bonus_list epic_bonus [ (UnknownBonus, fun () -> ()) ]

(* legendary_bonus *)

let legendary_bonus : bonus_htbl = Hashtbl.create 16

let increase_nb_lasers () =
  incr Laser.nb_lasers;
  if !Laser.nb_lasers >= 6 then begin
    Laser.nb_lasers := min 6 !Laser.nb_lasers;
    Hashtbl.remove legendary_bonus IncreaseNbLasers
  end

let increase_shoot_speed () =
  Ovni.delay := !Ovni.delay - 3;
  if !Ovni.delay <= 9 then begin
    Ovni.delay := max 9 !Ovni.delay;
    Hashtbl.remove legendary_bonus IncreaseShootSpeed
  end

let mario_kart_star () =
  if not (Scoring.mk_star ()) then begin
    Scoring.active_mk_star ();
    Global.active_mk_star_speed ();
    Ovni.set_invincibility true
  end;

  let f () =
    Scoring.reset_mk_star ();
    Global.reset_mk_star_speed ();
    Ovni.set_invincibility false
  in

  Timer.add (bonus_to_timer MarioKartStar) 600 f

let () =
  add_bonus_list legendary_bonus
    [ (IncreaseNbLasers, increase_nb_lasers)
    ; (IncreaseShootSpeed, increase_shoot_speed)
    ; (MarioKartStar, mario_kart_star)
    ]

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

  let f = chose_elt bonus in
  (f, texture)
