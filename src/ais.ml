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
    [@@deriving enum, show]

type maneuver_indicator =
    | Not_available
    | No_special_maneuver
    | Special_maneuver
    [@@deriving enum, show]

type time_stamp =
    | Time_stamp of int
    | Not_available
    | Manual_mode
    | Estimated_mode
    | Inoperative

type position_report = {
    navigation_status : navigation_status;
    rate_of_turn : int;
    speed_over_ground: float option;
    position_accuracy: bool;
    location: Coord.t option;
    course_over_ground: int option;
    true_heading: int option;
    time_stamp: time_stamp;
    maneuver_indicator: maneuver_indicator;
    raim_flag : bool;
    radio_status: int;
}

type position_fix_type =
    | Undefined
    | GPS
    | GLONASS
    | Combined_GPS_GLONASS
    | Loran_c
    | Chayka
    | Integrated_navigation_system
    | Surveyed
    | Galileo
    | Reserved_1
    | Reserved_2
    | Reserved_3
    | Reserved_4
    | Reserved_5
    | Reserved_6
    | Internal_GNSS
    [@@deriving enum, show]

type base_station_report = {
    year: int option;
    month: int option;
    day: int option;
    hour: int option;
    minute: int option;
    second: int option;
    fix_quality: bool;
    location: Coord.t option;
    position_fix_type: position_fix_type;
    raim_flag : bool;
    radio_status: int;
}

type ship_and_cargo_classification =
    | Not_available
    | Reserved_1
    | Reserved_2
    | Reserved_3
    | Reserved_4
    | Reserved_5
    | Reserved_6
    | Reserved_7
    | Reserved_8
    | Reserved_9
    | Reserved_10
    | Reserved_11
    | Reserved_12
    | Reserved_13
    | Reserved_14
    | Reserved_15
    | Reserved_16
    | Reserved_17
    | Reserved_18
    | Reserved_19
    | Wing_in_ground_all
    | Wing_in_ground_hazardous_catagory_a
    | Wing_in_ground_hazardous_catagory_b
    | Wing_in_ground_hazardous_catagory_c
    | Wing_in_ground_hazardous_catagory_d
    | Wing_in_ground_reserved_1
    | Wing_in_ground_reserved_2
    | Wing_in_ground_reserved_3
    | Wing_in_ground_reserved_4
    | Wing_in_ground_reserved_5
    | Fishing
    | Towing
    | Towing_large
    | Dredging_or_underwater_ops
    | Diving_ops
    | Military_ops
    | Sailing
    | Pleasure_craft
    | Reserved_39
    | Reserved_40
    | High_speed_craft_all
    | High_speed_craft_hazardous_catagory_a
    | High_speed_craft_hazardous_catagory_b
    | High_speed_craft_hazardous_catagory_c
    | High_speed_craft_hazardous_catagory_d
    | High_speed_craft_reserved_1
    | High_speed_craft_reserved_2
    | High_speed_craft_reserved_3
    | High_speed_craft_reserved_4
    | High_speed_craft_no_additional_info
    | Pilot_vessel
    | Search_and_rescue_vessel
    | Tug
    | Port_tender
    | Anti_pollution_equipment
    | Law_enforcement
    | Spare_local_vessel_1
    | Spare_local_vessel_2
    | Medical_transport
    | Noncompatant_ship
    | Passenger_all
    | Passenger_hazardous_category_a
    | Passenger_hazardous_category_b
    | Passenger_hazardous_category_c
    | Passenger_hazardous_category_d
    | Passenger_reserved_1
    | Passenger_reserved_2
    | Passenger_reserved_3
    | Passenger_reserved_4
    | Passenger_no_additional_info
    | Cargo_all
    | Cargo_hazardous_category_a
    | Cargo_hazardous_category_b
    | Cargo_hazardous_category_c
    | Cargo_hazardous_category_d
    | Cargo_reserved_1
    | Cargo_reserved_2
    | Cargo_reserved_3
    | Cargo_reserved_4
    | Cargo_no_additional_info
    | Tanker_all
    | Tanker_hazardous_category_a
    | Tanker_hazardous_category_b
    | Tanker_hazardous_category_c
    | Tanker_hazardous_category_d
    | Tanker_reserved_1
    | Tanker_reserved_2
    | Tanker_reserved_3
    | Tanker_reserved_4
    | Tanker_no_additional_info
    | Other_all
    | Other_hazardous_category_a
    | Other_hazardous_category_b
    | Other_hazardous_category_c
    | Other_hazardous_category_d
    | Other_reserved_1
    | Other_reserved_2
    | Other_reserved_3
    | Other_reserved_4
    | Other_no_additional_info
    [@@deriving enum, show]

