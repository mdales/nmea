type message_type =
    | Position_report_class_a
    | Position_report_class_a_assigned_schedule
    | Position_report_class_a_response_to_interrogation
    | Base_station_report
    | Static_and_voyage_related_data
    | Binary_addressed_message
    | Binary_acknowledge
    | Binary_broadcast_message
    | Standard_SAR_aircrart_position_report
    | UTC_and_date_inquiry
    | UTC_and_date_response
    | Addressed_safety_related_message
    | Safety_related_acknowledgement
    | Safety_related_broadcast_message
    | Interrogation
    | Assignment_mode_command
    | DGNSS_binary_broadcast_message
    | Standard_class_b_CS_position_report
    | Extended_class_b_equipment_position_report
    | Data_link_management
    | Aid_to_navigation_report
    | Channel_management
    | Group_assignment_report
    | Static_data_report
    | Single_slot_binary_message
    | Multiple_slot_binary_message_with_communications_state
    | Position_report_for_long_range_applications
    [@@deriving enum]

type navigation_status =
    | Under_way_using_engine
    | At_anchor
    | Not_under_command
    | Retricted_manoeuverability
    | Constrained_by_her_draught
    | Moored
    | Aground
    | Engaged_in_fishing
    | Under_way_sailing
    | Reserved_for_HSC
    | Reserved_for_WIG
    | Power_driven_vessel_towing_astern
    | Power_driven_vessel_pushing_ahead
    | Reserved
    | AIS_SART_is_active
    | Undefined
    [@@deriving enum]


type t = {
    channel : Sentence.channel_t;
    message : message_type;
}

let decode_armoured_char c =
    let v = Char.code c in
    if v <= 40 then v else v  - 8

let decode_payload payload_str padding =
    let charlist = List.of_seq (String.to_seq payload_str) in
    let six_bit_binary = List.map decode_armoured_char charlist in
    Array.of_list six_bit_binary

let get_bits payload padding offset length =
    if length < 1 || length > 63 then invalid_arg "Invalid length value";

    let rec loop acc offset bits =
        let char_index = Int.fdiv offset 6 in
        if char_index >= (Array.length payload) then invalid_arg "Offset too large";
        let char_offset = Int.rem offset 6 in
        let bit_length = 6 - char_offset in

        let acc = (Int.shift_left acc bit_length) + 0 in
        let remaining = bits - bit_length in
        match remaining with
        | 0 -> acc
        | _ -> loop acc (offset + bit_length) remaining
    in
    loop 0 offset length


let of_sentences sl  =
    let sl = List.sort (fun a b -> compare a.Sentence.fragment b.fragment) sl in
    match sl with
    | [] -> invalid_arg "Empty sentances list"
    | hd :: _ -> (
        let leng = List.length sl in
        let rec ordered expected = function
        | [] -> true
        | ihd :: itl -> (ihd.Sentence.fragment = expected) &&
            (ihd.fragments = leng) &&
            (ihd.channel = hd.channel) &&
            ordered (expected + 1) itl
        in
        if not (ordered 1 sl) then invalid_arg "Invalid sequence of sentences";

        let payloads = List.map (fun a -> a.Sentence.payload) sl |> String.concat "" in
        let padding = List.fold_left (fun _ a -> a.Sentence.padding) 0 sl in
        let binary_payload = decode_payload payloads padding in

        let raw_mt = get_bits binary_payload padding 0 6 in
        match message_type_of_enum raw_mt with
        | None -> invalid_arg "not a valid message"
        | Some mt ->  {
            message = mt;
            channel = hd.channel;
        }
    )
