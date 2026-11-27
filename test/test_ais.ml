open OUnit2
open Nmea

let fmt_nav_type nt =
    Printf.sprintf "%d" (Ais.navigation_status_to_enum nt)

let fmt_opt_loc l =
    match l with
    | None -> "None"
    | Some c -> Printf.sprintf "Some %s" (Coord.to_string c)

let fmt_opt_int i =
    match i with
    | None -> "None"
    | Some i -> Int.to_string i

let fmt_opt_float x =
    match x with
    | None -> "None"
    | Some x -> Float.to_string x

let cmp_opt_loc a b =
    match a, b with
    | None, None -> true
    | Some a, Some b -> Coord.eq a b
    | _ -> false

let test_simple_positon_message _ =
    let msg = "!AIVDM,1,1,,B,13P><k0P00Oi4EPNPeudJgvh08=e,0*70" in
    match Nmea.Parse.parse msg with
    | VDM vdm -> (
        assert_equal ~msg:"Check fragment" 1 vdm.fragment;
        assert_equal ~msg:"Check fragmens" 1 vdm.fragments;
        assert_equal ~msg:"Check id" None vdm.id;
        assert_equal ~msg:"Check channel" Sentence.B vdm.channel;
        assert_equal ~msg:"Check padding" 0 vdm.padding;

        let ais = Ais.of_sentences ([vdm]) in
        assert_equal ~msg:"Check channel" Sentence.B ais.channel;
        assert_equal ~printer:Int.to_string ~msg:"Check repeats" 0 ais.repeat_indicator;
        assert_equal ~printer:Int.to_string ~msg:"Check MMSI" 235113676 ais.mmsi;

        match ais.message with
        | Position_report_class_a msg -> (
            assert_equal ~printer:fmt_nav_type ~msg:"Check navigation status" Ais.Under_way_using_engine msg.navigation_status;
            assert_equal ~printer:Ais.time_stamp_to_string ~msg:"Check time stamp" (Ais.Time_stamp 24) msg.time_stamp;
            assert_equal ~cmp:cmp_opt_loc ~printer:fmt_opt_loc ~msg:"Check location" (Some ((53.322223, Coord.N), (3.262000, Coord.W))) msg.location;
            assert_equal ~printer:fmt_opt_float ~msg:"Check speed" (Some 0.) msg.speed_over_ground;
            assert_equal ~printer:fmt_opt_float ~msg:"Check direction" (Some 317.8) msg.course_over_ground;
        )
        | _ -> assert false
    )
    | _ -> assert false

let test_simple_positon_message_synthetic _ =
    let msg = "!AIVDM,1,1,,A,13P7@h@P00wj;?0NUIL>4?wp0000,0*7E" in
    match Nmea.Parse.parse msg with
    | VDM vdm -> (
        assert_equal ~msg:"Check fragment" 1 vdm.fragment;
        assert_equal ~msg:"Check fragmens" 1 vdm.fragments;
        assert_equal ~msg:"Check id" None vdm.id;
        assert_equal ~msg:"Check channel" Sentence.A vdm.channel;
        assert_equal ~msg:"Check padding" 0 vdm.padding;

        let ais = Ais.of_sentences ([vdm]) in
        assert_equal ~msg:"Check channel" Sentence.A ais.channel;
        assert_equal ~printer:Int.to_string ~msg:"Check repeats" 0 ais.repeat_indicator;
        assert_equal ~printer:Int.to_string ~msg:"Check MMSI" 235000001 ais.mmsi;

        match ais.message with
        | Position_report_class_a msg -> (
            assert_equal ~printer:fmt_nav_type ~msg:"Check navigation status" Ais.Under_way_using_engine msg.navigation_status;
            assert_equal ~msg:"Check time stamp" (Ais.Not_available : Ais.time_stamp) msg.time_stamp;
            assert_equal ~cmp:cmp_opt_loc ~printer:fmt_opt_loc ~msg:"Check location" (Some ((53.45, Coord.N), (3.02, Coord.W))) msg.location;
            assert_equal ~printer:fmt_opt_float ~msg:"Check speed" (Some 0.) msg.speed_over_ground;
            assert_equal ~printer:fmt_opt_float ~msg:"Check direction" None msg.course_over_ground;
        )
        | _ -> assert false
    )
    | _ -> assert false

