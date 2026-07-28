import QtQuick

Rectangle {
    enum Variant { Variant_Primary, Variant_Neutral, Variant_Subtle}
    enum State_1 { State_1_Default, State_1_Hover, State_1_Disabled}
    enum Size { Size_Medium, Size_Small}

    id: button

    property alias _xIcon_ShapePath0StrokeColor: _x.icon_ShapePath0StrokeColor
    property alias buttonBorderColor: button.border.color
    property alias button_1Color: button_1.color
    property alias button_1FontLetterSpacing: button_1.font.letterSpacing
    property alias button_1FontPixelSize: button_1.font.pixelSize
    property alias button_1FontWeight: button_1.font.weight
    property alias button_1Height: button_1.height
    property alias button_1LineHeight: button_1.lineHeight
    property alias button_1Width: button_1.width
    property alias button_1X: button_1.x
    property alias starIcon_ShapePath0StrokeColor: star.icon_ShapePath0StrokeColor

    property int _size: Button_1.Size.Size_Medium
    property int _state: Button_1.State_1.State_1_Default
    property int _variant: Button_1.Variant.Variant_Primary
    property bool has_Icon_End: false
    property bool has_Icon_Start: false
    property string label: "Button"

    height: 40
    width: 75

    border.color: "#2c2c2c"
    border.width: 1
    clip: true
    color: "#2c2c2c"
    radius: 8
    visible: true

    states: [
        State {
            name: "Variant=Primary, State=Default, Size=Medium"
            when: button._variant === Button_1.Variant.Variant_Primary && button._state === Button_1.State_1.State_1_Default && button._size === Button_1.Size.Size_Medium
    
            PropertyChanges {
                width: 75
    
                target: button
            }
            PropertyChanges {
                height: 40
    
                target: button
            }
            PropertyChanges {
                color: "#2c2c2c"
                target: button
            }
            PropertyChanges {
                border.width: 1
                target: button
            }
            PropertyChanges {
                border.color: "#2c2c2c"
                target: button
            }
            PropertyChanges {
                x: 12
    
                target: star
            }
            PropertyChanges {
                y: 12
    
                target: star
            }
            PropertyChanges {
                icon_ShapePath0StrokeColor: "#f5f5f5"
                target: star
            }
            PropertyChanges {
                x: 12
    
                target: button_1
            }
            PropertyChanges {
                y: 12
    
                target: button_1
            }
            PropertyChanges {
                color: "#f5f5f5"
                target: button_1
            }
            PropertyChanges {
                x: 71
    
                target: _x
            }
            PropertyChanges {
                y: 12
    
                target: _x
            }
            PropertyChanges {
                icon_ShapePath0StrokeColor: "#f5f5f5"
                target: _x
            }
        },
        State {
            name: "Variant=Primary, State=Hover, Size=Medium"
            when: button._variant === Button_1.Variant.Variant_Primary && button._state === Button_1.State_1.State_1_Hover && button._size === Button_1.Size.Size_Medium
    
            PropertyChanges {
                width: 75
    
                target: button
            }
            PropertyChanges {
                height: 40
    
                target: button
            }
            PropertyChanges {
                color: "#1e1e1e"
                target: button
            }
            PropertyChanges {
                border.width: 1
                target: button
            }
            PropertyChanges {
                border.color: "#2c2c2c"
                target: button
            }
            PropertyChanges {
                x: 12
    
                target: star
            }
            PropertyChanges {
                y: 12
    
                target: star
            }
            PropertyChanges {
                icon_ShapePath0StrokeColor: "#f5f5f5"
                target: star
            }
            PropertyChanges {
                x: 12
    
                target: button_1
            }
            PropertyChanges {
                y: 12
    
                target: button_1
            }
            PropertyChanges {
                color: "#f5f5f5"
                target: button_1
            }
            PropertyChanges {
                x: 71
    
                target: _x
            }
            PropertyChanges {
                y: 12
    
                target: _x
            }
            PropertyChanges {
                icon_ShapePath0StrokeColor: "#f5f5f5"
                target: _x
            }
        },
        State {
            name: "Variant=Primary, State=Disabled, Size=Medium"
            when: button._variant === Button_1.Variant.Variant_Primary && button._state === Button_1.State_1.State_1_Disabled && button._size === Button_1.Size.Size_Medium
    
            PropertyChanges {
                width: 75
    
                target: button
            }
            PropertyChanges {
                height: 40
    
                target: button
            }
            PropertyChanges {
                color: "#d9d9d9"
                target: button
            }
            PropertyChanges {
                border.width: 1
                target: button
            }
            PropertyChanges {
                border.color: "#b3b3b3"
                target: button
            }
            PropertyChanges {
                x: 12
    
                target: star
            }
            PropertyChanges {
                y: 12
    
                target: star
            }
            PropertyChanges {
                icon_ShapePath0StrokeColor: "#b3b3b3"
                target: star
            }
            PropertyChanges {
                x: 12
    
                target: button_1
            }
            PropertyChanges {
                y: 12
    
                target: button_1
            }
            PropertyChanges {
                color: "#b3b3b3"
                target: button_1
            }
            PropertyChanges {
                x: 71
    
                target: _x
            }
            PropertyChanges {
                y: 12
    
                target: _x
            }
            PropertyChanges {
                icon_ShapePath0StrokeColor: "#b3b3b3"
                target: _x
            }
        },
        State {
            name: "Variant=Neutral, State=Default, Size=Medium"
            when: button._variant === Button_1.Variant.Variant_Neutral && button._state === Button_1.State_1.State_1_Default && button._size === Button_1.Size.Size_Medium
    
            PropertyChanges {
                width: 75
    
                target: button
            }
            PropertyChanges {
                height: 40
    
                target: button
            }
            PropertyChanges {
                color: "#e3e3e3"
                target: button
            }
            PropertyChanges {
                border.width: 1
                target: button
            }
            PropertyChanges {
                border.color: "#767676"
                target: button
            }
            PropertyChanges {
                x: 12
    
                target: star
            }
            PropertyChanges {
                y: 12
    
                target: star
            }
            PropertyChanges {
                icon_ShapePath0StrokeColor: "#1e1e1e"
                target: star
            }
            PropertyChanges {
                x: 12
    
                target: button_1
            }
            PropertyChanges {
                y: 12
    
                target: button_1
            }
            PropertyChanges {
                color: "#1e1e1e"
                target: button_1
            }
            PropertyChanges {
                x: 71
    
                target: _x
            }
            PropertyChanges {
                y: 12
    
                target: _x
            }
            PropertyChanges {
                icon_ShapePath0StrokeColor: "#1e1e1e"
                target: _x
            }
        },
        State {
            name: "Variant=Neutral, State=Hover, Size=Medium"
            when: button._variant === Button_1.Variant.Variant_Neutral && button._state === Button_1.State_1.State_1_Hover && button._size === Button_1.Size.Size_Medium
    
            PropertyChanges {
                width: 75
    
                target: button
            }
            PropertyChanges {
                height: 40
    
                target: button
            }
            PropertyChanges {
                color: "#cdcdcd"
                target: button
            }
            PropertyChanges {
                border.width: 1
                target: button
            }
            PropertyChanges {
                border.color: "#767676"
                target: button
            }
            PropertyChanges {
                x: 12
    
                target: star
            }
            PropertyChanges {
                y: 12
    
                target: star
            }
            PropertyChanges {
                icon_ShapePath0StrokeColor: "#1e1e1e"
                target: star
            }
            PropertyChanges {
                x: 12
    
                target: button_1
            }
            PropertyChanges {
                y: 12
    
                target: button_1
            }
            PropertyChanges {
                color: "#1e1e1e"
                target: button_1
            }
            PropertyChanges {
                x: 71
    
                target: _x
            }
            PropertyChanges {
                y: 12
    
                target: _x
            }
            PropertyChanges {
                icon_ShapePath0StrokeColor: "#1e1e1e"
                target: _x
            }
        },
        State {
            name: "Variant=Neutral, State=Disabled, Size=Medium"
            when: button._variant === Button_1.Variant.Variant_Neutral && button._state === Button_1.State_1.State_1_Disabled && button._size === Button_1.Size.Size_Medium
    
            PropertyChanges {
                width: 75
    
                target: button
            }
            PropertyChanges {
                height: 40
    
                target: button
            }
            PropertyChanges {
                color: "#d9d9d9"
                target: button
            }
            PropertyChanges {
                border.width: 1
                target: button
            }
            PropertyChanges {
                border.color: "#b3b3b3"
                target: button
            }
            PropertyChanges {
                x: 12
    
                target: star
            }
            PropertyChanges {
                y: 12
    
                target: star
            }
            PropertyChanges {
                icon_ShapePath0StrokeColor: "#b3b3b3"
                target: star
            }
            PropertyChanges {
                x: 12
    
                target: button_1
            }
            PropertyChanges {
                y: 12
    
                target: button_1
            }
            PropertyChanges {
                color: "#b3b3b3"
                target: button_1
            }
            PropertyChanges {
                x: 71
    
                target: _x
            }
            PropertyChanges {
                y: 12
    
                target: _x
            }
            PropertyChanges {
                icon_ShapePath0StrokeColor: "#b3b3b3"
                target: _x
            }
        },
        State {
            name: "Variant=Subtle, State=Default, Size=Medium"
            when: button._variant === Button_1.Variant.Variant_Subtle && button._state === Button_1.State_1.State_1_Default && button._size === Button_1.Size.Size_Medium
    
            PropertyChanges {
                width: 75
    
                target: button
            }
            PropertyChanges {
                height: 40
    
                target: button
            }
            PropertyChanges {
                color: "transparent"
                target: button
            }
            PropertyChanges {
                border.width: 0
                target: button
            }
            PropertyChanges {
                border.color: "white"
                target: button
            }
            PropertyChanges {
                x: 12
    
                target: star
            }
            PropertyChanges {
                y: 12
    
                target: star
            }
            PropertyChanges {
                icon_ShapePath0StrokeColor: "#1e1e1e"
                target: star
            }
            PropertyChanges {
                x: 12
    
                target: button_1
            }
            PropertyChanges {
                y: 12
    
                target: button_1
            }
            PropertyChanges {
                color: "#303030"
                target: button_1
            }
            PropertyChanges {
                x: 71
    
                target: _x
            }
            PropertyChanges {
                y: 12
    
                target: _x
            }
            PropertyChanges {
                icon_ShapePath0StrokeColor: "#1e1e1e"
                target: _x
            }
        },
        State {
            name: "Variant=Subtle, State=Hover, Size=Medium"
            when: button._variant === Button_1.Variant.Variant_Subtle && button._state === Button_1.State_1.State_1_Hover && button._size === Button_1.Size.Size_Medium
    
            PropertyChanges {
                width: 75
    
                target: button
            }
            PropertyChanges {
                height: 40
    
                target: button
            }
            PropertyChanges {
                color: "transparent"
                target: button
            }
            PropertyChanges {
                border.width: 1
                target: button
            }
            PropertyChanges {
                border.color: "#d9d9d9"
                target: button
            }
            PropertyChanges {
                x: 12
    
                target: star
            }
            PropertyChanges {
                y: 12
    
                target: star
            }
            PropertyChanges {
                icon_ShapePath0StrokeColor: "#1e1e1e"
                target: star
            }
            PropertyChanges {
                x: 12
    
                target: button_1
            }
            PropertyChanges {
                y: 12
    
                target: button_1
            }
            PropertyChanges {
                color: "#1e1e1e"
                target: button_1
            }
            PropertyChanges {
                x: 71
    
                target: _x
            }
            PropertyChanges {
                y: 12
    
                target: _x
            }
            PropertyChanges {
                icon_ShapePath0StrokeColor: "#1e1e1e"
                target: _x
            }
        },
        State {
            name: "Variant=Subtle, State=Disabled, Size=Medium"
            when: button._variant === Button_1.Variant.Variant_Subtle && button._state === Button_1.State_1.State_1_Disabled && button._size === Button_1.Size.Size_Medium
    
            PropertyChanges {
                width: 75
    
                target: button
            }
            PropertyChanges {
                height: 40
    
                target: button
            }
            PropertyChanges {
                color: "#d9d9d9"
                target: button
            }
            PropertyChanges {
                border.width: 1
                target: button
            }
            PropertyChanges {
                border.color: "#b3b3b3"
                target: button
            }
            PropertyChanges {
                x: 12
    
                target: star
            }
            PropertyChanges {
                y: 12
    
                target: star
            }
            PropertyChanges {
                icon_ShapePath0StrokeColor: "#b3b3b3"
                target: star
            }
            PropertyChanges {
                x: 12
    
                target: button_1
            }
            PropertyChanges {
                y: 12
    
                target: button_1
            }
            PropertyChanges {
                color: "#b3b3b3"
                target: button_1
            }
            PropertyChanges {
                x: 71
    
                target: _x
            }
            PropertyChanges {
                y: 12
    
                target: _x
            }
            PropertyChanges {
                icon_ShapePath0StrokeColor: "#b3b3b3"
                target: _x
            }
        },
        State {
            name: "Variant=Primary, State=Default, Size=Small"
            when: button._variant === Button_1.Variant.Variant_Primary && button._state === Button_1.State_1.State_1_Default && button._size === Button_1.Size.Size_Small
    
            PropertyChanges {
                width: 67
    
                target: button
            }
            PropertyChanges {
                height: 32
    
                target: button
            }
            PropertyChanges {
                color: "#2c2c2c"
                target: button
            }
            PropertyChanges {
                border.width: 1
                target: button
            }
            PropertyChanges {
                border.color: "#2c2c2c"
                target: button
            }
            PropertyChanges {
                x: 8
    
                target: star
            }
            PropertyChanges {
                y: 8
    
                target: star
            }
            PropertyChanges {
                icon_ShapePath0StrokeColor: "#f5f5f5"
                target: star
            }
            PropertyChanges {
                x: 8
    
                target: button_1
            }
            PropertyChanges {
                y: 8
    
                target: button_1
            }
            PropertyChanges {
                color: "#f5f5f5"
                target: button_1
            }
            PropertyChanges {
                x: 67
    
                target: _x
            }
            PropertyChanges {
                y: 8
    
                target: _x
            }
            PropertyChanges {
                icon_ShapePath0StrokeColor: "#f5f5f5"
                target: _x
            }
        },
        State {
            name: "Variant=Primary, State=Hover, Size=Small"
            when: button._variant === Button_1.Variant.Variant_Primary && button._state === Button_1.State_1.State_1_Hover && button._size === Button_1.Size.Size_Small
    
            PropertyChanges {
                width: 67
    
                target: button
            }
            PropertyChanges {
                height: 32
    
                target: button
            }
            PropertyChanges {
                color: "#1e1e1e"
                target: button
            }
            PropertyChanges {
                border.width: 1
                target: button
            }
            PropertyChanges {
                border.color: "#2c2c2c"
                target: button
            }
            PropertyChanges {
                x: 8
    
                target: star
            }
            PropertyChanges {
                y: 8
    
                target: star
            }
            PropertyChanges {
                icon_ShapePath0StrokeColor: "#f5f5f5"
                target: star
            }
            PropertyChanges {
                x: 8
    
                target: button_1
            }
            PropertyChanges {
                y: 8
    
                target: button_1
            }
            PropertyChanges {
                color: "#f5f5f5"
                target: button_1
            }
            PropertyChanges {
                x: 67
    
                target: _x
            }
            PropertyChanges {
                y: 8
    
                target: _x
            }
            PropertyChanges {
                icon_ShapePath0StrokeColor: "#f5f5f5"
                target: _x
            }
        },
        State {
            name: "Variant=Primary, State=Disabled, Size=Small"
            when: button._variant === Button_1.Variant.Variant_Primary && button._state === Button_1.State_1.State_1_Disabled && button._size === Button_1.Size.Size_Small
    
            PropertyChanges {
                width: 67
    
                target: button
            }
            PropertyChanges {
                height: 32
    
                target: button
            }
            PropertyChanges {
                color: "#d9d9d9"
                target: button
            }
            PropertyChanges {
                border.width: 1
                target: button
            }
            PropertyChanges {
                border.color: "#b3b3b3"
                target: button
            }
            PropertyChanges {
                x: 8
    
                target: star
            }
            PropertyChanges {
                y: 8
    
                target: star
            }
            PropertyChanges {
                icon_ShapePath0StrokeColor: "#b3b3b3"
                target: star
            }
            PropertyChanges {
                x: 8
    
                target: button_1
            }
            PropertyChanges {
                y: 8
    
                target: button_1
            }
            PropertyChanges {
                color: "#b3b3b3"
                target: button_1
            }
            PropertyChanges {
                x: 67
    
                target: _x
            }
            PropertyChanges {
                y: 8
    
                target: _x
            }
            PropertyChanges {
                icon_ShapePath0StrokeColor: "#b3b3b3"
                target: _x
            }
        },
        State {
            name: "Variant=Neutral, State=Default, Size=Small"
            when: button._variant === Button_1.Variant.Variant_Neutral && button._state === Button_1.State_1.State_1_Default && button._size === Button_1.Size.Size_Small
    
            PropertyChanges {
                width: 67
    
                target: button
            }
            PropertyChanges {
                height: 32
    
                target: button
            }
            PropertyChanges {
                color: "#e3e3e3"
                target: button
            }
            PropertyChanges {
                border.width: 1
                target: button
            }
            PropertyChanges {
                border.color: "#767676"
                target: button
            }
            PropertyChanges {
                x: 8
    
                target: star
            }
            PropertyChanges {
                y: 8
    
                target: star
            }
            PropertyChanges {
                icon_ShapePath0StrokeColor: "#1e1e1e"
                target: star
            }
            PropertyChanges {
                x: 8
    
                target: button_1
            }
            PropertyChanges {
                y: 8
    
                target: button_1
            }
            PropertyChanges {
                color: "#1e1e1e"
                target: button_1
            }
            PropertyChanges {
                x: 67
    
                target: _x
            }
            PropertyChanges {
                y: 8
    
                target: _x
            }
            PropertyChanges {
                icon_ShapePath0StrokeColor: "#1e1e1e"
                target: _x
            }
        },
        State {
            name: "Variant=Neutral, State=Hover, Size=Small"
            when: button._variant === Button_1.Variant.Variant_Neutral && button._state === Button_1.State_1.State_1_Hover && button._size === Button_1.Size.Size_Small
    
            PropertyChanges {
                width: 67
    
                target: button
            }
            PropertyChanges {
                height: 32
    
                target: button
            }
            PropertyChanges {
                color: "#cdcdcd"
                target: button
            }
            PropertyChanges {
                border.width: 1
                target: button
            }
            PropertyChanges {
                border.color: "#767676"
                target: button
            }
            PropertyChanges {
                x: 8
    
                target: star
            }
            PropertyChanges {
                y: 8
    
                target: star
            }
            PropertyChanges {
                icon_ShapePath0StrokeColor: "#1e1e1e"
                target: star
            }
            PropertyChanges {
                x: 8
    
                target: button_1
            }
            PropertyChanges {
                y: 8
    
                target: button_1
            }
            PropertyChanges {
                color: "#1e1e1e"
                target: button_1
            }
            PropertyChanges {
                x: 67
    
                target: _x
            }
            PropertyChanges {
                y: 8
    
                target: _x
            }
            PropertyChanges {
                icon_ShapePath0StrokeColor: "#1e1e1e"
                target: _x
            }
        },
        State {
            name: "Variant=Neutral, State=Disabled, Size=Small"
            when: button._variant === Button_1.Variant.Variant_Neutral && button._state === Button_1.State_1.State_1_Disabled && button._size === Button_1.Size.Size_Small
    
            PropertyChanges {
                width: 67
    
                target: button
            }
            PropertyChanges {
                height: 32
    
                target: button
            }
            PropertyChanges {
                color: "#d9d9d9"
                target: button
            }
            PropertyChanges {
                border.width: 1
                target: button
            }
            PropertyChanges {
                border.color: "#b3b3b3"
                target: button
            }
            PropertyChanges {
                x: 8
    
                target: star
            }
            PropertyChanges {
                y: 8
    
                target: star
            }
            PropertyChanges {
                icon_ShapePath0StrokeColor: "#b3b3b3"
                target: star
            }
            PropertyChanges {
                x: 8
    
                target: button_1
            }
            PropertyChanges {
                y: 8
    
                target: button_1
            }
            PropertyChanges {
                color: "#b3b3b3"
                target: button_1
            }
            PropertyChanges {
                x: 67
    
                target: _x
            }
            PropertyChanges {
                y: 8
    
                target: _x
            }
            PropertyChanges {
                icon_ShapePath0StrokeColor: "#b3b3b3"
                target: _x
            }
        },
        State {
            name: "Variant=Subtle, State=Default, Size=Small"
            when: button._variant === Button_1.Variant.Variant_Subtle && button._state === Button_1.State_1.State_1_Default && button._size === Button_1.Size.Size_Small
    
            PropertyChanges {
                width: 67
    
                target: button
            }
            PropertyChanges {
                height: 32
    
                target: button
            }
            PropertyChanges {
                color: "transparent"
                target: button
            }
            PropertyChanges {
                border.width: 0
                target: button
            }
            PropertyChanges {
                border.color: "white"
                target: button
            }
            PropertyChanges {
                x: 8
    
                target: star
            }
            PropertyChanges {
                y: 8
    
                target: star
            }
            PropertyChanges {
                icon_ShapePath0StrokeColor: "#1e1e1e"
                target: star
            }
            PropertyChanges {
                x: 8
    
                target: button_1
            }
            PropertyChanges {
                y: 8
    
                target: button_1
            }
            PropertyChanges {
                color: "#1e1e1e"
                target: button_1
            }
            PropertyChanges {
                x: 67
    
                target: _x
            }
            PropertyChanges {
                y: 8
    
                target: _x
            }
            PropertyChanges {
                icon_ShapePath0StrokeColor: "#1e1e1e"
                target: _x
            }
        },
        State {
            name: "Variant=Subtle, State=Hover, Size=Small"
            when: button._variant === Button_1.Variant.Variant_Subtle && button._state === Button_1.State_1.State_1_Hover && button._size === Button_1.Size.Size_Small
    
            PropertyChanges {
                width: 67
    
                target: button
            }
            PropertyChanges {
                height: 32
    
                target: button
            }
            PropertyChanges {
                color: "transparent"
                target: button
            }
            PropertyChanges {
                border.width: 1
                target: button
            }
            PropertyChanges {
                border.color: "#d9d9d9"
                target: button
            }
            PropertyChanges {
                x: 8
    
                target: star
            }
            PropertyChanges {
                y: 8
    
                target: star
            }
            PropertyChanges {
                icon_ShapePath0StrokeColor: "#1e1e1e"
                target: star
            }
            PropertyChanges {
                x: 8
    
                target: button_1
            }
            PropertyChanges {
                y: 8
    
                target: button_1
            }
            PropertyChanges {
                color: "#1e1e1e"
                target: button_1
            }
            PropertyChanges {
                x: 67
    
                target: _x
            }
            PropertyChanges {
                y: 8
    
                target: _x
            }
            PropertyChanges {
                icon_ShapePath0StrokeColor: "#1e1e1e"
                target: _x
            }
        },
        State {
            name: "Variant=Subtle, State=Disabled, Size=Small"
            when: button._variant === Button_1.Variant.Variant_Subtle && button._state === Button_1.State_1.State_1_Disabled && button._size === Button_1.Size.Size_Small
    
            PropertyChanges {
                width: 67
    
                target: button
            }
            PropertyChanges {
                height: 32
    
                target: button
            }
            PropertyChanges {
                color: "#d9d9d9"
                target: button
            }
            PropertyChanges {
                border.width: 1
                target: button
            }
            PropertyChanges {
                border.color: "#b3b3b3"
                target: button
            }
            PropertyChanges {
                x: 8
    
                target: star
            }
            PropertyChanges {
                y: 8
    
                target: star
            }
            PropertyChanges {
                icon_ShapePath0StrokeColor: "#b3b3b3"
                target: star
            }
            PropertyChanges {
                x: 8
    
                target: button_1
            }
            PropertyChanges {
                y: 8
    
                target: button_1
            }
            PropertyChanges {
                color: "#b3b3b3"
                target: button_1
            }
            PropertyChanges {
                x: 67
    
                target: _x
            }
            PropertyChanges {
                y: 8
    
                target: _x
            }
            PropertyChanges {
                icon_ShapePath0StrokeColor: "#b3b3b3"
                target: _x
            }
        }
    ]

    Star {
        id: star

        x: 12
        y: 12

        clip: true
        icon_ShapePath0StrokeColor: "#f5f5f5"
        visible: button.has_Icon_Start
    }
    Text {
        id: button_1

        x: 12
        y: 12

        height: 16
        width: 52

        color: "#f5f5f5"
        font.family: "Inter"
        font.letterSpacing: 0
        font.pixelSize: 16
        font.weight: Font.Normal
        horizontalAlignment: Text.AlignLeft
        lineHeight: 16
        lineHeightMode: Text.FixedHeight
        text: button.label
        verticalAlignment: Text.AlignTop
    }
    X {
        id: _x

        x: 71
        y: 12

        clip: true
        icon_ShapePath0StrokeColor: "#f5f5f5"
        visible: button.has_Icon_End
    }
}