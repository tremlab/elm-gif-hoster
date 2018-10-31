module GifHosterTest exposing (all)

import GifHoster
import Html.Attributes exposing (src)
import Test exposing (..)
import Test.Html.Selector exposing (attribute, tag, text)
import TestContext exposing (..)


start : TestContext GifHoster.Msg GifHoster.Model (Cmd GifHoster.Msg)
start =
    TestContext.create
        { init = GifHoster.init
        , update = GifHoster.update
        , view = GifHoster.view
        }


all : Test
all =
    describe "gif-hoster-test"
        [ test "shows a gif on initial page load." <|
            \() ->
                start
                    |> expectViewHas
                        [ tag "img"
                        , attribute (src "https://media.giphy.com/media/piKaO6KOsO7ArDuiul/giphy.gif")
                        ]
        , test "searching for keywords and finding results" <|
            \() ->
                start
                    -- search for "funny"
                    |> fillIn "search" "Search" "funny"
                    |> clickButton "Search"
                    -- finds Riker/Klingong gif
                    |> shouldHave [ text "Search results" ]
                    |> expectViewHas
                        [ tag "img"
                        , attribute (src "https://media.giphy.com/media/vKnmQ9Ky8wgTK/giphy.gif")
                        ]

        -- TODO: search and get no results
        ]
