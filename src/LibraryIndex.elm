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
                addGif : LibraryData.Gif -> Dict String String -> Dict String String
                addGif gif dict =
                    List.foldl (addKeyword gif.url) dict gif.keywords

                addKeyword : String -> String -> Dict String String -> Dict String String
                addKeyword url keyword dict =
                    Dict.insert keyword url dict
            in
            List.foldl addGif Dict.empty gifs
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
        |> Maybe.withDefault "https://media.giphy.com/media/3ohc1dHWofr304zNo4/giphy.gif"
