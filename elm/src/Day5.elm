module Day5 exposing (..)

import Bitwise exposing (shiftLeftBy)

toSeatNumber : String -> Int
toSeatNumber code =
    let
        toBit char =
            case char of
               'F' -> 0
               'L' -> 0
               'B' -> 1
               'R' -> 1
               _ -> Debug.todo "inconceivable!"
    in
    code
    |> String.reverse
    |> String.toList
    |> List.indexedMap (\index char ->
        char
        |> toBit
        |> shiftLeftBy index
    )
    |> List.sum


-- find largest seat number in list
solution1 : List String -> Result String Int
solution1 input =
    input
    |> List.map toSeatNumber
    |> List.maximum
    |> Result.fromMaybe "could not find largest seat number"

findGap : List Int -> Result String Int
findGap list =
    case list of
        [] ->
            Err "could not find gap in list"
        [_] ->
            Err "could not find gap in list"
        x :: x_ :: xs ->
            if x + 1 == x_ then
                findGap (x_ :: xs)
            else
                Ok (x + 1)

-- find gap in seat numbers, which indicates the one empty seat
solution2 : List String -> Result String Int
solution2 input =
    input
    |> List.map toSeatNumber
    |> List.sort
    |> findGap
