module Day3Test exposing (..)

import Day3
import Expect exposing (Expectation)
import Fixtures exposing (day3real, day3sample)
import Test exposing (..)


suite : Test
suite =
    describe "AOC 2020 day 3"
        [ test "solution1 sample" <|
            \_ ->
                let
                    count =
                        Day3.solution1 day3sample
                in
                Expect.equal 7 count

        , test "solution1 real" <|
            \_ ->
                let
                    count =
                        Day3.solution1 day3real
                in
                Expect.equal 262 count

        , test "solution2 sample" <|
            \_ ->
                let
                    count =
                        Day3.solution2 day3sample
                in
                Expect.equal 336 count

        , test "solution2 real" <|
            \_ ->
                let
                    count =
                        Day3.solution2 day3real
                in
                Expect.equal 2698900776 count
        ]
