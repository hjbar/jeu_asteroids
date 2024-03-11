let get, update =
  let scoring = ref 0. in
  ( (fun () -> !scoring)
  , fun () -> scoring := !scoring +. (10. *. Global.gravity ()) )

let get_wave, incr_wave =
  let wc = ref 0 in
  ((fun () -> !wc), fun () -> incr wc)
