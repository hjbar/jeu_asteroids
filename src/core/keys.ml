(* On crée la config *)
type config =
  { up : string
  ; down : string
  ; left : string
  ; right : string
  ; space : string
  ; bind : string
  ; unbind : string
  ; break : string
  ; quit : string
  ; god : string
  ; bonus : string
  }

let has_key, set_key, unset_key =
  let h : (string, unit) Hashtbl.t = Hashtbl.create 16 in
  ( (fun s -> Hashtbl.mem h s)
  , (fun s -> Hashtbl.replace h s ())
  , fun s -> Hashtbl.remove h s )

let is_break cfg = has_key cfg.bind && has_key cfg.break

let not_break cfg = has_key cfg.unbind && has_key cfg.break

let is_quit cfg = has_key cfg.bind && has_key cfg.quit

let is_god cfg = has_key cfg.bind && has_key cfg.god

let not_god cfg = has_key cfg.unbind && has_key cfg.god

let is_bonus cfg = has_key cfg.bind && has_key cfg.bonus

let not_bonus cfg = has_key cfg.unbind && has_key cfg.bonus

let is_up cfg = has_key cfg.up

let is_down cfg = has_key cfg.down

let is_left cfg = has_key cfg.left

let is_right cfg = has_key cfg.right

let is_shoot cfg = has_key cfg.space

let update cfg =
  (* On regarde si on doit activer un mode *)
  if is_god cfg then Global.god_mode := true;

  if not_god cfg then Global.god_mode := false;

  if is_bonus cfg then Global.set_bonus_only ();

  if not_bonus cfg then Global.reset_bonus_drop_rate ();

  (* On update les mouvements *)
  let dx = ref 0. in
  let dy = ref 0. in

  let v = Global.get_ovni_speed () in

  if is_up cfg then dy := !dy -. v;
  if is_down cfg then dy := !dy +. v;
  if is_left cfg then dx := !dx -. v;
  if is_right cfg then dx := !dx +. v;

  Ovni.set_sum_forces Vector.{ x = !dx; y = !dy };

  (* On update les lasers *)
  if is_shoot cfg && Ovni.allow_to_shoot () then Laser.create ()
