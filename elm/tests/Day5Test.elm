module Day5Test exposing (..)

import Day5
import Expect exposing (Expectation)
import Fixtures exposing (day5real, day5sample)
import Test exposing (..)


suite : Test
suite =
    describe "AOC 2020 day 5"
        [ test "solution 1 sample input" <|
            \_ ->
                Expect.equal (Ok 357) (Day5.solution1 day5sample)

        , test "solution 1 real input" <|
            \_ ->
                Expect.equal (Ok 878) (Day5.solution1 day5real)

        , test "solution 2 real input" <|
            \_ ->
                Expect.equal (Ok 504) (Day5.solution2 day5real)
        ]
