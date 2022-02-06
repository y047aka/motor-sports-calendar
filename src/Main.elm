module Main exposing (main)

import Browser exposing (Document)
import Css exposing (..)
import Css.Global exposing (global)
import Css.Reset exposing (normalize)
import Css.ResetAndCustomize exposing (additionalReset, globalCustomize)
import Html.Styled as Html exposing (Html, a, div, footer, header, main_, p, span, text, toUnstyled)
import Html.Styled.Attributes as Attributes exposing (class, css, href)
import Page.HeatMap as HeatMap
import UI.Container exposing (container)
import UI.Segment exposing (verticalSegment)


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
    { title = "MotorSportsCalendar 2022"
    , body =
        [ global (normalize ++ additionalReset ++ globalCustomize)
        , siteHeader
        , container []
            (HeatMap.view model |> List.map (Html.map HeatMapMsg))
        , siteFooter
        ]
            |> List.map toUnstyled
    }


siteHeader : Html msg
siteHeader =
    verticalSegment { inverted = True }
        []
        [ container []
            [ a [] [ text "Motor Sports Calendar" ] ]
        ]


siteFooter : Html msg
siteFooter =
    verticalSegment { inverted = True }
        [ class "footer segment" ]
        [ container []
            [ div [ css [ textAlign right ] ]
                [ p []
                    [ text "© 2022 "
                    , a [ href "https://y047aka.space", Attributes.target "_blank" ] [ text "y047aka" ]
                    ]
                ]
            ]
        ]
