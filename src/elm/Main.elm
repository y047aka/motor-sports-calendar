module Main exposing (main)

import Browser exposing (Document)
import Html.Styled as Html exposing (Html, a, div, footer, header, main_, p, span, text, toUnstyled)
import Html.Styled.Attributes exposing (class, href, target)
import Page.HeatMap as HeatMap


main : Program () Model Msg
main =
    Browser.document
        { init = init
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        }



-- MODEL


type alias Model =
    HeatMap.Model


init : () -> ( Model, Cmd Msg )
init _ =
    HeatMap.init |> stepHeatMap



-- UPDATE


type Msg
    = HeatMapMsg HeatMap.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case message of
        HeatMapMsg msg ->
            stepHeatMap (HeatMap.update msg model)


stepHeatMap : ( HeatMap.Model, Cmd HeatMap.Msg ) -> ( Model, Cmd Msg )
stepHeatMap ( model, cmds ) =
    ( model, Cmd.map HeatMapMsg cmds )



-- VIEW


view : Model -> Document Msg
view model =
    { title = "MotorSportsCalendar 2020"
    , body =
        [ siteHeader
        , main_ [ class "ui main container" ]
            (HeatMap.view model |> List.map (Html.map HeatMapMsg))
        , siteFooter
        ]
            |> List.map toUnstyled
    }


siteHeader : Html msg
siteHeader =
    header [ class "ui inverted vertical segment" ]
        [ div [ class "ui container" ]
            [ span [ class "header item" ]
                [ a [] [ text "Motor Sports Calendar" ] ]
            ]
        ]


siteFooter : Html msg
siteFooter =
    footer [ class "ui inverted vertical footer segment" ]
        [ div [ class "ui container" ]
            [ div [ class "ui right floated horizontal list" ]
                [ p [ class "item" ]
                    [ text "© 2020 "
                    , a [ href "https://y047aka.me", target "_blank" ] [ text "y047aka" ]
                    ]
                ]
            ]
        ]
