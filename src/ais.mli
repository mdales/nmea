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
    | Unprocessed of message_type

type t = {
    channel : Sentence.channel_t;
    repeat_indicator : int;
    mmsi : int;
    message : message;
}

val time_stamp_to_string: time_stamp -> string

val of_sentences: Sentence.vdm list -> t
