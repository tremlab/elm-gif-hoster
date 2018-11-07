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
    { showSearchResult : Bool
    , currentSearchTerm : String
    , library : Dict String String
    }


type Msg
    = SearchTextChange String
    | SubmitSearchClick


init : ( Model, Cmd Msg )
init =
    ( { showSearchResult = False
      , currentSearchTerm = ""
      , library =
            Dict.fromList
                [ ( "default", "https://media.giphy.com/media/piKaO6KOsO7ArDuiul/giphy.gif" )
                , ( "funny", "https://media.giphy.com/media/vKnmQ9Ky8wgTK/giphy.gif" )
                ]
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
            ( { model | showSearchResult = True }
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
        , if model.showSearchResult then
            Html.div []
                [ Html.text "Search results"
                , case Dict.get model.currentSearchTerm model.library of
                    Nothing ->
                        Html.text "Sorry, no matching search results."

                    Just imageUrl ->
                        Html.img
                            [ src imageUrl
                            ]
                            []
                ]

          else
            Html.text ""
        ]
