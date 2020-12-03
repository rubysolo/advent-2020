module Day1Test exposing (..)

import Day1
import Expect exposing (Expectation)
import Fixtures exposing (day1real, day1sample)
import Test exposing (..)


suite : Test
suite =
    describe "AOC 2020 day 1"
        [ test "product2 sample input" <|
            \_ ->
                let
                    product =
                        Day1.product2 day1sample
                in
                Expect.equal 514579 product
        , test "product 2 real input" <|
            \_ ->
                let
                    product =
                        Day1.product2 day1real
                in
                Expect.equal 913824 product
        , test "product3 sample input" <|
            \_ ->
                let
                    product =
                        Day1.product3 day1sample
                in
                Expect.equal 241861950 product
        , test "product3 real input" <|
            \_ ->
                let
                    product =
                        Day1.product3 day1real
                in
                Expect.equal 240889536 product
        ]
