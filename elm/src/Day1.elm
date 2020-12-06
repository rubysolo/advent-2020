module Day1 exposing (..)


uniquePairs : List a -> List ( a, a )
uniquePairs xs =
    case xs of
        [] ->
            []

        head :: tail ->
            List.map (\x -> ( head, x )) tail ++ uniquePairs tail


uniqueTriples : List a -> List ( a, a, a )
uniqueTriples xs =
    case xs of
        [] ->
            []

        head :: tail ->
            let
                pairs =
                    uniquePairs tail
            in
            List.map (\( x, y ) -> ( head, x, y )) pairs ++ uniqueTriples tail


product2 : List Int -> Int
product2 inputs =
    let
        -- create all permutations
        pairs =
            uniquePairs inputs

        -- map to (a, b, sum)
        withSums =
            List.map (\( a, b ) -> ( a, b, a + b )) pairs

        -- filter to (a, b, sum = 2020)
        ( a_, b_, sum_ ) =
            List.filter (\( a, b, sum ) -> sum == 2020) withSums
                |> List.head
                |> Maybe.withDefault ( 0, 0, 0 )
    in
    -- return a * b
    a_ * b_


product3 : List Int -> Int
product3 inputs =
    let
        -- create all permutations
        triples =
            uniqueTriples inputs

        -- map to (a, b, c, sum)
        withSums =
            List.map (\( a, b, c ) -> ( ( a, b, c ), a + b + c )) triples

        -- filter to (a, b, sum = 2020)
        ( ( a_, b_, c_ ), sum_ ) =
            List.filter (\( ( a, b, c ), sum ) -> sum == 2020) withSums
                |> List.head
                |> Maybe.withDefault ( ( 0, 0, 0 ), 0 )
    in
    -- return a * b * c
    a_ * b_ * c_
