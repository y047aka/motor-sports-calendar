module Page exposing (view)

import Html.Styled exposing (Html, a, div, footer, header, main_, p, span, text)
import Html.Styled.Attributes exposing (class, href, target)


view : List (Html msg) -> List (Html msg)
view contents =
    [ siteHeader
    , main_ [ class "ui main container" ] contents
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
            [ div [ class "ui right floated horizontal list" ]
                [ p [ class "item" ]
                    [ text "© 2020 "
                    , a [ href "https://y047aka.me", target "_blank" ] [ text "y047aka" ]
                    ]
                ]
            ]
        ]
