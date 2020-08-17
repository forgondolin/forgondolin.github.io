module Main exposing (main)

import Browser
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Events as Events
import Element.Font as Font
import Element.Region as Region
import Html
import Html.Attributes exposing (class)
import Svg
import Svg.Attributes



-- Type declarations


type Theme
    = Light
    | Dark
    | Fission


type alias Palette =
    { outerBg : Color
    , cardBg : Color
    , defaultText : Color
    , titleText : Color
    , secondaryText : Color
    , footerText : Color
    , icon : Color
    , link : Color
    , linkHover : Color
    , svgColorString : String
    , bgimage : String 
    }



-- MODEL


type alias Model =
    { theme : Theme }



-- MSG


type Msg
    = SetTheme Theme


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetTheme t ->
            ( { model | theme = t }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



view : Model -> Browser.Document Msg
view model =
    { title = "Fission | Codes"
    , body = [ viewBody model ]
    }


viewBody : Model -> Html.Html Msg
viewBody model =
    let
        palette =
            getPalette model
    in
    layout [ Font.family [ Font.external{ name = "Space Mono", url = "https://fonts.googleapis.com/css2?family=Space+Mono:wght@700&display=swap"}, Font.sansSerif ], Background.color palette.outerBg, Font.color palette.defaultText ] <|
        column
            -- Card with shadow
            [ centerX
            , centerY
            , width (maximum 500 fill)
            , height (maximum 850 fill)
            , paddingEach { left = 10, right = 10, top = 10, bottom = 10 }
            , Border.color (rgb255 219 219 219)
            , Border.shadow { blur = 20, color = rgba 0 0 0 0.1, offset = ( 0, 0 ), size = 1 }
            , Background.image "snake_case2.png"
            , spacing 42
            ]
            -- Main content
            [ column [ centerX, centerY, spacing 42, paddingEach { edges | top = 10 }, Region.mainContent ]
                [ image [ centerX, htmlAttribute <| class "headshot" ]
                    { src = "public/fission.png", description = "" }

                -- h1 and h2
                , column [ spacing 10, centerX, Font.center ]
                    [ el [ Region.heading 1, Font.size 48, centerX, Font.color palette.titleText ] <| text "Fission Codes"
                    , el [ Region.heading 2, Font.size 20, centerX, Font.light, Font.italic, Font.color palette.secondaryText ] <| getSubtitle model
                    ]

                -- Intro paragraph
                , paragraph [ Font.center, Font.light, paddingXY 20 0, Font.size 15, centerX, spacing 10 ]
                    [ text "Fission is a platform that works hard to make your deploy easier!" ]

                -- Social Links (icons)
                , viewSocialLinks model

               
                ]

            -- Footer
            , column
                [ Region.footer
                , paddingXY 0 10
                , Font.color palette.footerText
                , Font.light
                , centerX
                , Font.center
                , Font.size 12
                , alignBottom
                ]
                [ el
                    [ htmlAttribute <| class "theme-toggle lightbulb"
                    , paddingXY 0 8
                    , centerX
                    , pointer
                    , Events.onClick <| toggleTheme model
                    ]
                    (html <| svgLightbulb model)
                , paragraph []
                    [ text "Made with Elm—"
                    , newTabLink [ getLinkHover model, htmlAttribute <| class "footer-link" ] { url = "https://github.com/forgondolin/forgondolin.github.io", label = text "see source code" }
                    , text " | © 2020 Kaleb Alves"
                    ]
                ]
            ]



getSubtitle : Model -> Element Msg
getSubtitle model =
    case model.theme of
        Light ->
            text "Because Math"

        Dark ->
            text "Fission Rocks"

        Fission ->
            text "Fission colors!"


viewSocialLinks : Model -> Element Msg
viewSocialLinks model =
    row [ spacing 25, centerX ]
        [ newTabLink [ getLinkHover model, getIconColor model, ariaLabel "Fission Forum" ] { url = "https://talk.fission.codes/", label = faIcon "fas fa-archive" }
        , newTabLink [ getLinkHover model, getIconColor model, ariaLabel "Blog" ] { url = "https://blog.fission.codes/", label = faIcon "fab fa-blogger" }
        , newTabLink [ getLinkHover model, getIconColor model, ariaLabel "Github" ] { url = "https://github.com/fission-suite/", label = faIcon "fab fa-github" }
       -- , newTabLink [ getLinkHover model, getIconColor model, ariaLabel "Email" ] { url = "mailto:kaleblucasalves@", label = faIcon "far fa-envelope" }
        , newTabLink [ getLinkHover model, getIconColor model, ariaLabel "LinkedIn" ] { url = "https://www.linkedin.com/company/fissioncodes/", label = faIcon "fab fa-linkedin-in" }
        ]


ariaLabel : String -> Attribute msg
ariaLabel label =
    htmlAttribute <| Html.Attributes.attribute "aria-label" label


faIcon : String -> Element msg
faIcon icon =
    html <| Html.i [ class icon ] [ Html.text "" ]


edges : { left : Int, right : Int, top : Int, bottom : Int }
edges =
    { left = 0, right = 0, top = 0, bottom = 0 }


toggleTheme : Model -> Msg
toggleTheme model =
    case model.theme of
        Light ->
            SetTheme Dark

        Dark ->
            SetTheme Fission

        Fission ->
            SetTheme Light


getPalette : Model -> Palette
getPalette model =
    case model.theme of
        Light ->
            paletteLight

        Dark ->
            paletteDark

        Fission ->
            paletteFission


getIconColor : Model -> Attribute Msg
getIconColor model =
    Font.color <| .icon (getPalette model)


getLinkHover : Model -> Attribute Msg
getLinkHover model =
    mouseOver [ Font.color <| .linkHover (getPalette model) ]



-- MAIN


main : Program () Model Msg
main =
    Browser.document
        { init = always ( { theme = Dark }, Cmd.none )
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- CONSTANTS
-- THEMES (COLORS)


white : Color
white =
    rgb255 255 255 255


grey : Color
grey =
    rgb255 170 170 170


greyString : String
greyString =
    "rgb(170, 170, 170)"


black : Color
black =
    rgb255 0 0 0



-- Link blue


darkBlue : Color
darkBlue =
    rgb255 0 0 139



-- Fission Colors: https://talk.fission.codes/t/fission-branding/244


fissionColors =
    { -- core
      bg = rgb255 30 35 71
    , bgLight = rgb255 100 70 250
    , text = rgb255 255 82 116

    -- primary
    , cyan = rgb255 139 233 253
    , darkBlue1 = rgb255 30 35 71
    , pink = rgb255 255 82 116
    , purple = rgb255 189 147 249

    -- secondary
    , orange = rgb255 255 184 108
    , red = rgb255 255 85 85
    , yellow = rgb255 241 250 140

    -- comment
    , comment = rgb255 98 114 164
    , svgColorString = "rgb(98, 114, 164)"
    }


paletteLight : Palette
paletteLight =
    { outerBg = rgb255 248 249 250
    , cardBg = white
    , defaultText = black
    , titleText = black
    , secondaryText = black
    , footerText = grey
    , icon = black
    , link = darkBlue
    , linkHover = fissionColors.purple
    , svgColorString = greyString
    , bgimage = "snake_case.png"
    }


paletteDark : Palette
paletteDark =
    { outerBg = black
    , cardBg = rgb255 8 8 8
    , defaultText = white
    , titleText = white
    , secondaryText = grey
    , footerText = grey
    , icon = white
    , link = rgb255 51 179 166
    , linkHover = fissionColors.cyan
    , svgColorString = greyString
    , bgimage = "snake_case.png"
    }


paletteFission : Palette
paletteFission =
    { outerBg = fissionColors.bgLight
    , cardBg = fissionColors.bg
    , defaultText = fissionColors.text
    , titleText = fissionColors.darkBlue1
    , secondaryText = fissionColors.pink
    , footerText = fissionColors.comment
    , icon = fissionColors.darkBlue1
    , link = fissionColors.purple
    , linkHover = fissionColors.cyan
    , svgColorString = fissionColors.svgColorString
    , bgimage = "snake_case.png"
    }



-- SVG
-- Light bulb icon: https://iconmonstr.com/light-bulb-18-svg/


svgLightbulb : Model -> Html.Html Msg
svgLightbulb model =
    Svg.svg
        [ Svg.Attributes.width "20"
        , Svg.Attributes.height "20"
        , Svg.Attributes.viewBox "0 0 24 24"
        , Svg.Attributes.class "lightbulb-icon"
        , Svg.Attributes.stroke (.svgColorString (getPalette model))
        , Svg.Attributes.fill (.svgColorString (getPalette model))
        ]
        [ Svg.path [ Svg.Attributes.d "M14 19h-4c-.276 0-.5.224-.5.5s.224.5.5.5h4c.276 0 .5-.224.5-.5s-.224-.5-.5-.5zm0 2h-4c-.276 0-.5.224-.5.5s.224.5.5.5h4c.276 0 .5-.224.5-.5s-.224-.5-.5-.5zm.25 2h-4.5l1.188.782c.154.138.38.218.615.218h.895c.234 0 .461-.08.615-.218l1.187-.782zm3.75-13.799c0 3.569-3.214 5.983-3.214 8.799h-1.989c-.003-1.858.87-3.389 1.721-4.867.761-1.325 1.482-2.577 1.482-3.932 0-2.592-2.075-3.772-4.003-3.772-1.925 0-3.997 1.18-3.997 3.772 0 1.355.721 2.607 1.482 3.932.851 1.478 1.725 3.009 1.72 4.867h-1.988c0-2.816-3.214-5.23-3.214-8.799 0-3.723 2.998-5.772 5.997-5.772 3.001 0 6.003 2.051 6.003 5.772zm4-.691v1.372h-2.538c.02-.223.038-.448.038-.681 0-.237-.017-.464-.035-.69h2.535zm-10.648-6.553v-1.957h1.371v1.964c-.242-.022-.484-.035-.726-.035-.215 0-.43.01-.645.028zm-3.743 1.294l-1.04-1.94 1.208-.648 1.037 1.933c-.418.181-.822.401-1.205.655zm10.586 1.735l1.942-1.394.799 1.115-2.054 1.473c-.191-.43-.423-.827-.687-1.194zm-3.01-2.389l1.038-1.934 1.208.648-1.041 1.941c-.382-.254-.786-.473-1.205-.655zm-10.068 3.583l-2.054-1.472.799-1.115 1.942 1.393c-.264.366-.495.763-.687 1.194zm13.707 6.223l2.354.954-.514 1.271-2.425-.982c.21-.397.408-.812.585-1.243zm-13.108 1.155l-2.356 1.06-.562-1.251 2.34-1.052c.173.433.371.845.578 1.243zm-1.178-3.676h-2.538v-1.372h2.535c-.018.226-.035.454-.035.691 0 .233.018.458.038.681z" ] [] ]



-- Fission Icon: 
