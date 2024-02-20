let init_walls l =
  let width = Global.width in
  let height = Global.height in
  let l = Global.wall_l in
  let texture = Texture.color (Gfx.color 0 0 0 0) in

  ignore
    (Box.create "wall_top" (-l) (-l)
       (width + (2 * l))
       l infinity 0. 0.01 Wall texture );
  ignore
    (Box.create "wall_bot" (-l) height
       (width + (2 * l))
       l infinity 0. 1.25 Wall_bot texture );
  ignore (Box.create "wall_left" (-l) 0 l height infinity 0. 0.01 Wall texture);
  ignore
    (Box.create "wall_right" width 0 l height infinity 0. 0.01 Wall texture)
