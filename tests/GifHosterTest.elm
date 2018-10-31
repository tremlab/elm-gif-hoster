module GifHosterTest exposing (all)

import GifHoster
import Html.Attributes exposing (src)
import Test exposing (..)
import Test.Html.Selector exposing (attribute, tag, text)
import TestContext exposing (clickButton, expectViewHas)


all : Test
all =
    describe "gif-hoster-test"
        [ test "shows a gif on initial page load." <|
            \() ->
                TestContext.create
                    { init = GifHoster.init
                    , update = GifHoster.update
                    , view = GifHoster.view
                    }
                    |> expectViewHas
                        [ tag "img"
                        , attribute (src "https://media.giphy.com/media/piKaO6KOsO7ArDuiul/giphy.gif")
                        ]
        ]