let test_simple_base_station_message _ =
    let msg = "!AIVDM,1,1,,A,402=ahQvbt`kCOj56nNUvPW008;f,0*1A" in
    match Nmea.Parse.parse msg with
    | VDM vdm -> (
        assert_equal ~msg:"Check fragment" 1 vdm.fragment;
        assert_equal ~msg:"Check fragmens" 1 vdm.fragments;
        assert_equal ~msg:"Check id" None vdm.id;
        assert_equal ~msg:"Check channel" Sentence.A vdm.channel;
        assert_equal ~msg:"Check padding" 0 vdm.padding;

        let ais = Ais.of_sentences ([vdm]) in
        assert_equal ~msg:"Check channel" Sentence.A ais.channel;
        (* assert_equal ~printer:print_msg_type ~msg:"Check message" Ais.Base_station_report ais.message; *)
        assert_equal ~printer:Int.to_string ~msg:"Check repeats" 0 ais.repeat_indicator;
        assert_equal ~printer:Int.to_string ~msg:"Check MMSI" 2320834 ais.mmsi;

        match ais.message with
        | Base_station_report msg -> (
            assert_equal ~printer:fmt_opt_int ~msg:"Check year" (Some 2026) msg.year;
            assert_equal ~printer:fmt_opt_int ~msg:"Check month" (Some 11) msg.month;
            assert_equal ~printer:fmt_opt_int ~msg:"Check day" (Some 25) msg.day;
            assert_equal ~printer:fmt_opt_int ~msg:"Check hour" (Some 8) msg.hour;
            assert_equal ~printer:fmt_opt_int ~msg:"Check minute" (Some 51) msg.minute;
            assert_equal ~printer:fmt_opt_int ~msg:"Check second" (Some 19) msg.second;
            assert_equal ~printer:Bool.to_string ~msg:"Check fix quality" false msg.fix_quality;
            assert_equal ~cmp:cmp_opt_loc ~printer:fmt_opt_loc ~msg:"Check location" (Some ((53.465817, Coord.N), (3.040915, Coord.W))) msg.location;
            assert_equal ~printer:Bool.to_string ~msg:"Check raim flag" false msg.raim_flag;
        )
        | _ -> assert false
    )
    | _ -> assert false

