open Vector
open System_defs

let update () =
  let update_pos background =
    let pos = background#pos#get in
    let new_y = pos.y +. (Global.gravity () *. 30.) in
    if new_y >= 0. then
      background#pos#set Vector.{ x = pos.x; y = float (-3 * Global.height) }
    else background#pos#set Vector.{ x = pos.x; y = new_y }
  in
  match !Entities.background with None -> () | Some b -> update_pos b
