module Page exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)


view : Html msg -> List (Html msg)
view content =
    [ siteHeader
    , main_ [ class "ui main container" ] [ content ]
    , siteFooter
    ]


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
            [ p [ class "copyright" ]
                [ text "© 2020 "
                , a [ href "https://y047aka.me", target "_blank" ] [ text "y047aka" ]
                ]
            ]
        ]
