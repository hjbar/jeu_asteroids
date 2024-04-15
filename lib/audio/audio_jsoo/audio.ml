open Js_of_ocaml

type audio_kind =
| Laser
| Explosion
| Bonus
| Defeat

let int_of_type t =
  match t with
  | Laser -> 0
  | Explosion -> 1
  | Bonus -> 2
  | Defeat -> 3

let audio_table = Hashtbl.create 8

let init l =
  List.iter (fun (k, s) -> Hashtbl.replace audio_table k s) l;
  Js.Unsafe.fun_call (Js.Unsafe.js_expr "init") (List.map (fun (_, b) -> Js.string b |> Js.Unsafe.inject) l |> Array.of_list) |> ignore;
  false
  
let play k =
  let js_string = Js.string (Hashtbl.find audio_table k) in
  Js.Unsafe.fun_call (Js.Unsafe.js_expr "play") [| Js.Unsafe.inject js_string; Js.Unsafe.inject (int_of_type k) |] |> ignore
