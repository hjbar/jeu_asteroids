type kind_timer =
  | OvniDelayShoot
  | OvniInvicible
  | SplitShoot
  | MarioKartStar

type typ_timer =
  { mutable time : int
  ; f : unit -> unit
  }

val add : kind_timer -> int -> (unit -> unit) -> unit

val update_all : unit -> unit