let test_related_data_message _ =
    let msgs = [
        "!AIVDM,2,1,4,A,53MD?dp0?TI8m@s3T00=B08TA=@tp0000000000C1P<576siN532EQDT,0*73";
        "!AIVDM,2,2,4,A,3kk000000000000,2*23";
    ] in
    let sentances = List.map Nmea.Parse.parse msgs in
    match sentances with
    | VDM pkt1 :: VDM pkt2 :: [] -> (
        assert_equal ~msg:"Check fragment" 1 pkt1.fragment;
        assert_equal ~msg:"Check fragmens" 2 pkt1.fragments;
        assert_equal ~msg:"Check id" (Some 4) pkt1.id;
        assert_equal ~msg:"Check channel" Sentence.A pkt1.channel;
        assert_equal ~msg:"Check padding" 0 pkt1.padding;

        assert_equal ~msg:"Check fragment" 2 pkt2.fragment;
        assert_equal ~msg:"Check fragmens" 2 pkt2.fragments;
        assert_equal ~msg:"Check id" (Some 4) pkt2.id;
        assert_equal ~msg:"Check channel" Sentence.A pkt2.channel;
        assert_equal ~msg:"Check padding" 2 pkt2.padding;

        let ais = Ais.of_sentences ([pkt1 ; pkt2]) in
        assert_equal ~msg:"Check channel" Sentence.A ais.channel;
        assert_equal ~printer:Int.to_string ~msg:"Check repeats" 0 ais.repeat_indicator;
        assert_equal ~printer:Int.to_string ~msg:"Check MMSI" 232066995 ais.mmsi;

        match ais.message with
        | Static_and_voyage_related_data msg -> (
            assert_equal ~msg:"Check ais version" (Ais.Future_editions 2) msg.ais_version;
            assert_equal ~printer:Int.to_string ~msg:"Check imo number" 1020306 msg.imo_number;
            assert_equal ~printer:(fun s -> s) ~msg:"Check call sign" "MTN09" msg.call_sign;
            assert_equal ~printer:(fun s -> s) ~msg:"Check ship name" "CT BIDSTON" msg.ship_name;
            assert_equal ~printer:Ais.show_ship_and_cargo_classification ~msg:"Check ship classification" Ais.Reserved_19 msg.ship_type;
            assert_equal ~printer:Int.to_string ~msg:"Check to_bow" 12 msg.to_bow;
            assert_equal ~printer:Int.to_string ~msg:"Check to_stern" 12 msg.to_stern;
            assert_equal ~printer:Int.to_string ~msg:"Check to_port" 5 msg.to_port;
            assert_equal ~printer:Int.to_string ~msg:"Check to_starboard" 7 msg.to_starboard;
            assert_equal ~printer:Ais.show_position_fix_type ~msg:"Check position fix type" Ais.GPS msg.position_fix_type;
            assert_equal ~printer:fmt_opt_int ~msg:"Check ETA month" (Some 11) msg.eta_month;
            assert_equal ~printer:fmt_opt_int ~msg:"Check ETA day" (Some 23) msg.eta_day;
            assert_equal ~printer:fmt_opt_int ~msg:"Check ETA hour" (Some 17) msg.eta_hour;
            assert_equal ~printer:fmt_opt_int ~msg:"Check ETA minute" (Some 30) msg.eta_minute;
            assert_equal ~printer:Int.to_string ~msg:"Check draught" 200 msg.draught;
            assert_equal ~printer:(fun s -> s) ~msg:"Check destination" "LIVERPOOL" msg.destination;
            assert_equal ~printer:Bool.to_string ~msg:"Check DTE" false msg.dte;

        )
        | _ -> assert false
    )
    | _ -> assert false

let test_simple_sar_aircraft_message_synthetic _ =
    let msg = "!AIVDM,1,1,,A,91b540AhQOwhKr0NW>`:S7P20000,0*27" in
    match Nmea.Parse.parse msg with
    | VDM vdm -> (
        assert_equal ~msg:"Check fragment" 1 vdm.fragment;
        assert_equal ~msg:"Check fragmens" 1 vdm.fragments;
        assert_equal ~msg:"Check id" None vdm.id;
        assert_equal ~msg:"Check channel" Sentence.A vdm.channel;
        assert_equal ~msg:"Check padding" 0 vdm.padding;

        let ais = Ais.of_sentences ([vdm]) in
        assert_equal ~msg:"Check channel" Sentence.A ais.channel;
        assert_equal ~printer:Int.to_string ~msg:"Check repeats" 0 ais.repeat_indicator;
        assert_equal ~printer:Int.to_string ~msg:"Check MMSI" 111232001 ais.mmsi;

        match ais.message with
        | Standard_SAR_aircraft_position_report msg -> (
            assert_equal ~msg:"Check time stamp" (Ais.Time_stamp 30 : Ais.time_stamp) msg.time_stamp;
            assert_equal ~cmp:cmp_opt_loc ~printer:fmt_opt_loc ~msg:"Check location" (Some ((53.5000, Coord.N), (3.4, Coord.W))) msg.location;
            assert_equal ~printer:fmt_opt_float ~msg:"Check speed" (Some 95.) msg.speed_over_ground;
            assert_equal ~printer:fmt_opt_float ~msg:"Check direction" (Some 270.) msg.course_over_ground;
            assert_equal ~printer:fmt_opt_int ~msg:"Check altitude" (Some 450) msg.altitude;
        )
        | _ -> assert false
    )
    | _ -> assert false

