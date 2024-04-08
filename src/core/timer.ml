type kind_timer =
  | OvniDelayShoot
  | OvniInvicible
  | SplitShoot
  | MarioKartStar
  | SpeedBoostCommon
  | SpeedBoostUncommon
  | SpeedBoostRare
  | DoubleScore

type typ_timer =
  { mutable time : int
  ; f : unit -> unit
  }

let timers : (kind_timer, typ_timer) Hashtbl.t = Hashtbl.create 16

let add kind time f =
  match Hashtbl.find_opt timers kind with
  | None -> Hashtbl.replace timers kind { time; f }
  | Some t -> Hashtbl.replace timers kind { time = time + t.time; f }

let update_all () =
  let to_remove =
    Hashtbl.fold
      (fun key value acc ->
        value.time <- value.time - 1;
        if value.time <= 0 then key :: acc else acc )
      timers []
  in

  List.iter
    (fun kind ->
      (Hashtbl.find timers kind).f ();
      Hashtbl.remove timers kind )
    to_remove

let active_bonuses () =
  Hashtbl.fold
    (fun k v init ->
      match k with
      | OvniDelayShoot | OvniInvicible -> init
      | b -> (b, v.time) :: init )
    timers []
