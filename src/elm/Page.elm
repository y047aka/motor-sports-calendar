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
    let
        dropdown label items =
            div []
                [ a [] [ text label ]
                , div [ class "navbar-dropdown" ] <|
                    List.map (\str -> a [] [ text str ]) items
                ]
    in
    header [ class "site-header" ]
        [ h1 []
            [ a [] [ text "Motor Sports Calendar" ] ]
        , nav [ class "header-navigation" ]
            [ div []
                [ dropdown "Year" [ "2019", "2020" ]
                , dropdown "Category" [ "2019", "2020" ]
                , dropdown "Area" [ "2019", "2020" ]
                ]
            ]
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
