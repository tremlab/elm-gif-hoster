module GifHoster exposing (Model, Msg(..), init, main, subscriptions, update, view)

import Html exposing (Html)
import Html.Attributes exposing (for, id, src, value)
import Html.Events exposing (onClick, onInput, onSubmit)
import LibraryData
import LibraryIndex exposing (LibraryIndex)
import ReneeGifLibrary as Library


main : Program Never Model Msg
main =
    Html.program
        { init = init Library.library
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


type alias Model =
    { currentUserInput : String
    , library : LibraryIndex
    , searchState : SearchState
    }


type SearchState
    = NotYetSearched
    | ResultsFound (List String)
    | NoResults { searchTerm : String }


type Msg
    = SearchTextChange String
    | SearchIpChange String
    | SubmitSearch


init : List LibraryData.Gif -> ( Model, Cmd Msg )
init gifs =
    ( { currentUserInput = ""
      , library = LibraryIndex.fromGifs gifs
      , searchState = NotYetSearched
      }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SearchTextChange inputText ->
            ( { model | currentUserInput = inputText }
            , Cmd.none
            )

        SubmitSearch ->
            ( { model
                | searchState =
                    if model.currentUserInput == "" then
                        -- TODO: search for selected IP
                        ResultsFound [ "https://media.giphy.com/media/kioQjY5OshNNC/giphy.gif" ]

                    else
                        -- TODO: use IP
                        case LibraryIndex.search model.currentUserInput model.library of
                            [] ->
                                NoResults { searchTerm = model.currentUserInput }

                            urls ->
                                ResultsFound urls
              }
            , Cmd.none
            )

        SearchIpChange value ->
            ( model
            , Cmd.none
            )


subscriptions : Model -> Sub msg
subscriptions model =
    Sub.none


view : Model -> Html Msg
view model =
    Html.div []
        [ case LibraryIndex.initialImage model.library of
            defaultImageUrl ->
                Html.img [ src defaultImageUrl ] []
        , Html.form
            [ onSubmit SubmitSearch
            ]
            [ Html.label [ for "search" ]
                [ Html.text "Search"
                ]
            , Html.input
                [ id "search"
                , onInput SearchTextChange
                ]
                []
            , Html.button
                [ Html.Attributes.type_ "submit"
                ]
                [ Html.text "Search" ]
            , Html.label [ for "ip" ] [ Html.text "IP" ]
            , Html.select
                [ id "ip"
                , onInput SearchIpChange
                ]
                [ Html.option [ value "Star Wars" ] [ Html.text "Star Wars" ]
                , Html.option [ value "Sherlock" ] [ Html.text "Sherlock" ]
                ]
            ]
        , case model.searchState of
            ResultsFound searchResults ->
                Html.div [] <|
                    List.concat
                        [ [ Html.h3 [] [ Html.text "Search results" ] ]
                        , List.map viewSearchResult searchResults
                        ]

            NoResults { searchTerm } ->
                Html.div []
                    [ Html.h3 [] [ Html.text "Search results" ]
                    , Html.text
                        ("There are no images matching \""
                            ++ searchTerm
                            ++ "\"."
                        )
                    ]

            NotYetSearched ->
                Html.text ""
        ]


viewSearchResult : String -> Html msg
viewSearchResult imageUrl =
    Html.img
        [ src imageUrl
        ]
        []
