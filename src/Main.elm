module Main exposing (main)

import Css exposing (..)
import Css.Transitions exposing (easeInOut, transition)
import Html
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (css)
import Html.Styled.Events exposing (onClick)


main =
    toUnstyled view


spacing =
    { small = px 12
    , medium = px 24
    }


colors =
    { white = hex "fff"
    , yellow = hex "ffc371"
    , pink = hex "ff5f6d"
    , black = hex "000"
    }


fonts =
    { fancy = fontFamilies [ "Playfair Display" ]
    , sansSerif = fontFamilies [ "Lato" ]
    }


view : Html msg
view =
    div
        [ css
            [ displayFlex
            , flexDirection column
            , height (pct 100)
            , justifyContent center
            , alignItems center
            , textAlign center
            , fonts.sansSerif
            , backgroundImage (linearGradient (stop colors.yellow) (stop colors.pink) [])
            , color colors.white
            , padding spacing.medium
            , boxSizing borderBox
            ]
        ]
        [ h1
            [ css
                [ fonts.fancy
                , fontSize (rem 4)
                , margin zero
                , marginBottom spacing.small
                , lineHeight (rem 4.25)
                ]
            ]
            [ text "Love your humans!" ]
        , h2
            [ css
                [ fontWeight normal
                , fontSize (rem 1.25)
                , margin zero
                , marginBottom spacing.medium
                ]
            ]
            [ text "Remind yourself to remind your friends you love them." ]
        , button
            [ css
                [ backgroundColor transparent
                , border3 (px 1) solid colors.white
                , color colors.white
                , fontFamily inherit
                , fontSize (rem 1.25)
                , borderRadius (px 6)
                , padding2 (rem 0.5) (rem 1.25)
                , fonts.fancy
                , letterSpacing (px 0.75)
                , cursor pointer
                , transition
                    [ Css.Transitions.color 300
                    , Css.Transitions.backgroundColor 300
                    ]
                , hover
                    [ backgroundColor colors.white
                    , color colors.black
                    ]
                ]
            ]
            [ text "Get started" ]
        ]
