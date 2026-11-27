open Payload

exception Incomplete_message

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
    course_over_ground: float option;
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
    | Wing_in_ground_hazardous_category_a
    | Wing_in_ground_hazardous_category_b
    | Wing_in_ground_hazardous_category_c
    | Wing_in_ground_hazardous_category_d
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
    | High_speed_craft_hazardous_category_a
    | High_speed_craft_hazardous_category_b
    | High_speed_craft_hazardous_category_c
    | High_speed_craft_hazardous_category_d
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

type standard_sar_aircraft_position_report = {
    altitude: int option;
    speed_over_ground: float option;
    position_accuracy: bool;
    location: Coord.t option;
    course_over_ground: float option;
    time_stamp: time_stamp;
    dte: bool;
    assigned: bool;
    raim_flag : bool;
    radio_status: int;
}

(* Type 15 *)
type ais_interrogation = {
    first_interrogated_mmsi: int;
    first_message_type: int;
    first_slot_offset: int;
    second_message_type: int;
    second_slot_offset: int;

    second_interrogated_mmsi: int;
    third_message_type: int;
    third_slot_offset: int;
}


type cs_unit =
    | Class_B_SOTDMA
    | Class_B_CS

(* Type 18 *)
type standard_class_b_cs_position_report = {
    speed_over_ground: float option;
    position_accuracy: bool;
    location: Coord.t option;
    course_over_ground: float option;
    true_heading: int option;
    time_stamp: time_stamp;
    cs_unit: cs_unit;
    display_flag: bool;
    dsc_flag: bool;
    band_flag: bool;
    message_22_flag: bool;
    assigned: bool;
    raim_flag : bool;
    radio_status: int;
}

type aid_type =
    | Unspecified
    | Reference_point
    | RACON
    | Fixed_structure
    | Reserved
    | Light_without_sectors
    | Light_with_sectors
    | Leading_light_from
    | Leading_light_rear
    | Beacon_N
    | Beacon_E
    | Beacon_S
    | Beacon_W
    | Beacon_port_hand
    | Beacon_starboard_hand
    | Beacon_preferred_channel_port_hand
    | Beacon_preferred_channel_starboard_hand
    | Beacon_isolated_danger
    | Beacon_safe_water
    | Beacon_special_mark
    | Cardinal_mark_N
    | Cardinal_mark_E
    | Cardinal_mark_S
    | Cardinal_mark_W
    | Port_hand_mark
    | Starboard_hand_mark
    | Preferred_channel_port_hand
    | Preferred_channel_starboard_hand
    | Isolated_danger
    | Safe_water
    | Special_mark
    | Light_vessel
    [@@deriving enum, show]

(* Type 21 *)
type aid_to_navigation_report = {
    aid_type: aid_type;
    name: string;
    position_accuracy: bool;
    location: Coord.t option;
    to_bow: int;
    to_stern: int;
    to_port: int;
    to_starboard: int;
    position_fix_type: position_fix_type;
    second: int option;
    off_position: bool;
    raim_flag : bool;
    virtual_aid: bool;
    assigned: bool;
}

(* Type 24 *)
type static_data_report_b_aux = {
    ship_type: ship_and_cargo_classification;
    vendor_id: string;
    model: int;
    serial_number: int;
    call_sign: string;
    mothership_mmsi: int;
}

type static_data_report_b = {
    ship_type: ship_and_cargo_classification;
    vendor_id: string;
    model: int;
    serial_number: int;
    call_sign: string;
    to_bow: int;
    to_stern: int;
    to_port: int;
    to_starboard: int;
}

type static_data_report =
    | Part_a of string
    | Part_b of static_data_report_b
    | Part_b_aux of static_data_report_b_aux
    | Unknown of int

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
    | Standard_SAR_aircraft_position_report
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
    | Standard_SAR_aircraft_position_report of standard_sar_aircraft_position_report
    | Interrogation of ais_interrogation
    | Standard_class_b_CS_position_report of standard_class_b_cs_position_report
    | Aid_to_navigation_report of aid_to_navigation_report
    | Static_data_report of static_data_report
    | Unprocessed of message_type

type t = {
    channel : Sentence.channel_t;
    repeat_indicator : int;
    mmsi : int;
    message : message;
}

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

let decoode_position_report payload =
    let get_bits = get_bits payload in
    let navigation_status = Option.get (navigation_status_of_enum (get_bits Unsigned 38 4)) in
    let rate_of_turn = get_bits Signed 42 8 in
    let speed_over_ground_raw = get_bits Unsigned 50 10 in
    let position_accuracy = get_bool payload 60 in
    let longitude_raw = get_bits Signed 61 28 in
    let latitude_raw = get_bits Signed 89 27 in
    let course_over_ground_raw = get_bits Unsigned 116 12 in
    let true_heading_raw = get_bits Unsigned 128 9 in
    let time_stamp_raw = get_bits Unsigned 137 6 in
    let maneuver_indicator = Option.get(maneuver_indicator_of_enum (get_bits Unsigned 143 2)) in
    let raim_flag = get_bool payload 148 in
    let radio_status = get_bits Unsigned 149 19 in

    let speed_over_ground = match speed_over_ground_raw with
    | 1023 -> None
    | x -> Some ((float_of_int x) /. 10.)
    in

    let location = raw_lat_lng_to_coord longitude_raw latitude_raw in

    let course_over_ground = match course_over_ground_raw with
    | 0xE10 -> None
    | x -> Some ((float_of_int x) /. 10.)
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

