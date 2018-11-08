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
                        , attribute (src "https://media.giphy.com/media/vKnmQ9Ky8wgTK/giphy.gif") -- "funny" gif
                        ]
        , test "after initial search, don't search again until button is clicked" <|
            \() ->
                start
                    -- search for "funny"
                    |> fillIn "search" "Search" "funny"
                    |> clickButton "Search"
                    |> fillIn "search" "Search" "sad"
                    |> expectViewHas
                        [ tag "img"
                        , attribute (src "https://media.giphy.com/media/vKnmQ9Ky8wgTK/giphy.gif") -- "funny" gif
                        ]

        -- TODO: typing after searching once, shouldn't search again until you click the button
        -- TODO: search and get no results
        ]
