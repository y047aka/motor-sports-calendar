module Weekend exposing (Weekend(..), weekend)

import Races exposing (Race)
import Time exposing (Posix, utc)
import Time.Extra as Time exposing (Interval(..))


type Weekend
    = Scheduled Race
    | Free
    | Past



-- PUBLIC HELPERS


weekend : Posix -> List Race -> Posix -> Weekend
weekend sundayPosix races currentPosix =
    let
        racesInThisWeek =
            races
                |> List.filter (isRaceWeek sundayPosix)

        hasRace =
            List.length racesInThisWeek > 0

        isPast =
            Time.diff Day utc sundayPosix currentPosix > 0
    in
    case ( hasRace, isPast ) of
        ( True, _ ) ->
            Scheduled
                (racesInThisWeek
                    |> List.reverse
                    |> List.head
                    |> Maybe.withDefault { name = "name", posix = Time.millisToPosix 0 }
                )

        ( _, True ) ->
            Past

        _ ->
            Free



-- PRIVATE


isRaceWeek : Posix -> Race -> Bool
isRaceWeek sundayPosix raceday =
    let
        diff =
            Time.diff Day utc raceday.posix sundayPosix
    in
    diff >= 0 && diff < 7
