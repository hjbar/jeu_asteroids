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
      ; ctrl = "Control"
      ; enter = "Enter"
      ; break = "."
      ; quit = "0"
      ; un = "1"
      ; deux = "2"
      ; quatre = "4"
      ; cinq = "5"
      }
