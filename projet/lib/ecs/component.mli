(** A reference to a value of type 'a in OO style *)
type 'a t = < get : 'a ; set : 'a -> unit >

(** utility function to build object references *)
val def : 'a -> 'a t
