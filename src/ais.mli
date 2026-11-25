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

val of_sentences: Sentence.vdm list -> t
