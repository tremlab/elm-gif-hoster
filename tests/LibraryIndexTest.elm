module LibraryIndexTest exposing (all)

import Expect
import LibraryIndex
import Test exposing (..)


all : Test
all =
    describe "LibraryIndex"
        [ test "searching by keyword finds a gif." <|
            \() ->
                LibraryIndex.fromGifs
                    [ { url = "#1"
                      , keywords = [ "funny" ]
                      }
                    ]
                    |> LibraryIndex.search "funny"
                    |> Expect.equal [ "#1" ]
        , test "a single gif has multiple keywords" <|
            \() ->
                LibraryIndex.fromGifs
                    [ { url = "#1"
                      , keywords = [ "funny", "klingon" ]
                      }
                    ]
                    |> LibraryIndex.search "klingon"
                    |> Expect.equal [ "#1" ]
        , test "searching by keyword and finding multiple gifs" <|
            \() ->
                LibraryIndex.fromGifs
                    [ { url = "#1"
                      , keywords = [ "funny" ]
                      }
                    , { url = "#2"
                      , keywords = [ "funny" ]
                      }
                    ]
                    |> LibraryIndex.search "funny"
                    |> Expect.equal [ "#1", "#2" ]

        -- TODO: multiple images have the same keyword
        ]
