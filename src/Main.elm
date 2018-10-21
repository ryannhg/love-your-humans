port module Main exposing (main)

import Browser
import Css exposing (..)
import Css.Transitions exposing (easeInOut, transition)
import Html
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (css, href, type_, value)
import Html.Styled.Events exposing (onClick, onInput, onSubmit)
import Json.Encode as E


port outgoing : E.Value -> Cmd msg


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
    = GetStarted
    | UpdateFormValue Field String
    | AddHuman
    | RemoveHuman Human


type alias Flags =
    { humans : List Human
    }


type alias Notification =
    { title : String
    , body : String
    }


type OutgoingMessage
    = StoreHuman Human
    | UnstoreHuman Human
    | RequestNotificationPermissions
    | SendNotification Notification


toJs : OutgoingMessage -> E.Value
toJs message =
    case message of
        StoreHuman human ->
            action "STORE_HUMAN" (encodeHuman human)

        UnstoreHuman human ->
            action "UNSTORE_HUMAN" (encodeHuman human)

        RequestNotificationPermissions ->
            action "REQUEST_NOTIFICATION_PERMISSIONS" E.null

        SendNotification notification ->
            action "SEND_NOTIFICATION" (encodeNotification notification)


action : String -> E.Value -> E.Value
action action_ data_ =
    E.object
        [ ( "action", E.string action_ )
        , ( "data", data_ )
        ]


encodeHuman : Human -> E.Value
encodeHuman human =
    E.object
        [ ( "name", E.string human.name )
        , ( "phone", E.string human.phone )
        ]


encodeNotification : Notification -> E.Value
encodeNotification notification =
    E.object
        [ ( "title", E.string notification.title )
        , ( "options"
          , E.object
                [ ( "body", E.string notification.body )
                ]
          )
        ]


main =
    Browser.element
        { init = init
        , update = update
        , view = toUnstyled << view
        , subscriptions = always Sub.none
        }


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( Model
        (if List.isEmpty flags.humans then
            MainMenu

         else
            HumansPage
        )
        flags.humans
        ""
        ""
    , sendNotification flags.humans
    )


sendNotification : List Human -> Cmd Msg
sendNotification humans =
    case List.head humans of
        Just human ->
            outgoing <|
                toJs
                    (SendNotification
                        (Notification
                            ("Text " ++ human.name ++ "!")
                            human.phone
                        )
                    )

        Nothing ->
            Cmd.none


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GetStarted ->
            ( { model | page = HumansPage }
            , outgoing <| toJs RequestNotificationPermissions
            )

        UpdateFormValue field newValue ->
            case field of
                Name ->
                    ( { model | name = newValue }, Cmd.none )

                Phone ->
                    ( { model | phone = newValue }, Cmd.none )

        AddHuman ->
            let
                human : Human
                human =
                    Human model.name model.phone
            in
            if String.length model.name > 0 && String.length model.phone > 0 then
                ( { model
                    | humans = model.humans ++ [ human ]
                    , name = ""
                    , phone = ""
                  }
                , outgoing <| toJs (StoreHuman human)
                )

            else
                ( model, Cmd.none )

        RemoveHuman human ->
            ( { model
                | humans =
                    List.filter
                        (\h -> h /= human)
                        model.humans
              }
            , outgoing <| toJs (UnstoreHuman human)
            )


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
            , onClick GetStarted
            ]
            [ text "Get started" ]
        ]


viewHumansPage : Model -> Html Msg
viewHumansPage model =
    div
        [ css
            [ overflow auto
            , height (pct 100)
            ]
        ]
        [ div
            [ css
                [ width (pct 100)
                , boxSizing borderBox
                , padding2 spacing.large spacing.small
                , maxWidth (px 540)
                , margin2 zero auto
                ]
            ]
            [ viewTitle
                (if List.isEmpty model.humans then
                    "Enter a human!"

                 else
                    "Your humans:"
                )
            , viewHumans model.humans
            , viewForm model
            ]
        ]


viewHumans : List Human -> Html Msg
viewHumans humans =
    div [ classes.humans.list ] <|
        List.map
            viewHuman
            humans


viewHuman : Human -> Html Msg
viewHuman human =
    div [ classes.humans.item ]
        [ div [ classes.humans.info ]
            [ h4 [ classes.humans.name ] [ text human.name ]
            , a [ classes.humans.phone, href ("tel:" ++ human.phone) ]
                [ text human.phone ]
            ]
        , button [ classes.button, onClick (RemoveHuman human) ]
            [ text "Remove" ]
        ]


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
    { tiny = px 8
    , small = px 12
    , medium = px 24
    , large = px 36
    }


colors =
    { white = hex "fff"
    , yellow = hex "ffc371"
    , pink = hex "ff5f6d"
    , black = hex "000"
    }


fonts =
    { fancy = fontFamilies [ "Playfair Display" ]
    }


classes =
    { app =
        css
            [ backgroundImage (linearGradient (stop colors.yellow) (stop colors.pink) [])
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
            [ textAlign left
            , width (px 480)
            , maxWidth (pct 100)
            , marginTop spacing.large
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
    , humans =
        { list =
            css
                [ width (pct 100)
                , maxWidth (px 480)
                ]
        , item =
            css
                [ width (pct 100)
                , displayFlex
                , alignItems center
                , paddingTop spacing.medium
                ]
        , info = css [ flex (int 1), textAlign left ]
        , name =
            css
                [ fontSize (rem 1.5)
                , fonts.fancy
                , margin zero
                , marginBottom spacing.tiny
                ]
        , phone =
            css
                [ color inherit
                , display inlineBlock
                ]
        }
    , title =
        css
            [ fonts.fancy
            , fontSize (rem 3.5)
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
