let update_scoring () =
  begin
    Global.increase_scoring (10. *. Global.gravity ())
    (* Gfx.debug "%f\n" (Global.scoring ()); *)
  end