let test_simple_sar_aircraft_message_sentinel_synthetic _ =
    let msg = "!AIVDM,1,1,,A,91b540OwwwwhKr0NW>`>4?020000,0*23" in
    match Nmea.Parse.parse msg with
    | VDM vdm -> (
        assert_equal ~msg:"Check fragment" 1 vdm.fragment;
        assert_equal ~msg:"Check fragmens" 1 vdm.fragments;
        assert_equal ~msg:"Check id" None vdm.id;
        assert_equal ~msg:"Check channel" Sentence.A vdm.channel;
        assert_equal ~msg:"Check padding" 0 vdm.padding;

        let ais = Ais.of_sentences ([vdm]) in
        assert_equal ~msg:"Check channel" Sentence.A ais.channel;
        assert_equal ~printer:Int.to_string ~msg:"Check repeats" 0 ais.repeat_indicator;
        assert_equal ~printer:Int.to_string ~msg:"Check MMSI" 111232001 ais.mmsi;

        match ais.message with
        | Standard_SAR_aircraft_position_report msg -> (
            assert_equal ~msg:"Check time stamp" (Ais.Not_available : Ais.time_stamp) msg.time_stamp;
            assert_equal ~cmp:cmp_opt_loc ~printer:fmt_opt_loc ~msg:"Check location" (Some ((53.5000, Coord.N), (3.4, Coord.W))) msg.location;
            assert_equal ~printer:fmt_opt_float ~msg:"Check speed" None msg.speed_over_ground;
            assert_equal ~printer:fmt_opt_float ~msg:"Check direction" None msg.course_over_ground;
            assert_equal ~printer:fmt_opt_int ~msg:"Check altitude" None msg.altitude;
        )
        | _ -> assert false
    )
    | _ -> assert false



let test_simple_class_b_cs_position_report_message_synthetic _ =
  let msg = "!AIVDM,1,1,,B,B3P7@hP0?wtMc`7`vs0mLe7UWP06,0*4C" in
  match Nmea.Parse.parse msg with
  | VDM vdm -> (
      assert_equal ~msg:"Check fragment" 1 vdm.fragment;
      assert_equal ~msg:"Check fragmens" 1 vdm.fragments;
      assert_equal ~msg:"Check id" None vdm.id;
      assert_equal ~msg:"Check channel" Sentence.B vdm.channel;
      assert_equal ~msg:"Check padding" 0 vdm.padding;

      let ais = Ais.of_sentences ([vdm]) in
      assert_equal ~msg:"Check channel" Sentence.B ais.channel;
      assert_equal ~printer:Int.to_string ~msg:"Check repeats" 0 ais.repeat_indicator;
      assert_equal ~printer:Int.to_string ~msg:"Check MMSI" 235000002 ais.mmsi;

      match ais.message with
      | Standard_class_b_CS_position_report msg -> (
          assert_equal ~msg:"Check time stamp" (Ais.Time_stamp 15 : Ais.time_stamp) msg.time_stamp;
          assert_equal ~cmp:cmp_opt_loc ~printer:fmt_opt_loc ~msg:"Check location" (Some ((53.4100, Coord.N), (3.09, Coord.W))) msg.location;
          assert_equal ~printer:fmt_opt_float ~msg:"Check speed" (Some 6.3) msg.speed_over_ground;
          assert_equal ~printer:fmt_opt_float ~msg:"Check direction" (Some 85.5) msg.course_over_ground;
          assert_equal ~printer:fmt_opt_int ~msg:"Check heading" (Some 90) msg.true_heading;
      )
      | _ -> assert false
  )
  | _ -> assert false