let decode_base_station_report payload =
    let get_bits = get_bits payload in
    let year_raw = get_bits Unsigned 38 14 in
    let month_raw = get_bits Unsigned 52 4 in
    let day_raw = get_bits Unsigned 56 5 in
    let hour_raw = get_bits Unsigned 61 5 in
    let minute_raw = get_bits Unsigned 66 6 in
    let second_raw = get_bits Unsigned 72 6 in
    let fix_quality = get_bool payload 78 in
    let longitude_raw = get_bits Signed 79 28 in
    let latitude_raw = get_bits Signed 107 27 in
    let position_fix_type = Option.get (position_fix_type_of_enum (get_bits Unsigned 134 4)) in
    let raim_flag = get_bool payload 148 in
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

let decode_related_data payload =
    let get_bits = get_bits payload in
    let ais_version_raw = get_bits Unsigned 38 2 in
    let imo_number = get_bits Unsigned 40 30 in
    let call_sign = get_text payload 70 42 in
    let ship_name = get_text payload 112 120 in
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
    let destination = get_text payload 302 120 in
    let dte = get_bool payload 422 in

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


let decoode_standard_sar_aircraft_report payload =
    let get_bits = get_bits payload in
    let altitude_raw = get_bits Unsigned 38 12 in
    let speed_over_ground_raw = get_bits Unsigned 50 10 in
    let position_accuracy = get_bool payload 60 in
    let longitude_raw = get_bits Signed 61 28 in
    let latitude_raw = get_bits Signed 89 27 in
    let course_over_ground_raw = get_bits Unsigned 116 12 in
    let time_stamp_raw = get_bits Unsigned 128 6 in
    let dte = get_bool payload 142 in
    let assigned = get_bool payload 146 in

    let raim_flag = get_bool payload 148 in
    let radio_status = get_bits Unsigned 149 19 in

    let altitude = match altitude_raw with
    | 4095 -> None
    | x -> Some x
    in

    let speed_over_ground = match speed_over_ground_raw with
    | 1023 -> None
    | x -> Some (float_of_int x)
    in

    let location = raw_lat_lng_to_coord longitude_raw latitude_raw in

    let course_over_ground = match course_over_ground_raw with
    | 0xE10 -> None
    | x -> Some ((float_of_int x) /. 10.)
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
        altitude;
        speed_over_ground;
        position_accuracy;
        location;
        course_over_ground;
        time_stamp;
        dte;
        assigned;
        raim_flag;
        radio_status;
    }

let decoode_class_b_cs_position_report payload =
    let get_bits = get_bits payload in
    let speed_over_ground_raw = get_bits Unsigned 46 10 in
    let position_accuracy = get_bool payload 56 in
    let longitude_raw = get_bits Signed 57 28 in
    let latitude_raw = get_bits Signed 85 27 in
    let course_over_ground_raw = get_bits Unsigned 112 12 in
    let true_heading_raw = get_bits Unsigned 124 9 in
    let time_stamp_raw = get_bits Unsigned 133 6 in
    let cs_unit = match (get_bits Unsigned 141 1) with 1 -> Class_B_CS | _ -> Class_B_SOTDMA in
    let display_flag = get_bool payload 142 in
    let dsc_flag = get_bool payload 143 in
    let band_flag = get_bool payload 144 in
    let message_22_flag = get_bool payload 145 in
    let assigned = get_bool payload 146 in


    let raim_flag = get_bool payload 147 in
    let radio_status = get_bits Unsigned 148 20 in

    let speed_over_ground = match speed_over_ground_raw with
    | 1023 -> None
    | x -> Some ((float_of_int x) /. 10.)
    in

    let location = raw_lat_lng_to_coord longitude_raw latitude_raw in

    let course_over_ground = match course_over_ground_raw with
    | 0xE10 -> None
    | x -> Some ((float_of_int x) /. 10.)
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
        speed_over_ground;
        position_accuracy;
        location;
        course_over_ground;
        true_heading;
        time_stamp;
        cs_unit;
        display_flag;
        dsc_flag;
        band_flag;
        message_22_flag;
        assigned;
        raim_flag;
        radio_status;
    }

