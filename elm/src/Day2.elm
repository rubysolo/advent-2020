module Day2 exposing (..)

import Char
import Parser exposing ((|.), (|=), Parser, run, spaces, succeed, symbol)
import String


validPasswordCount : List String -> (PasswordPolicy -> Bool) -> Int
validPasswordCount inputs validator =
    inputs
        |> List.map
            (\line ->
                case Parser.run parsePolicy line of
                    Ok policy ->
                        policy

                    Err err ->
                        Debug.todo <| "error parsing line: " ++ line
            )
        |> List.filter validator
        |> List.length


validPasswordCount1 : List String -> Int
validPasswordCount1 inputs =
    validPasswordCount inputs validatePolicy1


validatePolicy1 : PasswordPolicy -> Bool
validatePolicy1 policy =
    let
        matchCount =
            policy.password
                |> String.toList
                |> List.filter ((==) policy.matchChar)
                |> List.length

        range =
            List.range policy.lo policy.hi
    in
    List.member matchCount range


validPasswordCount2 : List String -> Int
validPasswordCount2 inputs =
    validPasswordCount inputs validatePolicy2


validatePolicy2 : PasswordPolicy -> Bool
validatePolicy2 policy =
    let
        passwordChars =
            policy.password
                |> String.toList

        char1 =
            at (policy.lo - 1) passwordChars
                |> Maybe.withDefault '_'

        -- ridin' dirty
        char2 =
            at (policy.hi - 1) passwordChars
                |> Maybe.withDefault '_'
    in
    xor (char1 == policy.matchChar) (char2 == policy.matchChar)


at : Int -> List a -> Maybe a
at pos list =
    list
        |> List.drop pos
        |> List.head


type alias PasswordPolicy =
    { lo : Int
    , hi : Int
    , matchChar : Char
    , password : String
    }


lower : Parser Char
lower =
    Parser.chompIf Char.isLower
        |> Parser.getChompedString
        |> Parser.andThen stringToChar


stringToChar : String -> Parser Char
stringToChar str =
    case String.toList str of
        [ char ] ->
            succeed char

        _ ->
            Parser.problem <| "Expected a single character, but got: " ++ str



-- convert string like "1-2 a: aaaa" to a PasswordPolicy


parsePolicy : Parser PasswordPolicy
parsePolicy =
    succeed PasswordPolicy
        |= Parser.int
        -- lo
        |. symbol "-"
        |= Parser.int
        -- hi
        |. spaces
        |= lower
        -- matchChar
        |. symbol ":"
        |. spaces
        |= Parser.getChompedString (Parser.chompWhile Char.isLower)



--password
