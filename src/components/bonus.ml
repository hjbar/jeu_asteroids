(* Some types *)

type kind_bonus =
  | IncreaseNbLasers
  | IncreaseShootSpeed
  | SplitShoot
  | MarioKartStar
  | SpeedBoostCommon
  | SpeedBoostUncommon
  | SpeedBoostRare
  | UpgradeScore
  | DoubleScore
  | Nuke
  | IncrHp

type bonus_htbl = (kind_bonus, unit -> unit) Hashtbl.t

(* Some utils fucntions *)

let bonus_to_timer (bonus : kind_bonus) : Timer.kind_timer =
  match bonus with
  | SplitShoot -> SplitShoot
  | MarioKartStar -> MarioKartStar
  | SpeedBoostCommon -> SpeedBoostCommon
  | SpeedBoostUncommon -> SpeedBoostUncommon
  | SpeedBoostRare -> SpeedBoostRare
  | DoubleScore -> DoubleScore
  | Nuke -> Nuke
  | IncreaseNbLasers -> failwith "IncreaseNbLasers has no timer"
  | IncreaseShootSpeed -> failwith "IncreaseShootSpeed has no timer"
  | UpgradeScore -> failwith "UpgradeScore has no timer"
  | IncrHp -> failwith "IncrHp has no timer"

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

let common_speed_boost =
  let already_boost = ref false in
  fun () ->
    if not !already_boost then begin
      Global.set_ovni_speed (Global.get_ovni_speed () +. 0.035);
      already_boost := true
    end;
    let f () =
      Global.set_ovni_speed (Global.get_ovni_speed () -. 0.035);
      already_boost := false
    in
    Timer.add (bonus_to_timer SpeedBoostCommon) 180 f

let upgrade_score () = Scoring.add 1000.

let () =
  add_bonus_list common_bonus
    [ (SpeedBoostCommon, common_speed_boost); (UpgradeScore, upgrade_score) ]

(* uncommon_bonus *)

let uncommon_bonus : bonus_htbl = Hashtbl.create 16

let uncommon_speed_boost =
  let already_boost = ref false in
  fun () ->
    if not !already_boost then begin
      Global.set_ovni_speed (Global.get_ovni_speed () +. 0.035);
      already_boost := true
    end;
    let f () =
      Global.set_ovni_speed (Global.get_ovni_speed () -. 0.035);
      already_boost := false
    in
    Timer.add (bonus_to_timer SpeedBoostUncommon) 300 f

let double_score =
  let already_double = ref false in
  fun () ->
    if not !already_double then Scoring.set_factor 2.;
    let f () = Scoring.set_factor 1. in
    Timer.add (bonus_to_timer DoubleScore) 600 f

let () =
  add_bonus_list uncommon_bonus
    [ (SpeedBoostUncommon, uncommon_speed_boost); (DoubleScore, double_score) ]

(* rare_bonus *)

let rare_bonus : bonus_htbl = Hashtbl.create 16

let split_shoot () =
  if not !Laser.split_shoot then Laser.split_shoot := true;
  let f () = Laser.split_shoot := false in
  Timer.add (bonus_to_timer SplitShoot) 300 f

let rare_speed_boost () =
  Global.set_ovni_speed (Global.get_ovni_speed () +. 0.025)

let () =
  add_bonus_list rare_bonus
    [ (SplitShoot, split_shoot); (SpeedBoostRare, rare_speed_boost) ]

(* epic_bonus *)

let epic_bonus : bonus_htbl = Hashtbl.create 16

let nuke () =
  let l =
    Hashtbl.fold
      (fun key value acc -> (key, value) :: acc)
      Entities.asteroids#table []
  in
  List.iter
    (fun (key, value) ->
      Entities.asteroids#remove key;
      value#is_offscreen#set true )
    l;

  Global.no_spawn := true;
  let f () = Global.no_spawn := false in
  Timer.add (bonus_to_timer Nuke) 1 f

let incr_hp () = Ovni.incr_hp ()

let () = add_bonus_list epic_bonus [ (Nuke, nuke); (IncrHp, incr_hp) ]

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
    Ovni.set_under_gravity false;
    Ovni.set_invincibility true
  end;

  let f () =
    Scoring.reset_mk_star ();
    Ovni.set_under_gravity true;
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

  Audio.play Bonus;

  let f = chose_elt bonus in
  (f, texture)
