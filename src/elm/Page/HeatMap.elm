module Page.HeatMap exposing (Model, Msg, init, update, view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onCheck)
import Http
import Iso8601
import List.Extra as List
import Races exposing (Race, Season, getServerResponse)
import Task
import Time exposing (Month(..), Posix)
import Time.Extra as Time exposing (Interval(..))
import Url.Builder exposing (crossOrigin)
import Weekend exposing (Weekend(..))



-- MODEL


type alias Model =
    { raceCategories : List Season
    , unselectedCategories : List String
    , time : Posix
    }


init : ( Model, Cmd Msg )
init =
    let
        filePathFromItem { category, season } =
            crossOrigin "https://y047aka.github.io" [ "MotorSportsData", "schedules", category, category ++ "_" ++ season ++ ".json" ] []
    in
    ( Model [] [] (Time.millisToPosix 0)
    , Cmd.batch <|
        Task.perform Tick Time.now
            :: List.map (filePathFromItem >> getServerResponse GotServerResponse)
                [ { category = "F1", season = "2020" }
                , { category = "FormulaE", season = "2019-20" }
                , { category = "WEC", season = "2019-20" }
                , { category = "WEC", season = "2020-21" }
                , { category = "IndyCar", season = "2020" }
                , { category = "IMSA", season = "2020" }
                , { category = "SuperGT", season = "2020" }
                , { category = "SuperFormula", season = "2020" }
                , { category = "SuperTaikyu", season = "2020" }

                -- , { category = "ELMS", season = "2019" }
                -- , { category = "NASCAR", season = "2019" }
                -- , { category = "DTM", season = "2019" }
                -- , { category = "BlancpainGT", season = "2019" }
                -- , { category = "IGTC", season = "2019" }
                -- , { category = "WTCR", season = "2019" }
                -- , { category = "WRC", season = "2019" }
                -- , { category = "MotoGP", season = "2019" }
                ]
    )



-- UPDATE


type Msg
    = Tick Posix
    | UpdateCategories String Bool
    | GotServerResponse (Result Http.Error Season)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick newTime ->
            ( { model | time = newTime }, Cmd.none )

        UpdateCategories category isChecked ->
            let
                updatedCategories =
                    if isChecked then
                        List.filter (\d -> not (d == category)) model.unselectedCategories

                    else
                        category :: model.unselectedCategories
            in
            ( { model | unselectedCategories = updatedCategories }, Cmd.none )

        GotServerResponse (Ok category) ->
            ( { model | raceCategories = List.sortWith compare (category :: model.raceCategories) }
            , Cmd.none
            )

        GotServerResponse (Err error) ->
            ( model, Cmd.none )


compare : Season -> Season -> Order
compare a b =
    let
        enumarate =
            [ "F1"
            , "Formula E"
            , "WEC"
            , "IndyCar"
            , "IMSA WSCC"
            , "SUPER GT"
            , "SUPER FORMULA"
            , "ELMS"
            , "NASCAR"
            , "DTM"
            , "Blancpain GT"
            , "IGTC"
            , "WTCR"
            , "Super Taikyu"
            , "WRC"
            , "MotoGP"
            , "Red Bull Air Race"
            ]
    in
    if a.seriesName == b.seriesName then
        EQ

    else
        case List.dropWhile (\x -> x /= a.seriesName && x /= b.seriesName) enumarate of
            x :: _ ->
                if x == a.seriesName then
                    LT

                else
                    GT

            _ ->
                LT



-- VIEW