type ais_version =
    | ITU1371
    | Future_editions of int

type static_and_voyage_related_data = {
    ais_version: ais_version;
    imo_number: int;
    call_sign: string;
    ship_name: string;
    ship_type: ship_and_cargo_classification;
    to_bow: int;
    to_stern: int;
    to_port: int;
    to_starboard: int;
    position_fix_type: position_fix_type;
    eta_month: int option;
    eta_day: int option;
    eta_hour: int option;
    eta_minute: int option;
    draught: int;
    destination: string;
    dte: bool;
}

type message_type =
    | Invalid (* enumerations start at 1 *)
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
    [@@deriving enum, show]

type message =
    | Position_report_class_a of position_report
    | Position_report_class_a_assigned_schedule of position_report
    | Position_report_class_a_response_to_interrogation of position_report
    | Base_station_report of base_station_report
    | Static_and_voyage_related_data of static_and_voyage_related_data
    | Unprocessed of message_type

type t = {
    channel : Sentence.channel_t;
    repeat_indicator : int;
    mmsi : int;
    message : message;
}

let decode_armoured_char c =
    let v = (Char.code c) - 48 in
    if v <= 40 then v else v  - 8

let decode_payload payload_str=
    let charlist = List.of_seq (String.to_seq payload_str) in
    let six_bit_binary = List.map decode_armoured_char charlist in
    Array.of_list six_bit_binary

type signed =
    | Unsigned
    | Signed

let get_bits payload _padding signed offset length =
    if length < 1 || length > 63 then invalid_arg "Invalid length value";

    let rec loop acc offset bits =
        let char_index = Int.fdiv offset 6 in
        if char_index >= (Array.length payload) then invalid_arg "Offset too large";
        let char_offset = Int.rem offset 6 in

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

