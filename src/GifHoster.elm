module GifHoster exposing (Model, Msg(..), init, main, subscriptions, update, view)

import Dict exposing (Dict)
import Html exposing (Html)
import Html.Attributes exposing (for, id, src)
import Html.Events exposing (onClick, onInput)


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


type alias Model =
    { currentSearchTerm : String
    , library : Dict String String
    , searchResults : Maybe (List String)
    }


type Msg
    = SearchTextChange String
    | SubmitSearchClick


init : ( Model, Cmd Msg )
init =
    ( { currentSearchTerm = ""
      , library =
            Dict.fromList
                [ ( "default", "https://media.giphy.com/media/piKaO6KOsO7ArDuiul/giphy.gif" )
                , ( "funny", "https://media.giphy.com/media/vKnmQ9Ky8wgTK/giphy.gif" )
                ]
      , searchResults = Nothing
      }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SearchTextChange inputText ->
            ( { model | currentSearchTerm = inputText }
            , Cmd.none
            )

        SubmitSearchClick ->
            ( { model
                | searchResults =
                    case Dict.get model.currentSearchTerm model.library of
                        Nothing ->
                            Just []

                        Just imageUrl ->
                            Just [ imageUrl ]
              }
            , Cmd.none
            )


subscriptions : Model -> Sub msg
subscriptions model =
    Sub.none


view : Model -> Html Msg
view model =
    Html.div []
        [ case Dict.get "default" model.library of
            Just defaultImageUrl ->
                Html.img [ src defaultImageUrl ] []

            Nothing ->
                Html.text "There are no images in your library.  Please add some."
        , Html.label [ for "search" ]
            [ Html.text "Search"
            ]
        , Html.input
            [ id "search"
            , onInput SearchTextChange
            ]
            []
        , Html.button
            [ onClick SubmitSearchClick
            ]
            [ Html.text "Search" ]
        , case model.searchResults of
            Just searchResults ->
                Html.div [] <|
                    List.concat
                        [ [ Html.h3 [] [ Html.text "Search results" ] ]
                        , if List.isEmpty searchResults then
                            [ Html.text
                                ("There are no images matching \""
                                    ++ model.currentSearchTerm
                                    ++ "\"."
                                )
                            ]

                          else
                            List.map viewSearchResult searchResults
                        ]

            Nothing ->
                Html.text ""
        ]


viewSearchResult : String -> Html msg
viewSearchResult imageUrl =
    Html.img
        [ src imageUrl
        ]
        []
