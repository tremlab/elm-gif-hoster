module GifHosterTest exposing (all)

import GifHoster
import Html
import Html.Attributes exposing (src)
import ReneeGifLibrary as Library
import Test exposing (..)
import Test.Html.Query as Query
import Test.Html.Selector exposing (attribute, tag, text)
import TestContext exposing (..)


start : TestContext GifHoster.Msg GifHoster.Model (Cmd GifHoster.Msg)
start =
    TestContext.create
        { init = GifHoster.init Library.library
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
        , only <|
            test "searching for keywords and finding results" <|
                \() ->
                    start
                        |> fillIn "search" "Search" "funny"
                        |> clickButton "Search"
                        -- finds Riker/Klingong gif
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
