let () =
  Game.run true
    Game.
      { up = "z"
      ; down = "s"
      ; left = "q"
      ; right = "d"
      ; space = "space"
      ; bind = "m"
      ; unbind = "p"
      ; break = "escape"
      ; quit = "1"
      ; god = "2"
      ; bonus = "3"
      }