view : Model -> Html Msg
view model =
    let
        start =
            Time.Parts 2020 Jan 1 0 0 0 0 |> Time.partsToPosix Time.utc

        until =
            start |> Time.add Year 1 Time.utc

        sundays =
            Time.range Sunday 1 Time.utc start until
    in
    section [ class "annual" ] <|
        viewHeatMapOptions model.unselectedCategories
            :: (model.raceCategories
                    |> List.filter (\series -> not (List.member series.seriesName model.unselectedCategories))
                    |> List.map
                        (\series ->
                            let
                                tableCaption =
                                    case series.season of
                                        "2020" ->
                                            series.seriesName

                                        _ ->
                                            series.seriesName ++ " (" ++ series.season ++ ")"
                            in
                            table [ class "heatmap" ]
                                [ caption [] [ text tableCaption ]
                                , viewTicks sundays
                                , viewRaces sundays series.races model.time
                                ]
                        )
               )


viewHeatMapOptions : List String -> Html Msg
viewHeatMapOptions unselectedCategories =
    let
        listItem d =
            li []
                [ input
                    [ id d.id
                    , type_ "checkbox"
                    , value d.value
                    , checked <| not (List.member d.value unselectedCategories)
                    , onCheck <| UpdateCategories d.value
                    ]
                    []
                , label [ for d.id ] [ text d.value ]
                ]
    in
    nav [ class "heatmap-options" ]
        [ ul [] <|
            List.map listItem
                [ { id = "f1", value = "F1" }
                , { id = "formulaE", value = "Formula E" }
                , { id = "wec", value = "WEC" }
                , { id = "wtcr", value = "WTCR" }
                , { id = "wrc", value = "WRC" }
                ]
        , ul [] <|
            List.map listItem
                [ { id = "indycar", value = "IndyCar" }
                , { id = "nascar", value = "NASCAR" }
                , { id = "wscc", value = "IMSA WSCC" }
                ]
        , ul [] <|
            List.map listItem
                [ { id = "superFormula", value = "SUPER FORMULA" }
                , { id = "superGT", value = "SUPER GT" }
                , { id = "superTaikyu", value = "Super Taikyu" }
                ]
        , ul [] <|
            List.map listItem
                [ { id = "dtm", value = "DTM" }
                , { id = "elms", value = "ELMS" }
                , { id = "blancpain", value = "Blancpain GT" }
                , { id = "igtc", value = "IGTC" }
                ]
        , ul [] <|
            List.map listItem
                [ { id = "motoGP", value = "MotoGP" }
                , { id = "rbar", value = "Red Bull Air Race" }
                ]
        ]


viewTicks : List Posix -> Html Msg
viewTicks sundays =
    let
        isBeginningOfMonth posix =
            Time.toDay Time.utc posix <= 7

        tableheader posix =
            if isBeginningOfMonth posix then
                th []
                    [ text <| stringFromMonth (Time.toMonth Time.utc posix) ]

            else
                th [] []
    in
    tr [] <|
        List.map tableheader sundays


viewRaces : List Posix -> List Race -> Posix -> Html Msg
viewRaces sundays races currentPosix =
    let
        tdCell sundayPosix =
            case Weekend.weekend sundayPosix races currentPosix of
                Scheduled race ->
                    td [ class "raceweek" ]
                        [ label []
                            [ text <| String.fromInt (Time.toDay Time.utc sundayPosix)
                            , input [ type_ "checkbox" ] []
                            , div []
                                [ text <| String.left 10 (Iso8601.fromTime race.posix)
                                , br [] []
                                , text race.name
                                ]
                            ]
                        ]

                Free ->
                    td [] []

                Past ->
                    td [ class "past" ] []
    in
    tr [] <|
        List.map tdCell sundays



-- PRIVATE


stringFromMonth : Time.Month -> String
stringFromMonth month =
    case month of
        Jan ->
            "Jan"

        Feb ->
            "Feb"

        Mar ->
            "Mar"

        Apr ->
            "Apr"

        May ->
            "May"

        Jun ->
            "Jun"

        Jul ->
            "Jul"

        Aug ->
            "Aug"

        Sep ->
            "Sep"

        Oct ->
            "Oct"

        Nov ->
            "Nov"

        Dec ->
            "Dec"
