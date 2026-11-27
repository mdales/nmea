type t = int array * int

type signed_t =
  | Unsigned
  | Signed

let decode_armoured_char c =
  let v = (Char.code c) - 48 in
  if v <= 40 then v else v  - 8

let decode_payload payload_str =
  let charlist = List.of_seq (String.to_seq payload_str) in
  let six_bit_binary = List.map decode_armoured_char charlist in
  Array.of_list six_bit_binary

let v payload_raw padding =
  (decode_payload payload_raw, padding)

let length pt =
  let payload, padding = pt in
  ((Array.length payload) * 6) - padding

let get_bits pt signed offset length =
  if length < 1 || length > 63 then invalid_arg "Invalid length value";

  let payload, padding = pt in
  let payload_length = Array.length payload in

  let rec loop acc offset bits =
    let char_index = Int.fdiv offset 6 in
    if char_index >= (Array.length payload) then invalid_arg (Printf.sprintf "Offset %d too large" offset);
    let char_offset = Int.rem offset 6 in
    if char_index = (payload_length - 1) then
      if char_offset > padding then
      invalid_arg "Offset too large"
    ;

    let bits_available = 6 - char_offset in
    let bits_to_read = Int.min bits_available bits in
    let mask = (1 lsl bits_to_read) - 1 in

    let v = payload.(char_index) in
    let v = (v lsr (6 - (char_offset + bits_to_read))) in
    let v = v land mask in

    let acc = (Int.shift_left acc bits_to_read) + v in
    let remaining = bits - bits_to_read in
    match remaining with
    | 0 -> acc
    | _ -> loop acc (offset + bits_to_read) remaining
  in
  let v = loop 0 offset length in

  match signed with
  | Unsigned -> v
  | Signed -> (
    (v lsl (Sys.int_size - length)) asr (Sys.int_size - length)
  )

let get_text pt offset length =
  if (Int.rem length 6) <> 0 then invalid_arg "Expected length to be multiple of six";
  let char_count = Int.fdiv length 6 in
  let padded_string  = String.init char_count (fun i ->
    let v = get_bits pt Unsigned (offset + (i * 6)) 6 in
    if v < 32 then Char.chr (v + 64) else
    Char.chr v
  ) in
  let rec loop i =
    if i < 0 then 0 else (
    let c = String.get padded_string i in
    match c with
    | '@' | ' ' -> loop (i - 1)
    | _ -> i + 1
    )
  in
  let final_pos = loop (char_count - 1) in
  String.sub padded_string 0 final_pos

let get_bool pt offset =
  match (get_bits pt Unsigned offset 1) with
  | 1 -> true
  | _ -> false

let get_uint pt offset length =
  get_bits pt Unsigned offset length

let get_int pt offset length =
  get_bits pt Signed offset length
