module GifHosterTest exposing (all)

import Expect
import GifHoster
import Html
import Html.Attributes exposing (src)
import ReneeGifLibrary
import Test exposing (..)
import Test.Html.Event
import Test.Html.Query as Query
import Test.Html.Selector exposing (attribute, tag, text)
import TestContext exposing (..)


start : TestContext GifHoster.Msg GifHoster.Model (Cmd GifHoster.Msg)
start =
    TestContext.create
        { init = GifHoster.init ReneeGifLibrary.library
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
                        , attribute (src "https://media.giphy.com/media/3ohc1dHWofr304zNo4/giphy.gif")
                        ]
        , test "searching for keywords and finding results (clicking button)" <|
            \() ->
                start
                    |> fillIn "search" "Search" "funny"
                    |> clickButton "Search"
                    |> shouldHave [ text "Search results" ]
                    |> expectViewHas
                        [ tag "img"
                        , attribute (src "https://media.giphy.com/media/vKnmQ9Ky8wgTK/giphy.gif") -- "funny" gif
                        ]
        , test "searching for keywords and finding results (pressing enter)" <|
            \() ->
                start
                    |> fillIn "search" "Search" "funny"
                    |> simulate
                        (Query.find [ tag "form" ])
                        Test.Html.Event.submit
                    |> shouldHave [ text "Search results" ]
                    |> expectViewHas
                        [ tag "img"
                        , attribute (src "https://media.giphy.com/media/vKnmQ9Ky8wgTK/giphy.gif") -- "funny" gif
                        ]
        , test "searching for keywords and finding results (for another search term)" <|
            \() ->
                start
                    |> fillIn "search" "Search" "klingon"
                    |> clickButton "Search"
                    -- finds Riker/Klingong gif
                    |> shouldHave [ text "Search results" ]
                    |> expectViewHas
                        [ tag "img"
                        , attribute (src "https://media.giphy.com/media/vKnmQ9Ky8wgTK/giphy.gif") -- "funny" gif
                        ]
        , test "searching for a keyword and finding multiple results." <|
            \() ->
                start
                    |> fillIn "search" "Search" "scarf"
                    |> clickButton "Search"
                    |> shouldHave [ text "Search results" ]
                    |> Expect.all
                        [ expectViewHas
                            [ tag "img"
                            , attribute (src "https://media.giphy.com/media/kioQjY5OshNNC/giphy.gif") -- "sherlock" gif
                            ]
                        , expectViewHas
                            [ tag "img"
                            , attribute (src "https://media.giphy.com/media/8cryeowqTlIs0/giphy.gif") -- "minions" gif
                            ]
                        ]
        , test "after initial search, don't search again until button is clicked" <|
            \() ->
                start
                    |> fillIn "search" "Search" "funny"
                    |> clickButton "Search"
                    |> fillIn "search" "Search" "sad"
                    |> expectViewHas
                        [ tag "img"
                        , attribute (src "https://media.giphy.com/media/vKnmQ9Ky8wgTK/giphy.gif") -- "funny" gif
                        ]
        , test "searching with no results shows a message" <|
            \() ->
                start
                    |> fillIn "search" "Search" "kjfhgkyrthnskdfjklsut"
                    |> clickButton "Search"
                    |> expectViewHas
                        [ text "There are no images matching \"kjfhgkyrthnskdfjklsut\"."
                        ]
        , test "searching with no results shows the search results heading" <|
            \() ->
                start
                    |> fillIn "search" "Search" "kjfhgkyrthnskdfjklsut"
                    |> clickButton "Search"
                    |> expectView
                        (Query.contains
                            [ Html.h3 [] [ Html.text "Search results" ] ]
                        )
        , test "does not search again until the search button is pressed." <|
            \() ->
                start
                    |> fillIn "search" "Search" "zxy123"
                    |> clickButton "Search"
                    |> fillIn "search" "Search" "jlkluoiklukljkljok"
                    |> expectViewHas
                        [ text "There are no images matching \"zxy123\"."
                        ]
        ]
