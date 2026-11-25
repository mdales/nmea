open OUnit2
open Nmea

let test_simple_positon_message _ =
    let msg = "!AIVDM,1,1,,B,13P><k0P00Oi4EPNPeudJgvh08=e,0*70" in
    match Nmea.Parse.parse msg with
    | VDM vdm -> (
        assert_equal vdm.fragment 1;
        assert_equal vdm.fragments 1;
        assert_equal vdm.id None;
        assert_equal vdm.channel Sentence.B;
        assert_equal vdm.padding 0;

        let ais = Ais.of_sentences ([vdm]) in
        assert_equal ais.channel Sentence.B;
        assert_equal ais.message Ais.Position_report_class_a
    )
    | _ -> assert false

let test_simple_base_station_message _ =
    let msg = "!AIVDM,1,1,,A,402=ahQvbt`kCOj56nNUvPW008;f,0*1A" in
    match Nmea.Parse.parse msg with
    | VDM vdm -> (
        assert_equal vdm.fragment 1;
        assert_equal vdm.fragments 1;
        assert_equal vdm.id None;
        assert_equal vdm.channel Sentence.A;
        assert_equal vdm.padding 0;

        let ais = Ais.of_sentences ([vdm]) in
        assert_equal ais.channel Sentence.A;
        assert_equal ais.message Ais.Base_station_report
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
        assert_equal pkt1.fragment 1;
        assert_equal pkt1.fragments 2;
        assert_equal pkt1.id (Some 4);
        assert_equal pkt1.channel Sentence.A;
        assert_equal pkt1.padding 0;

        assert_equal pkt1.fragment 2;
        assert_equal pkt1.fragments 2;
        assert_equal pkt1.id (Some 4);
        assert_equal pkt1.channel Sentence.A;
        assert_equal pkt1.padding 2;
    )
    | _ -> assert false

let suite =
  "ais tests"
  >::: [
         "Test position message" >:: test_simple_positon_message;
         "Test base station message" >:: test_simple_base_station_message;
         "Test related data message" >:: test_related_data_message;
       ]

let () = run_test_tt_main suite
