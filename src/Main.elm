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
    layout [ Font.family [ Font.typeface "Helvetica", Font.sansSerif ], Background.color palette.outerBg, Font.color palette.defaultText ] <|
        column
            -- Card with shadow
            [ centerX
            , centerY
            , width (maximum 500 fill)
            , height (maximum 850 fill)
            , paddingEach { left = 10, right = 10, top = 10, bottom = 10 }
            , Border.color (rgb255 219 219 219)
            , Border.shadow { blur = 20, color = rgba 0 0 0 0.1, offset = ( 0, 0 ), size = 1 }
            , Background.image "snake_case.png"
            , spacing 42
            ]
            -- Main content
            [ column [ centerX, centerY, spacing 42, paddingEach { edges | top = 10 }, Region.mainContent ]
                [ image [ centerX, htmlAttribute <| class "headshot" ]
                    { src = "public/fission.png", description = "Fission" }

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
        { init = always ( { theme = Light }, Cmd.none )
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
    , text = rgb255 248 248 242

    -- primary
    , cyan = rgb255 139 233 253
    , darkBlue1 = rgb255 30 35 71
    , pink = rgb255 255 121 198
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
    , secondaryText = grey
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


{- svgFission : Html.Html Msg
svgFission =
    Svg.svg
        [ Svg.Attributes.x "0px"
        , Svg.Attributes.y "0px"
        , Svg.Attributes.viewBox "0 0 379 396"
        , Svg.Attributes.class "fissionIcon"
        , Svg.Attributes.width "20"
        , Svg.Attributes.height "20"
        ]
        [ Svg.style [] [ Svg.text " .st0{fill:#5A677D;} .st1{fill:#323333;} .st2{fill:#D3D4D5;} .st3{fill:#AEAFB2;} .st4{fill:#3C3C3C;} .st5{fill:#E7503B;} .st6{fill:#FFFFFF;} " ]
        , Svg.ellipse [ Svg.Attributes.class "st0", Svg.Attributes.cx "189.8", Svg.Attributes.cy "336.1", Svg.Attributes.rx "186.5", Svg.Attributes.ry "52.3" ] []
        , Svg.g [] [ Svg.path [ Svg.Attributes.id "capa", Svg.Attributes.class "st1", Svg.Attributes.d "M366.5,200c-12-15-64-43-177-42c-113-1-165,27-177,42s41.3,32.4,50,38c14,9,44,24,32,59s-27,36,6,45 s65,13,89,13s56-4,89-13s18-10,6-45s18-50,32-59C325.2,232.4,378.5,215,366.5,200z" ] [], Svg.g [] [ Svg.g [] [ Svg.g [] [ Svg.path [ Svg.Attributes.id "rosto", Svg.Attributes.class "st2", Svg.Attributes.d "M327.5,113c-6.6-6.1-29.4,14-29.4,14c-2.7,1.7-5,4.9-6.7,9c-6.9-38.6-28.9-48.2-39.6-49 c-14-1-29,12-37,20c-7.8,7.8-20.4,21.4-25.6,22c-5.2-0.6-17.8-14.2-25.6-22c-8-8-23-21-37-20c-10.6,0.8-32,10.1-39.3,46.9 c-1.3-2.8-3.2-5.1-5.7-6.9c0,0-22.9-20.1-29.4-14c-2.2,2.1-2.6,7.1,0.4,17c10.3,33.8,16.2,57.9,25.4,69.5 c0,14.1,4.3,30.2,13.5,45.5c8.9,14.8,20.7,26.2,33,33.3c-0.4,5.2-4.5,82.2,64.3,82.7h0.7c67.5-0.5,64.8-74.6,64.3-82.3 c12.5-7,24.6-18.6,33.7-33.7s13.4-30.8,13.5-44.7c9.6-11.3,15.5-35.7,26.1-70.3C330.1,120.1,329.8,115.1,327.5,113z" ] [], Svg.path [ Svg.Attributes.id "sombra_rosto", Svg.Attributes.class "st3", Svg.Attributes.d "M298.1,127c-2.7,1.9-4.8,4.5-6.1,7.6l1.5,42.4c0,0,1,49-58,88c0,0,11.8,105.9-92,77.8 c9.6,10.5,23.9,18,45.3,18.2h0.7c67.5-0.5,64.8-74.6,64.3-82.3c12.5-7,24.6-18.6,33.7-33.7s13.4-30.8,13.5-44.7 c9.6-11.3,15.5-35.7,26.1-70.3c3-9.9,2.7-14.9,0.4-17C321,106.9,298.1,127,298.1,127z" ] [] ], Svg.g [] [ Svg.g [] [ Svg.path [ Svg.Attributes.class "st4", Svg.Attributes.d "M202.5,265.7c-3.9,4.4-9.4,6.7-12.9,6.7s-9-2.3-12.9-6.7c-5.4-6.1,4.6,11.5,12.3,13.1 c0.2,0.1,0.4,0.1,0.6,0.1l0,0c0.2,0,0.4,0,0.6-0.1C197.9,277.3,207.9,259.6,202.5,265.7z" ] [], Svg.g [] [ Svg.path [ Svg.Attributes.class "st4", Svg.Attributes.d "M232,291.5c-8.8,2.8-34.7,8-42.1,8.1c-7.5-0.1-33.3-5.4-42.1-8.1c-9.4-2.9,27.2,14.6,42,14.6h0.3 C204.8,306,241.4,288.5,232,291.5z" ] [], Svg.g [] [ Svg.path [ Svg.Attributes.class "st4", Svg.Attributes.d "M163.9,297.4c0,0,0.9,16.7,2.9,17.9c1.2,0.7,2.3-1.4,3.4-15C170.3,297.7,163.9,297.4,163.9,297.4z" ] [], Svg.path [ Svg.Attributes.class "st4", Svg.Attributes.d "M215.5,297.4c0,0-0.9,16.7-2.9,17.9c-1.2,0.7-2.3-1.4-3.4-15C209.1,297.7,215.5,297.4,215.5,297.4z" ] [] ] ] ], Svg.g [] [ Svg.g [] [ Svg.path [ Svg.Attributes.class "st3", Svg.Attributes.d "M171.5,194c0,0,5,0,5,15s-2.1,60.3-4,36c-2-25-2-48-2-48L171.5,194z" ] [], Svg.path [ Svg.Attributes.class "st3", Svg.Attributes.d "M207.5,195c0,0-5-1-5,14s2.1,60.3,4,36c2-25,2-48,2-48L207.5,195z" ] [] ], Svg.g [] [ Svg.path [ Svg.Attributes.class "st5", Svg.Attributes.d "M146.5,176c-33-20-42-25-41-17s11,41,33,46s35-1,37-6S146.5,176,146.5,176z" ] [], Svg.path [ Svg.Attributes.class "st5", Svg.Attributes.d "M233.5,176c33-20,42-25,41-17s-11,41-33,46s-35-1-37-6S233.5,176,233.5,176z" ] [] ] ] ], Svg.g [] [ Svg.circle [ Svg.Attributes.class "st6", Svg.Attributes.cx "99.5", Svg.Attributes.cy "138", Svg.Attributes.r "8" ] [], Svg.ellipse [ Svg.Attributes.transform "matrix(0.5744 -0.8186 0.8186 0.5744 -40.2243 144.6574)", Svg.Attributes.class "st6", Svg.Attributes.cx "119", Svg.Attributes.cy "111", Svg.Attributes.rx "21", Svg.Attributes.ry "10.5" ] [] ] ], Svg.path [ Svg.Attributes.id "cabelo", Svg.Attributes.class "st4", Svg.Attributes.d "M85.5,179c-6-75,27-91,41-92s29,12,37,20c7.8,7.8,20.4,21.4,25.6,22c5.2-0.6,17.8-14.2,25.6-22 c8-8,23-21,37-20s47,17,41,92c-0.3,3.5-0.6,6.8-1,10.1c21-41.9,19.2-109.1,18.2-144.1c-1-37-73-50-120-50h-0.4 c-47,0-119,13-120,50c-0.9,34.1-2.7,98.8,16.6,140.8C85.9,183.6,85.7,181.3,85.5,179z" ] [] ] ]
        ]
-}
