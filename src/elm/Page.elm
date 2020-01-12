module Page exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)


view : Html msg -> List (Html msg)
view content =
    [ siteHeader
    , main_ [] [ content ]
    , siteFooter
    ]


siteHeader : Html msg
siteHeader =
    header [ class "site-header" ]
        [ h1 []
            [ a [] [ text "Motor Sports Calendar" ] ]
        ]


siteFooter : Html msg
siteFooter =
    footer [ class "site-footer" ]
        [ div []
            [ p [ class "copyright" ]
                [ text "© 2020 "
                , a [ href "https://y047aka.me", target "_blank" ] [ text "y047aka" ]
                ]
            ]
        ]
