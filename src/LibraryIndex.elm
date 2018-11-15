module LibraryIndex exposing (LibraryIndex, fromGifs, initialImage, search)

import Dict exposing (Dict)
import LibraryData


type LibraryIndex
    = LibraryIndex
        { keywordLookup : Dict String String
        }


fromGifs : List LibraryData.Gif -> LibraryIndex
fromGifs gifs =
    LibraryIndex
        { keywordLookup =
            let
                step : LibraryData.Gif -> Dict String String -> Dict String String
                step gif dict =
                    Dict.insert (List.head gif.keywords) gif.url dict
            in
            -- TODO - parse list to dict
            Dict.empty
        }


search : String -> LibraryIndex -> List String
search searchTerm (LibraryIndex index) =
    case Dict.get searchTerm index.keywordLookup of
        Nothing ->
            []

        Just url ->
            [ url ]


initialImage : LibraryIndex -> String
initialImage (LibraryIndex index) =
    Dict.get "default" index.keywordLookup
        |> Maybe.withDefault "https://media.giphy.com/media/piKaO6KOsO7ArDuiul/giphy.gif"
