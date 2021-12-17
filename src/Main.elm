module Main exposing (..)

{-| This is a skeleton for an interpreter application. For now it basically simply display what you type in.
You should just:

  - insert your code in the update and the viewCommand functions,
  - surely add some field in the Model type,
  - probably change the "history" field in the Model (and adapt the viewHistory function consequently).

You can of course add other types,
functions and modules but you shouldn't have to modify the code at other places -- if you think you have to modify
this code, reach your teacher out before doing this.

-}

import Browser
import Browser.Dom
import Element exposing (Element, column, el, fill, focusStyle, height, padding, paddingEach, px, rgb, rgba, row, spacing, text, width)
import Element.Background as Background
import Element.Border
import Element.Font as Font
import Element.Input as Input
import Html.Attributes
import Html.Events
import Json.Decode as Decode
import Task


type alias Model =
    { commandInput : String
    , history : List String
    }


type Msg
    = CommandEntered String
    | CommandSubmitted
    | NoOp


init : Model
init =
    { commandInput = ""
    , history = []
    }


update : Msg -> Model -> Model
update msg model =
    case msg of
        CommandEntered command ->
            { model | commandInput = command }

        CommandSubmitted ->
            -- TODO: Command parsing and applying goes here!!!
            { model | commandInput = "", history = model.history ++ [ model.commandInput ] }

        NoOp ->
            model


view : Model -> Element Msg
view model =
    column [ width fill, height fill, Font.color white, Font.family [ Font.monospace ] ]
        ([ text """Welcome to Mini-Mapple 0.1!

Be careful, this project was created by students, maybe there are hidden bugs in it.
Maybe they also hid some easter eggs, who knows!

You can try basic math operations like:
$e = (5 + 6)
eval($e)
""" ]
            ++ viewHistory model.history
            ++ [ viewPrompt
                    (Input.text
                        [ onEnter CommandSubmitted
                        , Background.color black
                        , Element.htmlAttribute (Html.Attributes.id "prompt")
                        , Element.Border.width 0
                        , padding 0
                        , width fill
                        ]
                        { onChange = CommandEntered
                        , text = model.commandInput
                        , placeholder = Nothing
                        , label = Input.labelHidden "Enter the command"
                        }
                    )
               ]
        )


viewPrompt : Element Msg -> Element Msg
viewPrompt element =
    row [ width fill ]
        [ el [ Font.color blue ] (text "λ ")
        , element
        ]


viewHistory : List String -> List (Element Msg)
viewHistory history =
    history
        |> List.map viewCommand
        |> List.concat


viewCommand : String -> List (Element Msg)
viewCommand command =
    -- TODO: change this function... You'll probably also want displaying the output of the given command, so
    -- TODO: maybe you need this output as an argument.
    [ viewPrompt (text command)
    , if command == "" then
        Element.none

      else
        text command
    ]


black : Element.Color
black =
    rgb 0 0 0


white : Element.Color
white =
    rgb 1 1 1


blue : Element.Color
blue =
    rgb 0 0 1


onEnter : msg -> Element.Attribute msg
onEnter msg =
    Element.htmlAttribute
        (Html.Events.on "keyup"
            (Decode.field "key" Decode.string
                |> Decode.andThen
                    (\key ->
                        if key == "Enter" then
                            Decode.succeed msg

                        else
                            Decode.fail "Not the enter key"
                    )
            )
        )


main =
    Browser.element
        { init =
            \() ->
                ( init
                , Browser.Dom.focus "prompt"
                    |> Task.attempt (always NoOp)
                )
        , view =
            \model ->
                Element.layoutWith
                    { options =
                        [ focusStyle
                            { borderColor = Nothing
                            , backgroundColor = Nothing
                            , shadow = Nothing
                            }
                        ]
                    }
                    [ width fill
                    , height fill
                    , Background.color black
                    , Element.htmlAttribute (Html.Attributes.style "overflow-y" "auto")
                    ]
                    (view model)
        , update =
            \msg model ->
                ( update msg model
                , if msg == CommandSubmitted then
                    Browser.Dom.focus "prompt"
                        |> Task.attempt (always NoOp)

                  else
                    Cmd.none
                )
        , subscriptions = always Sub.none
        }