let get_text payload padding offset length =
    if (Int.rem length 6) <> 0 then invalid_arg "Expected length to be multiple of six";
    let char_count = Int.fdiv length 6 in
    let padded_string  = String.init char_count (fun i ->
        let v = get_bits payload padding Unsigned (offset + (i * 6)) 6 in
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

let raw_lat_lng_to_coord longitude_raw latitude_raw =
    match longitude_raw, latitude_raw with
    | 0x6791AC0, _ -> None
    | _, 0x3412140 -> None
    | lng, lat -> (
        let lat = (float_of_int lat) /. 600000.0
        and lng = (float_of_int lng) /. 600000.0 in
        let lat = if lat < 0.0 then (lat *. (-1.), Coord.S) else (lat, Coord.N)
        and lng = if lng < 0.0 then (lng *. (-1.), Coord.W) else (lng, Coord.E) in
        Some (lat, lng)
    )

let decoode_position_report payload padding =
    let get_bits = get_bits payload padding in
    let navigation_status = Option.get (navigation_status_of_enum (get_bits Unsigned 38 4)) in
    let rate_of_turn = get_bits Signed 42 8 in
    let speed_over_ground_raw = get_bits Unsigned 50 10 in
    let position_accuracy = match (get_bits Unsigned 60 1) with 1 -> true | _ -> false in
    let longitude_raw = get_bits Signed 61 28 in
    let latitude_raw = get_bits Signed 89 27 in
    let course_over_ground_raw = get_bits Unsigned 116 12 in
    let true_heading_raw = get_bits Unsigned 128 9 in
    let time_stamp_raw = get_bits Unsigned 137 6 in
    let maneuver_indicator = Option.get(maneuver_indicator_of_enum (get_bits Unsigned 143 2)) in
    let raim_flag = match (get_bits Unsigned 148 1) with 1 -> true | _ -> false in
    let radio_status = get_bits Unsigned 149 19 in

    let speed_over_ground = match speed_over_ground_raw with
    | 1023 -> None
    | x -> Some ((float_of_int x) /. 10.)
    in

    let location = raw_lat_lng_to_coord longitude_raw latitude_raw in

    let course_over_ground = match course_over_ground_raw with
    | 0xE10 -> None
    | x -> Some x
    in

    let true_heading = match true_heading_raw with
    | 511 -> None
    | x -> Some x
    in

    let time_stamp = match time_stamp_raw with
    | n when n < 0 -> invalid_arg "Failed to decode time stamp"
    | n when n < 60 -> Time_stamp n
    | 60 -> Not_available
    | 61 -> Manual_mode
    | 62 -> Estimated_mode
    | 63 -> Inoperative
    | _ -> invalid_arg "Invalid timestamp value"
    in

    {
        navigation_status;
        rate_of_turn;
        speed_over_ground;
        position_accuracy;
        location;
        course_over_ground;
        true_heading;
        time_stamp;
        maneuver_indicator;
        raim_flag;
        radio_status;
    }

let decode_base_station_report payload padding =
    let get_bits = get_bits payload padding in
    let year_raw = get_bits Unsigned 38 14 in
    let month_raw = get_bits Unsigned 52 4 in
    let day_raw = get_bits Unsigned 56 5 in
    let hour_raw = get_bits Unsigned 61 5 in
    let minute_raw = get_bits Unsigned 66 6 in
    let second_raw = get_bits Unsigned 72 6 in
    let fix_quality = match (get_bits Unsigned 78 1) with 1 -> true | _ -> false in
    let longitude_raw = get_bits Signed 79 28 in
    let latitude_raw = get_bits Signed 107 27 in
    let position_fix_type = Option.get (position_fix_type_of_enum (get_bits Unsigned 134 4)) in
    let raim_flag = match (get_bits Unsigned 148 1) with 1 -> true | _ -> false in
    let radio_status = get_bits Unsigned 149 19 in

    let year = match year_raw with
    | n when n < 0 -> invalid_arg "Failed to decode year"
    | 0 -> None
    | n when n < 9999 -> Some n
    | _ -> invalid_arg "Failed to decode year"
    in

    let month = match month_raw with
    | n when n < 0 -> invalid_arg "Failed to decode month"
    | 0 -> None
    | n when n <= 12 -> Some n
    | _ -> invalid_arg "Failed to decode month"
    in

    let day = match day_raw with
    | n when n < 0 -> invalid_arg "Failed to decode day"
    | 0 -> None
    | n when n <= 31 -> Some n
    | _ -> invalid_arg "Failed to decode day"
    in

    let hour = match hour_raw with
    | n when n < 0 -> invalid_arg "Failed to decode hour"
    | n when n < 24 -> Some n
    | 24 -> None
    | _ -> invalid_arg "Failed to decode hour"
    in

    let minute = match minute_raw with
    | n when n < 0 -> invalid_arg "Failed to decode minute"
    | n when n < 60 -> Some n
    | 60 -> None
    | _ -> invalid_arg "Failed to decode minute"
    in

    let second = match second_raw with
    | n when n < 0 -> invalid_arg "Failed to decode second"
    | n when n < 60 -> Some n
    | 60 -> None
    | _ -> invalid_arg "Failed to decode second"
    in

    let location = raw_lat_lng_to_coord longitude_raw latitude_raw in

    {
        year;
        month;
        day;
        hour;
        minute;
        second;
        fix_quality;
        location;
        position_fix_type;
        raim_flag;
        radio_status;
    }

let decode_related_data payload padding =
    let get_bits = get_bits payload padding in
    let ais_version_raw = get_bits Unsigned 38 2 in
    let imo_number = get_bits Unsigned 40 30 in
    let call_sign = get_text payload padding 70 42 in
    let ship_name = get_text payload padding 112 120 in
    let ship_type = Option.get (ship_and_cargo_classification_of_enum (get_bits Unsigned 232 8)) in
    let to_bow = get_bits Unsigned 240 9 in
    let to_stern = get_bits Unsigned 249 9 in
    let to_port = get_bits Unsigned 258 6 in
    let to_starboard = get_bits Unsigned 264 6 in
    let position_fix_type = Option.get (position_fix_type_of_enum (get_bits Unsigned 270 4)) in
    let eta_month_raw = get_bits Unsigned 274 4 in
    let eta_day_raw = get_bits Unsigned 278 5 in
    let eta_hour_raw = get_bits Unsigned 283 5 in
    let eta_minute_raw = get_bits Unsigned 288 6 in
    let draught = (get_bits Unsigned 294 8) * 10 in
    let destination = get_text payload padding 302 120 in
    let dte = match get_bits Unsigned 422 1 with 1 -> true | _ -> false in

    let ais_version = match ais_version_raw with
    | 0 -> ITU1371
    | x -> Future_editions x
    in

    let eta_month = match eta_month_raw with
    | n when n < 0 -> invalid_arg "Failed to decode month"
    | 0 -> None
    | n when n <= 12 -> Some n
    | _ -> invalid_arg "Failed to decode month"
    in

    let eta_day = match eta_day_raw with
    | n when n < 0 -> invalid_arg "Failed to decode day"
    | 0 -> None
    | n when n <= 31 -> Some n
    | _ -> invalid_arg "Failed to decode day"
    in

    let eta_hour = match eta_hour_raw with
    | n when n < 0 -> invalid_arg "Failed to decode hour"
    | n when n < 24 -> Some n
    | 24 -> None
    | _ -> invalid_arg "Failed to decode hour"
    in

    let eta_minute = match eta_minute_raw with
    | n when n < 0 -> invalid_arg "Failed to decode minute"
    | n when n < 60 -> Some n
    | 60 -> None
    | _ -> invalid_arg "Failed to decode minute"
    in

    {
        ais_version;
        imo_number;
        call_sign;
        ship_name;
        ship_type;
        to_bow;
        to_stern;
        to_port;
        to_starboard;
        position_fix_type;
        eta_month;
        eta_day;
        eta_hour;
        eta_minute;
        draught;
        destination;
        dte;
    }


let time_stamp_to_string t =
    match t with
    | Time_stamp n -> Printf.sprintf "%d" n
    | Not_available -> "Not available"
    | Manual_mode -> "Manual"
    | Estimated_mode -> "Estimated"
    | Inoperative -> "Inoperative"


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
        let binary_payload = decode_payload payloads in

        let raw_mt = get_bits binary_payload padding Unsigned 0 6 in
        let repeat = get_bits binary_payload padding Unsigned 6 2 in
        let mmsi = get_bits binary_payload padding Unsigned 8 30 in

        let message = match message_type_of_enum raw_mt with
        | None -> invalid_arg "not a valid message"
        | Some mt ->  (
            match mt with
            | Position_report_class_a -> Position_report_class_a (decoode_position_report binary_payload padding)
            | Position_report_class_a_assigned_schedule -> Position_report_class_a_assigned_schedule (decoode_position_report binary_payload padding)
            | Position_report_class_a_response_to_interrogation -> Position_report_class_a_response_to_interrogation (decoode_position_report binary_payload padding)
            | Base_station_report -> Base_station_report (decode_base_station_report binary_payload padding)
            | Static_and_voyage_related_data -> Static_and_voyage_related_data (decode_related_data binary_payload padding)
            | mt -> Unprocessed mt
        )
        in

        {
            message;
            channel = hd.channel;
            repeat_indicator = repeat;
            mmsi;
        }
    )
