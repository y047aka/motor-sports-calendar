module Races exposing (Race, Season, getServerResponse)

import Http
import Iso8601
import Json.Decode as Decode exposing (Decoder)
import Time exposing (Posix)



-- TYPES


type alias Season =
    { seriesName : String
    , season : String
    , races : List Race
    }


type alias Race =
    { posix : Posix
    , name : String
    }



-- DECODER


raceCategoryDecoder : Decoder Season
raceCategoryDecoder =
    Decode.map3 Season
        (Decode.field "seriesName" Decode.string)
        (Decode.field "season" Decode.string)
        (Decode.field "races" (Decode.list raceDecoder))


raceDecoder : Decoder Race
raceDecoder =
    Decode.map2 Race
        (Decode.field "date" Iso8601.decoder)
        (Decode.field "name" Decode.string)



-- API


getServerResponse : (Result Http.Error Season -> msg) -> String -> Cmd msg
getServerResponse msg url =
    Http.get
        { url = url
        , expect = Http.expectJson msg raceCategoryDecoder
        }
