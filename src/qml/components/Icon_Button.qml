import QtQuick

Rectangle {
    enum Variant { Variant_Primary, Variant_Neutral, Variant_Subtle}
    enum State_1 { State_1_Default, State_1_Hover, State_1_Disabled}
    enum Size { Size_Medium, Size_Small}

    id: icon_Button

    property int _size: Icon_Button.Size.Size_Medium
    property int _state: Icon_Button.State_1.State_1_Default
    property int _variant: Icon_Button.Variant.Variant_Primary

    height: 44
    width: 44

    border.color: "#2c2c2c"
    border.width: 1
    clip: true
    color: "#2c2c2c"
    radius: 32

    states: [
        State {
            name: "Variant=Primary, State=Default, Size=Medium"
            when: icon_Button._variant === Icon_Button.Variant.Variant_Primary && icon_Button._state === Icon_Button.State_1.State_1_Default && icon_Button._size === Icon_Button.Size.Size_Medium
    
            PropertyChanges {
                width: 44
    
                target: icon_Button
            }
            PropertyChanges {
                height: 44
    
                target: icon_Button
            }
            PropertyChanges {
                color: "#2c2c2c"
                target: icon_Button
            }
            PropertyChanges {
                border.width: 1
                target: icon_Button
            }
            PropertyChanges {
                border.color: "#2c2c2c"
                target: icon_Button
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
        },
        State {
            name: "Variant=Primary, State=Default, Size=Small"
            when: icon_Button._variant === Icon_Button.Variant.Variant_Primary && icon_Button._state === Icon_Button.State_1.State_1_Default && icon_Button._size === Icon_Button.Size.Size_Small
    
            PropertyChanges {
                width: 36
    
                target: icon_Button
            }
            PropertyChanges {
                height: 36
    
                target: icon_Button
            }
            PropertyChanges {
                color: "#2c2c2c"
                target: icon_Button
            }
            PropertyChanges {
                border.width: 1
                target: icon_Button
            }
            PropertyChanges {
                border.color: "#2c2c2c"
                target: icon_Button
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
        },
        State {
            name: "Variant=Neutral, State=Default, Size=Medium"
            when: icon_Button._variant === Icon_Button.Variant.Variant_Neutral && icon_Button._state === Icon_Button.State_1.State_1_Default && icon_Button._size === Icon_Button.Size.Size_Medium
    
            PropertyChanges {
                width: 44
    
                target: icon_Button
            }
            PropertyChanges {
                height: 44
    
                target: icon_Button
            }
            PropertyChanges {
                color: "#f5f5f5"
                target: icon_Button
            }
            PropertyChanges {
                border.width: 1
                target: icon_Button
            }
            PropertyChanges {
                border.color: "#d9d9d9"
                target: icon_Button
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
        },
        State {
            name: "Variant=Neutral, State=Default, Size=Small"
            when: icon_Button._variant === Icon_Button.Variant.Variant_Neutral && icon_Button._state === Icon_Button.State_1.State_1_Default && icon_Button._size === Icon_Button.Size.Size_Small
    
            PropertyChanges {
                width: 36
    
                target: icon_Button
            }
            PropertyChanges {
                height: 36
    
                target: icon_Button
            }
            PropertyChanges {
                color: "#f5f5f5"
                target: icon_Button
            }
            PropertyChanges {
                border.width: 1
                target: icon_Button
            }
            PropertyChanges {
                border.color: "#d9d9d9"
                target: icon_Button
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
        },
        State {
            name: "Variant=Subtle, State=Default, Size=Medium"
            when: icon_Button._variant === Icon_Button.Variant.Variant_Subtle && icon_Button._state === Icon_Button.State_1.State_1_Default && icon_Button._size === Icon_Button.Size.Size_Medium
    
            PropertyChanges {
                width: 40
    
                target: icon_Button
            }
            PropertyChanges {
                height: 40
    
                target: icon_Button
            }
            PropertyChanges {
                color: "transparent"
                target: icon_Button
            }
            PropertyChanges {
                border.width: 0
                target: icon_Button
            }
            PropertyChanges {
                border.color: "white"
                target: icon_Button
            }
            PropertyChanges {
                x: 10
    
                target: star
            }
            PropertyChanges {
                y: 10
    
                target: star
            }
            PropertyChanges {
                icon_ShapePath0StrokeColor: "#1e1e1e"
                target: star
            }
        },
        State {
            name: "Variant=Subtle, State=Default, Size=Small"
            when: icon_Button._variant === Icon_Button.Variant.Variant_Subtle && icon_Button._state === Icon_Button.State_1.State_1_Default && icon_Button._size === Icon_Button.Size.Size_Small
    
            PropertyChanges {
                width: 36
    
                target: icon_Button
            }
            PropertyChanges {
                height: 36
    
                target: icon_Button
            }
            PropertyChanges {
                color: "transparent"
                target: icon_Button
            }
            PropertyChanges {
                border.width: 0
                target: icon_Button
            }
            PropertyChanges {
                border.color: "white"
                target: icon_Button
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
        },
        State {
            name: "Variant=Primary, State=Hover, Size=Medium"
            when: icon_Button._variant === Icon_Button.Variant.Variant_Primary && icon_Button._state === Icon_Button.State_1.State_1_Hover && icon_Button._size === Icon_Button.Size.Size_Medium
    
            PropertyChanges {
                width: 44
    
                target: icon_Button
            }
            PropertyChanges {
                height: 44
    
                target: icon_Button
            }
            PropertyChanges {
                color: "#1e1e1e"
                target: icon_Button
            }
            PropertyChanges {
                border.width: 1
                target: icon_Button
            }
            PropertyChanges {
                border.color: "#2c2c2c"
                target: icon_Button
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
        },
        State {
            name: "Variant=Primary, State=Hover, Size=Small"
            when: icon_Button._variant === Icon_Button.Variant.Variant_Primary && icon_Button._state === Icon_Button.State_1.State_1_Hover && icon_Button._size === Icon_Button.Size.Size_Small
    
            PropertyChanges {
                width: 36
    
                target: icon_Button
            }
            PropertyChanges {
                height: 36
    
                target: icon_Button
            }
            PropertyChanges {
                color: "#1e1e1e"
                target: icon_Button
            }
            PropertyChanges {
                border.width: 1
                target: icon_Button
            }
            PropertyChanges {
                border.color: "#2c2c2c"
                target: icon_Button
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
        },
        State {
            name: "Variant=Neutral, State=Hover, Size=Medium"
            when: icon_Button._variant === Icon_Button.Variant.Variant_Neutral && icon_Button._state === Icon_Button.State_1.State_1_Hover && icon_Button._size === Icon_Button.Size.Size_Medium
    
            PropertyChanges {
                width: 44
    
                target: icon_Button
            }
            PropertyChanges {
                height: 44
    
                target: icon_Button
            }
            PropertyChanges {
                color: "#e6e6e6"
                target: icon_Button
            }
            PropertyChanges {
                border.width: 1
                target: icon_Button
            }
            PropertyChanges {
                border.color: "#d9d9d9"
                target: icon_Button
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
        },
        State {
            name: "Variant=Neutral, State=Hover, Size=Small"
            when: icon_Button._variant === Icon_Button.Variant.Variant_Neutral && icon_Button._state === Icon_Button.State_1.State_1_Hover && icon_Button._size === Icon_Button.Size.Size_Small
    
            PropertyChanges {
                width: 36
    
                target: icon_Button
            }
            PropertyChanges {
                height: 36
    
                target: icon_Button
            }
            PropertyChanges {
                color: "#e6e6e6"
                target: icon_Button
            }
            PropertyChanges {
                border.width: 1
                target: icon_Button
            }
            PropertyChanges {
                border.color: "#d9d9d9"
                target: icon_Button
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
        },
        State {
            name: "Variant=Subtle, State=Hover, Size=Medium"
            when: icon_Button._variant === Icon_Button.Variant.Variant_Subtle && icon_Button._state === Icon_Button.State_1.State_1_Hover && icon_Button._size === Icon_Button.Size.Size_Medium
    
            PropertyChanges {
                width: 40
    
                target: icon_Button
            }
            PropertyChanges {
                height: 40
    
                target: icon_Button
            }
            PropertyChanges {
                color: "#f5f5f5"
                target: icon_Button
            }
            PropertyChanges {
                border.width: 0
                target: icon_Button
            }
            PropertyChanges {
                border.color: "white"
                target: icon_Button
            }
            PropertyChanges {
                x: 10
    
                target: star
            }
            PropertyChanges {
                y: 10
    
                target: star
            }
            PropertyChanges {
                icon_ShapePath0StrokeColor: "#1e1e1e"
                target: star
            }
        },
        State {
            name: "Variant=Subtle, State=Hover, Size=Small"
            when: icon_Button._variant === Icon_Button.Variant.Variant_Subtle && icon_Button._state === Icon_Button.State_1.State_1_Hover && icon_Button._size === Icon_Button.Size.Size_Small
    
            PropertyChanges {
                width: 36
    
                target: icon_Button
            }
            PropertyChanges {
                height: 36
    
                target: icon_Button
            }
            PropertyChanges {
                color: "#f5f5f5"
                target: icon_Button
            }
            PropertyChanges {
                border.width: 0
                target: icon_Button
            }
            PropertyChanges {
                border.color: "white"
                target: icon_Button
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
        },
        State {
            name: "Variant=Primary, State=Disabled, Size=Medium"
            when: icon_Button._variant === Icon_Button.Variant.Variant_Primary && icon_Button._state === Icon_Button.State_1.State_1_Disabled && icon_Button._size === Icon_Button.Size.Size_Medium
    
            PropertyChanges {
                width: 44
    
                target: icon_Button
            }
            PropertyChanges {
                height: 44
    
                target: icon_Button
            }
            PropertyChanges {
                color: "#d9d9d9"
                target: icon_Button
            }
            PropertyChanges {
                border.width: 1
                target: icon_Button
            }
            PropertyChanges {
                border.color: "#b3b3b3"
                target: icon_Button
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
        },
        State {
            name: "Variant=Primary, State=Disabled, Size=Small"
            when: icon_Button._variant === Icon_Button.Variant.Variant_Primary && icon_Button._state === Icon_Button.State_1.State_1_Disabled && icon_Button._size === Icon_Button.Size.Size_Small
    
            PropertyChanges {
                width: 36
    
                target: icon_Button
            }
            PropertyChanges {
                height: 36
    
                target: icon_Button
            }
            PropertyChanges {
                color: "#d9d9d9"
                target: icon_Button
            }
            PropertyChanges {
                border.width: 1
                target: icon_Button
            }
            PropertyChanges {
                border.color: "#b3b3b3"
                target: icon_Button
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
        },
        State {
            name: "Variant=Neutral, State=Disabled, Size=Medium"
            when: icon_Button._variant === Icon_Button.Variant.Variant_Neutral && icon_Button._state === Icon_Button.State_1.State_1_Disabled && icon_Button._size === Icon_Button.Size.Size_Medium
    
            PropertyChanges {
                width: 44
    
                target: icon_Button
            }
            PropertyChanges {
                height: 44
    
                target: icon_Button
            }
            PropertyChanges {
                color: "#d9d9d9"
                target: icon_Button
            }
            PropertyChanges {
                border.width: 1
                target: icon_Button
            }
            PropertyChanges {
                border.color: "#b3b3b3"
                target: icon_Button
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
        },
        State {
            name: "Variant=Neutral, State=Disabled, Size=Small"
            when: icon_Button._variant === Icon_Button.Variant.Variant_Neutral && icon_Button._state === Icon_Button.State_1.State_1_Disabled && icon_Button._size === Icon_Button.Size.Size_Small
    
            PropertyChanges {
                width: 36
    
                target: icon_Button
            }
            PropertyChanges {
                height: 36
    
                target: icon_Button
            }
            PropertyChanges {
                color: "#d9d9d9"
                target: icon_Button
            }
            PropertyChanges {
                border.width: 1
                target: icon_Button
            }
            PropertyChanges {
                border.color: "#b3b3b3"
                target: icon_Button
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
        },
        State {
            name: "Variant=Subtle, State=Disabled, Size=Medium"
            when: icon_Button._variant === Icon_Button.Variant.Variant_Subtle && icon_Button._state === Icon_Button.State_1.State_1_Disabled && icon_Button._size === Icon_Button.Size.Size_Medium
    
            PropertyChanges {
                width: 40
    
                target: icon_Button
            }
            PropertyChanges {
                height: 40
    
                target: icon_Button
            }
            PropertyChanges {
                color: "#d9d9d9"
                target: icon_Button
            }
            PropertyChanges {
                border.width: 1
                target: icon_Button
            }
            PropertyChanges {
                border.color: "#b3b3b3"
                target: icon_Button
            }
            PropertyChanges {
                x: 10
    
                target: star
            }
            PropertyChanges {
                y: 10
    
                target: star
            }
            PropertyChanges {
                icon_ShapePath0StrokeColor: "#b3b3b3"
                target: star
            }
        },
        State {
            name: "Variant=Subtle, State=Disabled, Size=Small"
            when: icon_Button._variant === Icon_Button.Variant.Variant_Subtle && icon_Button._state === Icon_Button.State_1.State_1_Disabled && icon_Button._size === Icon_Button.Size.Size_Small
    
            PropertyChanges {
                width: 36
    
                target: icon_Button
            }
            PropertyChanges {
                height: 36
    
                target: icon_Button
            }
            PropertyChanges {
                color: "#d9d9d9"
                target: icon_Button
            }
            PropertyChanges {
                border.width: 1
                target: icon_Button
            }
            PropertyChanges {
                border.color: "#b3b3b3"
                target: icon_Button
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
        }
    ]

    Star_1 {
        id: star

        x: 12
        y: 12

        clip: true
        icon_ShapePath0StrokeColor: "#f5f5f5"
    }
}