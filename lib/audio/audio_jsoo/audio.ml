open Js_of_ocaml

type audio_kind =
  | Laser
  | Explosion
  | Bonus
  | Defeat
  | Damage
  | Bomb

let int_of_type t =
  match t with Laser -> 0 | Explosion -> 1 | Bonus -> 2 | Defeat -> 3 | Damage -> 4 | Bomb -> 5

let init l =
  Js.Unsafe.fun_call (Js.Unsafe.js_expr "init")
    (List.map (fun (_, b) -> Js.string b |> Js.Unsafe.inject) l |> Array.of_list)
  |> ignore

let play k =
  Js.Unsafe.fun_call (Js.Unsafe.js_expr "play")
    [| Js.Unsafe.inject (int_of_type k) |]
  |> ignore
