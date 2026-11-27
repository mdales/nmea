type t

type signed_t =
| Unsigned
| Signed


val v : string -> int -> t

val length : t -> int

val get_bits : t -> signed_t -> int -> int -> int

val get_text : t -> int -> int -> string

val get_bool : t -> int -> bool

val get_uint : t -> int -> int -> int

val get_int : t -> int -> int -> int
