(*
  On stocke ici les entités que l'on veut stocker durablement dans le temps.
  Par exemple, les asteroids et les lasers sont temporaires, donc on ne les
  stocke pas ici.
  Les murs ne sont pas temporaires mais on n'a pas besoin d'y avoir accès.
*)

let (ovni : Component_defs.ovni option ref) = ref None