let decode_aid_to_navigation payload =
    let get_bits = get_bits payload in
    let aid_type_raw = get_bits Unsigned 38 5 in
    let name_raw = get_text payload 43 120 in
    let position_accuracy = get_bool payload 163 in
    let longitude_raw = get_bits Signed 164 28 in
    let latitude_raw = get_bits Signed 192 27 in
    let to_bow = get_bits Unsigned 219 9 in
    let to_stern = get_bits Unsigned 228 9 in
    let to_port = get_bits Unsigned 237 6 in
    let to_starboard = get_bits Unsigned 243 6 in
    let position_fix_type = Option.get (position_fix_type_of_enum (get_bits Unsigned 249 4)) in
    let second_raw = get_bits Unsigned 253 6 in
    let off_position = get_bool payload 259 in
    let raim_flag = get_bool payload 268 in
    let virtual_aid = get_bool payload 269 in
    let assigned = get_bool payload 146 in

    let aid_type = Option.get (aid_type_of_enum aid_type_raw) in

    let location = raw_lat_lng_to_coord longitude_raw latitude_raw in

    let second = match second_raw with
    | n when n < 0 -> invalid_arg "Failed to decode second"
    | n when n < 60 -> Some n
    | 60 -> None
    | _ -> invalid_arg "Failed to decode second"
    in

    (* Todo: name extension *)
    let extra_bits = (Payload.length payload) - 272 in
    let name = if extra_bits <= 0 then name_raw else (
        let name_extra = get_text payload 272 ((Int.fdiv extra_bits 6) * 6) in
        name_raw ^ name_extra
    ) in

    {
        aid_type;
        name;
        position_accuracy;
        location;
        to_bow;
        to_stern;
        to_port;
        to_starboard;
        position_fix_type;
        second;
        off_position;
        raim_flag;
        virtual_aid;
        assigned;
    }

let decode_static_data_report_b payload =
    let ship_type = Option.get (ship_and_cargo_classification_of_enum (get_uint payload 40 8)) in
    let vendor_id = get_text payload 48 18 in
    let model = get_uint payload 66 4 in
    let serial_number = get_uint payload 70 20 in
    let call_sign = get_text payload 90 42 in
    let to_bow = get_uint payload 132 9 in
    let to_stern = get_uint payload 141 9 in
    let to_port = get_uint payload 150 6 in
    let to_starboard = get_uint payload 156 6 in

    {
        ship_type;
        vendor_id;
        model;
        serial_number;
        call_sign;
        to_bow;
        to_stern;
        to_port;
        to_starboard;
    }

let decode_static_data_report_b_aux payload =
    let ship_type = Option.get (ship_and_cargo_classification_of_enum (get_uint payload 40 8)) in
    let vendor_id = get_text payload 48 18 in
    let model = get_uint payload 66 4 in
    let serial_number = get_uint payload 70 20 in
    let call_sign = get_text payload 90 42 in
    let mothership_mmsi = get_uint payload 132 30 in

    {
        ship_type;
        vendor_id;
        model;
        serial_number;
        call_sign;
        mothership_mmsi;
    }

let decode_static_data_report mmsi payload =
    match (get_uint payload 38 2) with
    | 0 -> (
        Part_a (get_text payload 40 120)
    )
    | 1 -> (
        let is_aux = (Int.fdiv mmsi 10000000) = 98 in
        match is_aux with
        | false -> Part_b (decode_static_data_report_b payload)
        | true -> Part_b_aux (decode_static_data_report_b_aux payload)
    )
    | x -> Unknown x

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
        | ihd :: itl -> (
            if ihd.Sentence.fragments != leng then raise Incomplete_message;
            (ihd.Sentence.fragment = expected) &&
            (ihd.channel = hd.channel) &&
            ordered (expected + 1) itl)
        in
        let err = String.concat " " (List.map (fun msg -> Printf.sprintf "%d/%d" msg.Sentence.fragment msg.fragments) sl) in
        if not (ordered 1 sl) then invalid_arg ("Invalid sequence of sentences" ^ err);

        let payloads = List.map (fun a -> a.Sentence.payload) sl |> String.concat "" in
        let padding = List.fold_left (fun _ a -> a.Sentence.padding) 0 sl in
        let payload = Payload.v payloads padding in

        let raw_mt = get_bits payload Unsigned 0 6 in
        let repeat = get_bits payload Unsigned 6 2 in
        let mmsi = get_bits payload Unsigned 8 30 in

        let message = match message_type_of_enum raw_mt with
        | None -> invalid_arg "not a valid message"
        | Some mt ->  (
            match mt with
            | Position_report_class_a -> Position_report_class_a (decoode_position_report payload)
            | Position_report_class_a_assigned_schedule -> Position_report_class_a_assigned_schedule (decoode_position_report payload)
            | Position_report_class_a_response_to_interrogation -> Position_report_class_a_response_to_interrogation (decoode_position_report payload)
            | Base_station_report -> Base_station_report (decode_base_station_report payload)
            | Static_and_voyage_related_data -> Static_and_voyage_related_data (decode_related_data payload)
            | Standard_SAR_aircraft_position_report -> Standard_SAR_aircraft_position_report (decoode_standard_sar_aircraft_report payload)
            | Standard_class_b_CS_position_report -> Standard_class_b_CS_position_report (decoode_class_b_cs_position_report payload)
            | Aid_to_navigation_report -> Aid_to_navigation_report (decode_aid_to_navigation payload)
            | Static_data_report -> Static_data_report (decode_static_data_report mmsi payload)
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
