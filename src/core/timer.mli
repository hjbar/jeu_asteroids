type kind_timer =
  | OvniDelayShoot
  | OvniInvicible
  | SplitShoot
  | MarioKartStar
  | SpeedBoostCommon
  | SpeedBoostUncommon
  | SpeedBoostRare

type typ_timer =
  { mutable time : int
  ; f : unit -> unit
  }

val add : kind_timer -> int -> (unit -> unit) -> unit

val update_all : unit -> unit

val active_bonuses : unit -> (kind_timer * int) list