let test_simple_class_b_cs_position_report_message_sentinel_synthetic _ =
  let msg = "!AIVDM,1,1,,B,B3P7@hP3wwtMc`7`vs3Q3wv5WP06,0*74" in
  match Nmea.Parse.parse msg with
  | VDM vdm -> (
      assert_equal ~msg:"Check fragment" 1 vdm.fragment;
      assert_equal ~msg:"Check fragmens" 1 vdm.fragments;
      assert_equal ~msg:"Check id" None vdm.id;
      assert_equal ~msg:"Check channel" Sentence.B vdm.channel;
      assert_equal ~msg:"Check padding" 0 vdm.padding;

      let ais = Ais.of_sentences ([vdm]) in
      assert_equal ~msg:"Check channel" Sentence.B ais.channel;
      assert_equal ~printer:Int.to_string ~msg:"Check repeats" 0 ais.repeat_indicator;
      assert_equal ~printer:Int.to_string ~msg:"Check MMSI" 235000002 ais.mmsi;

      match ais.message with
      | Standard_class_b_CS_position_report msg -> (
          assert_equal ~msg:"Check time stamp" (Ais.Not_available : Ais.time_stamp) msg.time_stamp;
          assert_equal ~cmp:cmp_opt_loc ~printer:fmt_opt_loc ~msg:"Check location" (Some ((53.4100, Coord.N), (3.09, Coord.W))) msg.location;
          assert_equal ~printer:fmt_opt_float ~msg:"Check speed" None msg.speed_over_ground;
          assert_equal ~printer:fmt_opt_float ~msg:"Check direction" None msg.course_over_ground;
          assert_equal ~printer:fmt_opt_int ~msg:"Check heading" None msg.true_heading;
      )
      | _ -> assert false
  )
  | _ -> assert false

let test_aid_to_navigation_synthetic_1 _ =
  let msg = "!AIVDM,1,1,,A,E>jFJ0LRd0V`62h1:WdhHP00000OpEAh?D:N010888b020,4*62" in
  match Nmea.Parse.parse msg with
  | VDM vdm -> (
      assert_equal ~msg:"Check fragment" 1 vdm.fragment;
      assert_equal ~msg:"Check fragmens" 1 vdm.fragments;
      assert_equal ~msg:"Check id" None vdm.id;
      assert_equal ~msg:"Check channel" Sentence.A vdm.channel;
      assert_equal ~msg:"Check padding" 4 vdm.padding;

      let ais = Ais.of_sentences ([vdm]) in
      assert_equal ~msg:"Check channel" Sentence.A ais.channel;
      assert_equal ~printer:Int.to_string ~msg:"Check repeats" 0 ais.repeat_indicator;
      assert_equal ~printer:Int.to_string ~msg:"Check MMSI" 992320001 ais.mmsi;

      match ais.message with
      | Aid_to_navigation_report msg -> (
          assert_equal ~cmp:cmp_opt_loc ~printer:fmt_opt_loc ~msg:"Check location" (Some ((53.53, Coord.N), (3.35, Coord.W))) msg.location;
          assert_equal ~printer:(fun x -> x) ~msg:"Check name" "EXAMPLE BUOY 1" msg.name;
          assert_equal ~printer:fmt_opt_int ~msg:"Check second" (Some 20) msg.second;
          assert_equal ~printer:Ais.show_aid_type ~msg:"Check type" Ais.Starboard_hand_mark msg.aid_type;
          assert_equal ~printer:Int.to_string ~msg:"Check to bow" 1 msg.to_bow;
          assert_equal ~printer:Int.to_string ~msg:"Check to stern" 1 msg.to_stern;
          assert_equal ~printer:Int.to_string ~msg:"Check to port" 1 msg.to_port;
          assert_equal ~printer:Int.to_string ~msg:"Check to starboard" 1 msg.to_starboard;
          assert_equal ~msg:"Check virtual flag" false msg.virtual_aid;
      )
      | _ -> assert false
  )
  | _ -> assert false

