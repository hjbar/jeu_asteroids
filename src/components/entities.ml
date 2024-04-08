open Component_defs

let (ovni : Component_defs.ovni option ref) = ref None

let (background : Component_defs.drawable option ref) = ref None

let lasers = new box_collection false

let asteroids = new box_collection true
