module GifHoster exposing (Model, Msg(..), init, main, subscriptions, update, view)

import Html exposing (Html)
import Html.Attributes exposing (src)


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


type alias Model =
    {}


type Msg
    = TODO


init : ( Model, Cmd Msg )
init =
    ( {}
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model
    , Cmd.none
    )


subscriptions : Model -> Sub msg
subscriptions model =
    Sub.none


view : Model -> Html Msg
view model =
    Html.img [ src "https://media.giphy.com/media/piKaO6KOsO7ArDuiul/giphy.gif" ] []
