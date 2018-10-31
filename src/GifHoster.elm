module GifHoster exposing (Model, Msg(..), init, main, subscriptions, update, view)

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
    }


type Msg
    = SearchTextChange String
    | SubmitSearchClick


init : ( Model, Cmd Msg )
init =
    ( { showSearchResult = False
      }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SearchTextChange _ ->
            ( model
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
        [ Html.img [ src "https://media.giphy.com/media/piKaO6KOsO7ArDuiul/giphy.gif" ] []
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
                , Html.img
                    [ src "https://media.giphy.com/media/vKnmQ9Ky8wgTK/giphy.gif"
                    ]
                    []
                ]

          else
            Html.text ""
        ]
