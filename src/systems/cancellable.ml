open Component_defs

type t = offscreenable_box

let init _ = ()

let update dt el =
  let l = ref [] in
  Seq.iter
    (fun (e1 : t) -> if e1#is_offscreen#get || e1#is_dead#get then l := e1 :: !l)
    el;
  List.iter (fun (e1 : t) -> e1#remove#get ()) !l
