module GifHosterTest exposing (all)

import Expect
import GifHoster
import Html
import Html.Attributes exposing (src)
import ReneeGifLibrary
import Test exposing (..)
import Test.Html.Event
import Test.Html.Query as Query
import Test.Html.Selector exposing (attribute, containing, id, tag, text)
import Test.Runner
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
        , test "searching for keywords and finding results" <|
            \() ->
                start
                    |> fillIn "search" "Search" "funny"
                    |> submitSearch
                    |> shouldHave [ text "Search results" ]
                    |> expectViewHas
                        [ tag "img"
                        , attribute (src "https://media.giphy.com/media/vKnmQ9Ky8wgTK/giphy.gif") -- "funny" gif
                        ]
        , test "searching for keywords and finding results (for another search term)" <|
            \() ->
                start
                    |> fillIn "search" "Search" "klingon"
                    |> submitSearch
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
                    |> submitSearch
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
                    |> submitSearch
                    |> fillIn "search" "Search" "sad"
                    |> expectViewHas
                        [ tag "img"
                        , attribute (src "https://media.giphy.com/media/vKnmQ9Ky8wgTK/giphy.gif") -- "funny" gif
                        ]
        , test "searching with no results shows a message" <|
            \() ->
                start
                    |> fillIn "search" "Search" "kjfhgkyrthnskdfjklsut"
                    |> submitSearch
                    |> expectViewHas
                        [ text "There are no images matching \"kjfhgkyrthnskdfjklsut\"."
                        ]
        , test "searching with no results shows the search results heading" <|
            \() ->
                start
                    |> fillIn "search" "Search" "kjfhgkyrthnskdfjklsut"
                    |> submitSearch
                    |> expectView
                        (Query.contains
                            [ Html.h3 [] [ Html.text "Search results" ] ]
                        )
        , test "does not search again until the search button is pressed." <|
            \() ->
                start
                    |> fillIn "search" "Search" "zxy123"
                    |> submitSearch
                    |> fillIn "search" "Search" "jlkluoiklukljkljok"
                    |> expectViewHas
                        [ text "There are no images matching \"zxy123\"."
                        ]
        , test "finding one gif for an IP" <|
            \() ->
                start
                    -- search field is left empty
                    |> selectOption "ip" "IP" "Sherlock" "Sherlock"
                    |> submitSearch
                    |> shouldHave [ text "Search results" ]
                    |> expectViewHas
                        [ tag "img"
                        , attribute (src "https://media.giphy.com/media/kioQjY5OshNNC/giphy.gif") -- "Sherlock scarf" gif
                        ]
        , test "finding all gifs for an IP" <|
            \() ->
                start
                    -- search field is left empty
                    |> selectOption "ip" "IP" "Sherlock" "Sherlock"
                    |> submitSearch
                    |> shouldHave [ text "Search results" ]
                    |> Expect.all
                        [ expectViewHas
                            [ tag "img"
                            , attribute (src "https://media.giphy.com/media/kioQjY5OshNNC/giphy.gif") -- "Sherlock scarf" gif
                            ]
                        , expectViewHas
                            [ tag "img"
                            , attribute (src "https://media.giphy.com/media/10ttqzrQQODtUk/giphy.gif") -- "Sherlock smiling" gif
                            ]
                        ]
        ]


{-| TODO: contribute this to <https://github.com/avh4/elm-program-test>

  - NOTE: `optionValue` will be removed in a future version of this API
  - NOTE: `fieldId` will be removed in a future version of this API

-}
selectOption : String -> String -> String -> String -> TestContext msg model effect -> TestContext msg model effect
selectOption fieldId label optionText optionValue testContext =
    let
        viewContainsLabel : Expect.Expectation
        viewContainsLabel =
            expectView
                (Query.find
                    [ tag "label"
                    , attribute (Html.Attributes.for fieldId)
                    , text label
                    ]
                    >> Query.has []
                )
                testContext

        viewContainsRequestedOption : Expect.Expectation
        viewContainsRequestedOption =
            TestContext.expectViewHas
                [ tag "select"
                , containing
                    [ tag "option"
                    , attribute (Html.Attributes.value optionValue)
                    , containing [ text optionText ]
                    ]
                ]
                testContext
    in
    case Test.Runner.getFailureReason viewContainsLabel of
        Nothing ->
            case Test.Runner.getFailureReason viewContainsRequestedOption of
                Nothing ->
                    simulate
                        -- TODO: make sure it's the select with the specified label
                        (Query.find [ tag "select", id fieldId ])
                        (Test.Html.Event.input optionValue)
                        testContext

                Just errorInfo ->
                    TestContext.fail "selectOption (option wasn't there)" errorInfo.description testContext

        Just errorInfo ->
            TestContext.fail "selectOption (label wasn't there)" errorInfo.description testContext


{-| Simulates what happens EITHER on pressing enter or clicking hte search button. (both cause the form to submit.)
-}
submitSearch : TestContext msg model effect -> TestContext msg model effect
submitSearch =
    simulate
        (Query.find [ tag "form" ])
        Test.Html.Event.submit
