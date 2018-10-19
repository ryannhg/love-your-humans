module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)

main : Html msg
main =
    div [ class "app", style "color" "blue" ]
        [ text "Work in progress!"
        , button [] [ text "Click me, I do nothing!" ]
        ]