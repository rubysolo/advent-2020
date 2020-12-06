module Day4Test exposing (..)

import Day4 exposing (Passport)
import Expect exposing (Expectation)
import Fixtures exposing (day4invalid, day4real, day4sample, day4valid)
import Test exposing (..)


suite : Test
suite =
    describe "AOC 2020 day 4"
        [ test "parsePassport" <|
            \_ ->
                let
                    passportChunk =
                        """
                        ecl:gry pid:860033327 eyr:2020 hcl:#fffffd
                        byr:1937 iyr:2017 cid:147 hgt:183cm
                        """

                    parsed =
                        Ok
                            { birthYear = 1937
                            , countryId = Just "147"
                            , expirationYear = 2020
                            , eyeColor = Day4.Gray
                            , hairColor = "fffffd"
                            , height = Day4.Centimeter 183
                            , issueYear = 2017
                            , passportId = "860033327"
                            }
                in
                Expect.equal (Day4.parsePassport passportChunk) parsed
        , test "parsePassport missing cid" <|
            \_ ->
                let
                    passportChunk =
                        """
                        ecl:gry pid:860033327 eyr:2020 hcl:#fffffd
                        byr:1937 iyr:2017 hgt:183cm
                        """

                    parsed =
                        Ok
                            { birthYear = 1937
                            , countryId = Nothing
                            , expirationYear = 2020
                            , eyeColor = Day4.Gray
                            , hairColor = "fffffd"
                            , height = Day4.Centimeter 183
                            , issueYear = 2017
                            , passportId = "860033327"
                            }
                in
                Expect.equal (Day4.parsePassport passportChunk) parsed
        , test "solution1 sample" <|
            \_ ->
                let
                    count =
                        Day4.solution1 day4sample
                in
                Expect.equal 2 count
        , test "solution1 real" <|
            \_ ->
                let
                    count =
                        Day4.solution1 day4real
                in
                Expect.equal 196 count
        , test "part 2 all valid" <|
            \_ ->
                let
                    allPassports =
                        Day4.parsePassports day4valid

                    validPassports =
                        allPassports
                            |> List.filter Day4.validatePassport
                in
                Expect.equal (List.length allPassports) (List.length validPassports)
        , test "part 2 all invalid" <|
            \_ ->
                let
                    allPassports =
                        Day4.parsePassports day4invalid

                    validPassports =
                        allPassports
                            |> List.filter Day4.validatePassport
                in
                Expect.equal 0 (List.length validPassports)
        , test "solution2 real" <|
            \_ ->
                let
                    count =
                        Day4.solution2 day4real
                in
                Expect.equal 114 count
        ]
