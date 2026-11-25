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
        (* assert_equal ~printer:print_msg_type ~msg:"Check message" Ais.Static_and_voyage_related_data ais.message; *)
        assert_equal ~printer:Int.to_string ~msg:"Check repeats" 0 ais.repeat_indicator;
        assert_equal ~printer:Int.to_string ~msg:"Check MMSI" 232066995 ais.mmsi;
    )
    | _ -> assert false

let suite =
  "ais tests"
  >::: [
         "Test position message" >:: test_simple_positon_message;
         "Test position message synthetic" >:: test_simple_positon_message_synthetic;
         "Test base station message" >:: test_simple_base_station_message;
         "Test related data message" >:: test_related_data_message;
       ]

let () = run_test_tt_main suite
