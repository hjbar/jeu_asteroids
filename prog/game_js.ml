let debug = Gfx.open_formatter "console"

let () = Gfx.set_debug_formatter debug

let () =
  Game.run false
    Game.
      { up = "z"
      ; down = "s"
      ; left = "q"
      ; right = "d"
      ; space = " "
      ; bind = "m"
      ; unbind = "p"
      ; break = "Escape"
      ; quit = "&"
      ; god = "é"
      ; bonus = {|"|}
      }
