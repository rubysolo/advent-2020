module Day3 exposing (..)
import String

type alias Velocity =
    { right : Int
    , down : Int
    }

-- given a list of strings representing a forest tile (can expand infinitely rightward), rightward velocity, and
-- downward velocity, count number of tree collisions before reaching the bottom.  '#' = tree, '.' is open
countTrees : List String -> Velocity -> Int
countTrees field { right, down } =
    let
        -- take field rows that are hit
        hitRows =
            field
            |> List.indexedMap Tuple.pair  -- (0, ".#.#"), (1, "..#."), ...
            |> List.filter (\(idx, row) -> idx > 0 && modBy down idx == 0)
            |> List.map Tuple.second

        -- take grid squares that are on the path
        hitCells =
            hitRows
            |> List.indexedMap (cellFromRow right)

    in
    -- count trees
    hitCells
    |> List.filter ((==) '#')
    |> List.length

cellFromRow : Int -> Int -> String -> Char
cellFromRow rightVelocity rowIndex rowCells =
    let
        chars = String.toList rowCells

        index = modBy (List.length chars) ((rowIndex + 1) * rightVelocity)
    in
    at index chars |> Maybe.withDefault '_'

at : Int -> List a -> Maybe a
at pos list =
    list
    |> List.drop pos
    |> List.head

visualize : List String -> Velocity -> List String
visualize rows velocity =
        rows
        |> List.indexedMap (\rowIdx row ->
            if rowIdx > 0 && modBy velocity.down rowIdx == 0 then
                -- replace char with indicator: 'O' = open, 'X' = hit tree
                let
                    chars = String.toList row

                    rowHitIdx =
                        rowIdx // velocity.down
                in
                chars
                |> List.indexedMap (\charIdx char ->
                    if charIdx == modBy (List.length chars) (rowHitIdx * velocity.right) then
                        if char == '#' then
                            'X'
                        else
                            'O'
                    else
                        char
                )
                |> String.fromList
            else
                row
        )

{-
..##.......
#...#...#..
.#O...#..#.
..#.#...#.#
.#..O##..#.
..#.##.....
.#.#.#O...#
.#........#
#.##...#O..
#...##....#
.#..#...#.X
-}


solution1 : List String -> Int
solution1 rows =
    countTrees rows { right = 3, down = 1}

solution2 : List String -> Int
solution2 rows =
    let
        slopes : List Velocity
        slopes =
            [ { right = 1, down = 1 }
            , { right = 3, down = 1 }
            , { right = 5, down = 1 }
            , { right = 7, down = 1 }
            , { right = 1, down = 2 }
            ]

        hitCounts =
            List.map (countTrees rows) slopes

    in
    List.foldl (*) 1 hitCounts