let test_aid_to_navigation_synthetic_2 _ =
  let msg = "!AIVDM,1,1,,A,E>jFJ0b;4a::PV@7@6Pa5P00000Opc@0?ELP000000v030,4*6F" in
  match Nmea.Parse.parse msg with
  | VDM vdm -> (
      assert_equal ~msg:"Check fragment" 1 vdm.fragment;
      assert_equal ~msg:"Check fragmens" 1 vdm.fragments;
      assert_equal ~msg:"Check id" None vdm.id;
      assert_equal ~msg:"Check channel" Sentence.A vdm.channel;
      assert_equal ~msg:"Check padding" 4 vdm.padding;

      let ais = Ais.of_sentences ([vdm]) in
      assert_equal ~msg:"Check channel" Sentence.A ais.channel;
      assert_equal ~printer:Int.to_string ~msg:"Check repeats" 0 ais.repeat_indicator;
      assert_equal ~printer:Int.to_string ~msg:"Check MMSI" 992320002 ais.mmsi;

      match ais.message with
      | Aid_to_navigation_report msg -> (
          assert_equal ~cmp:cmp_opt_loc ~printer:fmt_opt_loc ~msg:"Check location" (Some ((53.6, Coord.N), (3.2, Coord.W))) msg.location;
          assert_equal ~printer:(fun x -> x) ~msg:"Check name" "VIRTUAL N MARK" msg.name;
          assert_equal ~printer:fmt_opt_int ~msg:"Check second" None msg.second;
          assert_equal ~printer:Ais.show_aid_type ~msg:"Check type" Ais.Cardinal_mark_N msg.aid_type;
          assert_equal ~printer:Int.to_string ~msg:"Check to bow" 0 msg.to_bow;
          assert_equal ~printer:Int.to_string ~msg:"Check to stern" 0 msg.to_stern;
          assert_equal ~printer:Int.to_string ~msg:"Check to port" 0 msg.to_port;
          assert_equal ~printer:Int.to_string ~msg:"Check to starboard" 0 msg.to_starboard;
          assert_equal ~msg:"Check virtual flag" true msg.virtual_aid;
      )
      | _ -> assert false
  )
  | _ -> assert false

let test_aid_to_navigation_synthetic_3 _ =
  let msg = "!AIVDM,1,1,,A,E>jFJ0wVRa9Rdh10a@64ST:@;2awpLVP?Cvh0`50hhb024iC00,4*49" in
  match Nmea.Parse.parse msg with
  | VDM vdm -> (
      assert_equal ~msg:"Check fragment" 1 vdm.fragment;
      assert_equal ~msg:"Check fragmens" 1 vdm.fragments;
      assert_equal ~msg:"Check id" None vdm.id;
      assert_equal ~msg:"Check channel" Sentence.A vdm.channel;
      assert_equal ~msg:"Check padding" 4 vdm.padding;

      let ais = Ais.of_sentences ([vdm]) in
      assert_equal ~msg:"Check channel" Sentence.A ais.channel;
      assert_equal ~printer:Int.to_string ~msg:"Check repeats" 0 ais.repeat_indicator;
      assert_equal ~printer:Int.to_string ~msg:"Check MMSI" 992320003 ais.mmsi;

      match ais.message with
      | Aid_to_navigation_report msg -> (
          assert_equal ~cmp:cmp_opt_loc ~printer:fmt_opt_loc ~msg:"Check location" (Some ((53.52, Coord.N), (3.3, Coord.W))) msg.location;
          assert_equal ~printer:(fun x -> x) ~msg:"Check name" "MERSEY BAR LIGHT VESSEL" msg.name;
          assert_equal ~printer:fmt_opt_int ~msg:"Check second" (Some 20) msg.second;
          assert_equal ~printer:Ais.show_aid_type ~msg:"Check type" Ais.Light_vessel msg.aid_type;
          assert_equal ~printer:Int.to_string ~msg:"Check to bow" 40 msg.to_bow;
          assert_equal ~printer:Int.to_string ~msg:"Check to stern" 40 msg.to_stern;
          assert_equal ~printer:Int.to_string ~msg:"Check to port" 6 msg.to_port;
          assert_equal ~printer:Int.to_string ~msg:"Check to starboard" 6 msg.to_starboard;
          assert_equal ~msg:"Check virtual flag" false msg.virtual_aid;
      )
      | _ -> assert false
  )
  | _ -> assert false

