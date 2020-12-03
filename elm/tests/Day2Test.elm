module Day2Test exposing (..)

import Day2
import Expect exposing (Expectation)
import Fixtures exposing (day2real, day2sample)
import Test exposing (..)


suite : Test
suite =
    describe "AOC 2020 day 2"
        [ test "validPasswordCount1 sample input" <|
            \_ ->
                let
                    count =
                        Day2.validPasswordCount1 day2sample
                in
                Expect.equal 2 count
        , test "validPasswordCount1 real input" <|
            \_ ->
                let
                    count =
                        Day2.validPasswordCount1 day2real
                in
                Expect.equal 564 count
        , test "validPasswordCount2 sample input" <|
            \_ ->
                let
                    count =
                        Day2.validPasswordCount2 day2sample
                in
                Expect.equal 1 count
        , test "validPasswordCount2 real input" <|
            \_ ->
                let
                    count =
                        Day2.validPasswordCount2 day2real
                in
                Expect.equal 325 count
        ]
