module Main exposing (main)

import Browser
import Css exposing (..)
import Css.Transitions exposing (easeInOut, transition)
import Html
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (css, type_, value)
import Html.Styled.Events exposing (onClick, onInput, onSubmit)


type alias Model =
    { page : Page
    , humans : List Human
    , name : String
    , phone : String
    }


type alias Human =
    { name : String
    , phone : String
    }


type Field
    = Name
    | Phone


type Page
    = MainMenu
    | HumansPage


type Msg
    = GoToHumansPage
    | UpdateFormValue Field String
    | AddHuman


main =
    Browser.sandbox
        { init = initialModel
        , update = update
        , view = toUnstyled << view
        }


initialModel : Model
initialModel =
    Model
        HumansPage
        []
        "Andrew"
        ""


update : Msg -> Model -> Model
update msg model =
    case msg of
        GoToHumansPage ->
            { model | page = HumansPage }

        UpdateFormValue field newValue ->
            case field of
                Name ->
                    { model | name = newValue }

                Phone ->
                    { model | phone = newValue }

        AddHuman ->
            if String.length model.name > 0 && String.length model.phone > 0 then
                { model
                    | humans =
                        model.humans
                            ++ [ Human model.name model.phone
                               ]
                    , name = ""
                    , phone = ""
                }

            else
                model


view : Model -> Html Msg
view model =
    div [ classes.app ]
        [ viewPage model ]


viewPage : Model -> Html Msg
viewPage model =
    case model.page of
        MainMenu ->
            viewMainMenu

        HumansPage ->
            viewHumansPage model


viewMainMenu : Html Msg
viewMainMenu =
    div [ classes.page ]
        [ viewTitle "Love your humans!"
        , h2
            [ classes.subtitle
            ]
            [ text "Remind yourself to remind your humans you love them." ]
        , button
            [ classes.button
            , onClick GoToHumansPage
            ]
            [ text "Get started" ]
        ]


viewHumansPage : Model -> Html Msg
viewHumansPage model =
    div [ classes.page ]
        [ viewTitle "Enter a human!"
        , viewHumans model.humans
        , viewForm model
        ]


viewHumans : List Human -> Html Msg
viewHumans humans =
    ul [] <|
        List.map
            (\human -> li [] [ text human.name ])
            humans


viewForm : Model -> Html Msg
viewForm model =
    form [ classes.form, onSubmit AddHuman ]
        [ viewInput "Name" Name model.name
        , viewInput "Phone Number" Phone model.phone
        , div
            [ css
                [ displayFlex
                , justifyContent flexEnd
                ]
            ]
            [ button
                [ classes.button
                , css
                    [ marginTop (rem 1)
                    , width (px 200)
                    ]
                ]
                [ text "Add human!" ]
            ]
        ]


viewInput : String -> Field -> String -> Html Msg
viewInput label_ field value_ =
    label [ classes.input.label ]
        [ span [ classes.input.span ] [ text label_ ]
        , input
            [ type_ "text"
            , classes.input.field
            , value value_
            , onInput (UpdateFormValue field)
            ]
            []
        ]


viewTitle : String -> Html Msg
viewTitle title_ =
    h1 [ classes.title ] [ text title_ ]


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


classes =
    { app =
        css
            [ fonts.sansSerif
            , backgroundImage (linearGradient (stop colors.yellow) (stop colors.pink) [])
            , color colors.white
            , height (pct 100)
            ]
    , page =
        css
            [ displayFlex
            , flexDirection column
            , height (pct 100)
            , justifyContent center
            , alignItems center
            , textAlign center
            , padding spacing.medium
            , boxSizing borderBox
            ]
    , form =
        css
            [ displayFlex
            , flexDirection column
            , textAlign left
            , width (px 480)
            , maxWidth (pct 100)
            , marginTop spacing.medium
            ]
    , input =
        { label =
            css
                [ displayFlex
                , flexDirection column
                , justifyContent flexStart
                , marginTop spacing.small
                ]
        , span =
            css
                [ fontSize (rem 1.25)
                , fonts.fancy
                ]
        , field =
            css
                [ width (pct 100)
                , padding2 (rem 0.25) (rem 0)
                , backgroundColor transparent
                , border zero
                , borderBottom3 (px 2) solid colors.white
                , color colors.white
                , fontFamily inherit
                , fontSize (rem 1.25)
                ]
        }
    , title =
        css
            [ fonts.fancy
            , fontSize (rem 4)
            , margin zero
            , marginBottom spacing.small
            , lineHeight (rem 4.25)
            ]
    , subtitle =
        css
            [ fontWeight normal
            , fontSize (rem 1.25)
            , margin zero
            , marginBottom spacing.medium
            ]
    , button =
        css
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
    }