let test_static_data_report_1 _ =
  let msg = "!AIVDM,1,1,,B,H3P7@i0EP4m0hF1T4<Q@00000000,0*0E" in
  match Nmea.Parse.parse msg with
  | VDM vdm -> (
      assert_equal ~msg:"Check fragment" 1 vdm.fragment;
      assert_equal ~msg:"Check fragmens" 1 vdm.fragments;
      assert_equal ~msg:"Check id" None vdm.id;
      assert_equal ~msg:"Check channel" Sentence.B vdm.channel;
      assert_equal ~msg:"Check padding" 0 vdm.padding;

      let ais = Ais.of_sentences ([vdm]) in
      assert_equal ~msg:"Check channel" Sentence.B ais.channel;
      assert_equal ~printer:Int.to_string ~msg:"Check repeats" 0 ais.repeat_indicator;
      assert_equal ~printer:Int.to_string ~msg:"Check MMSI" 235000004 ais.mmsi;

      match ais.message with
      | Static_data_report msg -> (
        match msg with
        | Part_a name -> (
          assert_equal ~printer:(fun x -> x) ~msg: "Check name" "EXAMPLE YACHT" name
        )
        | _ -> assert false
      )
      | _ -> assert false
  )
  | _ -> assert false

let test_static_data_report_2 _ =
  let msg = "!AIVDM,1,1,,B,H3P7@i4UDCD<30q=qDCD000h4220,0*2F" in
  match Nmea.Parse.parse msg with
  | VDM vdm -> (
      assert_equal ~msg:"Check fragment" 1 vdm.fragment;
      assert_equal ~msg:"Check fragmens" 1 vdm.fragments;
      assert_equal ~msg:"Check id" None vdm.id;
      assert_equal ~msg:"Check channel" Sentence.B vdm.channel;
      assert_equal ~msg:"Check padding" 0 vdm.padding;

      let ais = Ais.of_sentences ([vdm]) in
      assert_equal ~msg:"Check channel" Sentence.B ais.channel;
      assert_equal ~printer:Int.to_string ~msg:"Check repeats" 0 ais.repeat_indicator;
      assert_equal ~printer:Int.to_string ~msg:"Check MMSI" 235000004 ais.mmsi;

      match ais.message with
      | Static_data_report msg -> (
        match msg with
        | Part_b msg -> (
          assert_equal ~printer:Ais.show_ship_and_cargo_classification ~msg:"Check ship type" Ais.Pleasure_craft msg.ship_type;
          assert_equal ~printer:(fun x -> x) ~msg:"Check vendor id" "TST" msg.vendor_id;
          assert_equal ~printer:Int.to_string ~msg:"Check model" 3 msg.model;
          assert_equal ~printer:Int.to_string ~msg:"Check serial number" 12345 msg.serial_number;
          assert_equal ~printer:(fun x -> x) ~msg:"Check call sign" "M9TST" msg.call_sign;
          assert_equal ~printer:Int.to_string ~msg:"Check to bow" 6 msg.to_bow;
          assert_equal ~printer:Int.to_string ~msg:"Check to stern" 4 msg.to_stern;
          assert_equal ~printer:Int.to_string ~msg:"Check to port" 2 msg.to_port;
          assert_equal ~printer:Int.to_string ~msg:"Check to starboard" 2 msg.to_starboard;
        )
        | _ -> assert false
      )
      | _ -> assert false
  )
  | _ -> assert false


