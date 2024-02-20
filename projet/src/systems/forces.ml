open Component_defs

type t = collidable

let init _ = ()

let delta = 1000. /. 60.

let update _ el =
  Seq.iter
    (fun m ->
      let mass = m#mass#get in
      if Float.is_finite mass then begin
        let f = m#sum_forces#get in
        let gravity = Vector.{ x = 0.0; y = Global.gravity () } in
        let f = Vector.add f gravity in
        m#sum_forces#set Vector.zero;
        let a = Vector.mult (1. /. mass) f in
        let delta_v = Vector.mult delta a in
        m#velocity#set
          (Vector.mult (1. -. m#drag#get) (Vector.add delta_v m#velocity#get))
      end )
    el
