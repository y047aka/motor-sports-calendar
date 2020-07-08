module Main exposing (main)

import Browser exposing (Document)
import Html
import Page
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
    , body = Page.view (HeatMap.view model |> List.map (Html.map HeatMapMsg))
    }