let test_static_data_report_3 _ =
  let msg = "!AIVDM,1,1,,B,H>`l3PA@E=A<PU21@Dp@E8000000,0*77" in
  match Nmea.Parse.parse msg with
  | VDM vdm -> (
      assert_equal ~msg:"Check fragment" 1 vdm.fragment;
      assert_equal ~msg:"Check fragmens" 1 vdm.fragments;
      assert_equal ~msg:"Check id" None vdm.id;
      assert_equal ~msg:"Check channel" Sentence.B vdm.channel;
      assert_equal ~msg:"Check padding" 0 vdm.padding;

      let ais = Ais.of_sentences ([vdm]) in
      assert_equal ~msg:"Check channel" Sentence.B ais.channel;
      assert_equal ~printer:Int.to_string ~msg:"Check repeats" 0 ais.repeat_indicator;
      assert_equal ~printer:Int.to_string ~msg:"Check MMSI" 982320001 ais.mmsi;

      match ais.message with
      | Static_data_report msg -> (
        match msg with
        | Part_a name -> (
          assert_equal ~printer:(fun x -> x) ~msg: "Check name" "TESTSHIP TENDER" name
        )
        | _ -> assert false
      )
      | _ -> assert false
  )
  | _ -> assert false

let test_static_data_report_4 _ =
  let msg = "!AIVDM,1,1,,B,H>`l3PDUDCD<30r=qD>400>0M3:0,0*5B" in
  match Nmea.Parse.parse msg with
  | VDM vdm -> (
      assert_equal ~msg:"Check fragment" 1 vdm.fragment;
      assert_equal ~msg:"Check fragmens" 1 vdm.fragments;
      assert_equal ~msg:"Check id" None vdm.id;
      assert_equal ~msg:"Check channel" Sentence.B vdm.channel;
      assert_equal ~msg:"Check padding" 0 vdm.padding;

      let ais = Ais.of_sentences ([vdm]) in
      assert_equal ~msg:"Check channel" Sentence.B ais.channel;
      assert_equal ~printer:Int.to_string ~msg:"Check repeats" 0 ais.repeat_indicator;
      assert_equal ~printer:Int.to_string ~msg:"Check MMSI" 982320001 ais.mmsi;

      match ais.message with
      | Static_data_report msg -> (
        match msg with
        | Part_b_aux msg -> (
          assert_equal ~printer:Ais.show_ship_and_cargo_classification ~msg:"Check ship type" Ais.Pleasure_craft msg.ship_type;
          assert_equal ~printer:(fun x -> x) ~msg:"Check vendor id" "TST" msg.vendor_id;
          assert_equal ~printer:Int.to_string ~msg:"Check model" 3 msg.model;
          assert_equal ~printer:Int.to_string ~msg:"Check serial number" 12346 msg.serial_number;
          assert_equal ~printer:(fun x -> x) ~msg:"Check call sign" "M9TND" msg.call_sign;
          assert_equal ~printer:Int.to_string ~msg:"Check to mothership mmsi" 235000010 msg.mothership_mmsi;
        )
        | _ -> assert false
      )
      | _ -> assert false
  )
  | _ -> assert false


let suite =
  "ais tests"
  >::: [
         "Test position message" >:: test_simple_positon_message;
         "Test position message synthetic" >:: test_simple_positon_message_synthetic;
         "Test base station message" >:: test_simple_base_station_message;
         "Test related data message" >:: test_related_data_message;
         "Test SAR synthetic" >:: test_simple_sar_aircraft_message_synthetic;
         "Test SAR sentinel" >:: test_simple_sar_aircraft_message_sentinel_synthetic;
         "Test Class B CS report synthetic" >:: test_simple_class_b_cs_position_report_message_synthetic;
          "Test Class B CS report sentinel synthetic" >:: test_simple_class_b_cs_position_report_message_sentinel_synthetic;
          "Test aid to navigation example 1" >:: test_aid_to_navigation_synthetic_1;
          "Test aid to navigation example 2" >:: test_aid_to_navigation_synthetic_2;
          "Test aid to navigation example 3" >:: test_aid_to_navigation_synthetic_3;
          "Test static data report 1" >:: test_static_data_report_1;
          "Test static data report 2" >:: test_static_data_report_2;
          "Test static data report 3" >:: test_static_data_report_3;
          "Test static data report 4" >:: test_static_data_report_4;
       ]

let () = run_test_tt_main suite
