module LibraryIndex exposing (LibraryIndex, fromGifs, initialImage, search)

import Dict exposing (Dict)
import LibraryData
import Set exposing (Set)


type LibraryIndex
    = LibraryIndex
        { keywordLookup : Dict String (Set String)
        }


fromGifs : List LibraryData.Gif -> LibraryIndex
fromGifs gifs =
    LibraryIndex
        { keywordLookup =
            let
                addGif : LibraryData.Gif -> Dict String (Set String) -> Dict String (Set String)
                addGif gif dict =
                    List.foldl (addKeyword gif.url) dict gif.keywords

                addKeyword : String -> String -> Dict String (Set String) -> Dict String (Set String)
                addKeyword url keyword dict =
                    case Dict.get keyword dict of
                        Just set ->
                            Dict.insert keyword (Set.insert url set) dict

                        Nothing ->
                            Dict.insert keyword (Set.singleton url) dict
            in
            List.foldl addGif Dict.empty gifs
        }


search : String -> LibraryIndex -> List String
search searchTerm (LibraryIndex index) =
    Dict.get searchTerm index.keywordLookup
        |> Maybe.withDefault Set.empty
        |> Set.toList


initialImage : LibraryIndex -> String
initialImage (LibraryIndex index) =
    Dict.get "default" index.keywordLookup
        |> Maybe.withDefault Set.empty
        |> Set.toList
        |> List.head
        |> Maybe.withDefault "https://media.giphy.com/media/3ohc1dHWofr304zNo4/giphy.gif"
