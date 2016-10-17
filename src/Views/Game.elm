module Views.Game exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Color exposing (..)
import String exposing (join)
import Types exposing (..)
import Story.Mechanics exposing (..)
import Story.State exposing (..)
import Views.CurrentSummary exposing (..)
import Views.Storyline exposing (..)
import Views.Locations exposing (..)
import Views.Inventory exposing (..)


view :
    StoryWorld item location character
    -> StoryState item location character knowledge
    -> Html (Story.Mechanics.Msg item location character)
view displayInfo storyState =
    let
        toCssColor : Color -> String
        toCssColor =
            toRgb >> \{ red, green, blue } -> String.join "" [ "rgb(", toString red, ",", toString green, ",", toString blue, ")" ]

        cssColor =
            toCssColor <| .color <| displayInfo.locations storyState.currentLocation

        itemMsg =
            Story.Mechanics.Interact << Item

        locationMsg =
            Story.Mechanics.Interact << Location

        characterMsg =
            Story.Mechanics.Interact << Character
    in
        div [ class "GamePage" ]
            [ div [ class "Layout" ]
                [ div [ class "Layout__Main" ]
                    [ h1 [ class "Current-location", style [ ( "backgroundColor", cssColor ) ] ]
                        [ text <| .name <| displayInfo.locations storyState.currentLocation ]
                    , currentSummary itemMsg characterMsg displayInfo toCssColor (flip List.member storyState.familiarWith) storyState
                    , storyline storyState.storyLine
                    ]
                , div [ class "Layout__Sidebar" ]
                    [ locations locationMsg displayInfo.locations storyState.knownLocations storyState.currentLocation toCssColor (flip List.member storyState.familiarWith)
                    , inventory itemMsg displayInfo.items (getInventory storyState) (flip List.member storyState.familiarWith)
                    ]
                ]
            ]
