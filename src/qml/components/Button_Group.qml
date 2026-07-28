import QtQuick

Rectangle {
    enum Align { Align_Justify, Align_Start, Align_End, Align_Center, Align_Stack}

    id: button_Group

    property alias buttonButton_1X: button.button_1X
    property alias button_1ButtonBorderColor: button_1.buttonBorderColor
    property alias button_1Button_1Color: button_1.button_1Color
    property alias button_1Button_1FontLetterSpacing: button_1.button_1FontLetterSpacing
    property alias button_1Button_1FontPixelSize: button_1.button_1FontPixelSize
    property alias button_1Button_1FontWeight: button_1.button_1FontWeight
    property alias button_1Button_1Height: button_1.button_1Height
    property alias button_1Button_1LineHeight: button_1.button_1LineHeight
    property alias button_1Button_1Width: button_1.button_1Width
    property alias button_1Button_1X: button_1.button_1X
    property alias button_1Color: button_1.color
    property alias button_1Height: button_1.height
    property alias button_1Label: button_1.label
    property alias button_1StarIcon_ShapePath0StrokeColor: button_1.starIcon_ShapePath0StrokeColor
    property alias button_1Width: button_1.width
    property alias button_1X: button_1.x
    property alias button_1_variant: button_1._variant
    property alias button_1_xIcon_ShapePath0StrokeColor: button_1._xIcon_ShapePath0StrokeColor

    property int align_1: Button_Group.Align.Align_Justify
    property bool button_End: true
    property bool button_Start: true

    height: 40
    width: 240

    color: "transparent"

    states: [
        State {
            name: "Align=Justify"
            when: button_Group.align_1 === Button_Group.Align.Align_Justify
    
            PropertyChanges {
                height: 40
    
                target: button_Group
            }
            PropertyChanges {
                width: 112
    
                target: button
            }
            PropertyChanges {
                x: 0
    
                target: button
            }
            PropertyChanges {
                button_1X: 30.50
                target: button
            }
            PropertyChanges {
                x: 128
    
                target: button_1
            }
            PropertyChanges {
                width: 112
    
                target: button_1
            }
            PropertyChanges {
                y: 0
    
                target: button_1
            }
            PropertyChanges {
                button_1X: 30.50
                target: button_1
            }
        },
        State {
            name: "Align=Start"
            when: button_Group.align_1 === Button_Group.Align.Align_Start
    
            PropertyChanges {
                height: 40
    
                target: button_Group
            }
            PropertyChanges {
                x: 0
    
                target: button
            }
            PropertyChanges {
                x: 91
    
                target: button_1
            }
            PropertyChanges {
                y: 0
    
                target: button_1
            }
        },
        State {
            name: "Align=End"
            when: button_Group.align_1 === Button_Group.Align.Align_End
    
            PropertyChanges {
                height: 40
    
                target: button_Group
            }
            PropertyChanges {
                x: 74
    
                target: button
            }
            PropertyChanges {
                x: 165
    
                target: button_1
            }
            PropertyChanges {
                y: 0
    
                target: button_1
            }
        },
        State {
            name: "Align=Center"
            when: button_Group.align_1 === Button_Group.Align.Align_Center
    
            PropertyChanges {
                height: 40
    
                target: button_Group
            }
            PropertyChanges {
                x: 37
    
                target: button
            }
            PropertyChanges {
                x: 128
    
                target: button_1
            }
            PropertyChanges {
                y: 0
    
                target: button_1
            }
        },
        State {
            name: "Align=Stack"
            when: button_Group.align_1 === Button_Group.Align.Align_Stack
    
            PropertyChanges {
                height: 96
    
                target: button_Group
            }
            PropertyChanges {
                width: 240
    
                target: button
            }
            PropertyChanges {
                x: 0
    
                target: button
            }
            PropertyChanges {
                button_1X: 94.50
                target: button
            }
            PropertyChanges {
                x: 0
    
                target: button_1
            }
            PropertyChanges {
                width: 240
    
                target: button_1
            }
            PropertyChanges {
                y: 56
    
                target: button_1
            }
            PropertyChanges {
                button_1X: 94.50
                target: button_1
            }
        }
    ]

    Button_1 {
        id: button

        width: 112

        _size: Button_1.Size.Size_Medium
        _state: Button_1.State_1.State_1_Default
        _variant: Button_1.Variant.Variant_Subtle
        button_1X: 30.50
        clip: true
        has_Icon_End: false
        has_Icon_Start: false
        label: "Button"
        visible: button_Group.button_Start
    }
    Button_1 {
        id: button_1

        x: 128

        width: 112

        _size: Button_1.Size.Size_Medium
        _state: Button_1.State_1.State_1_Default
        _variant: Button_1.Variant.Variant_Primary
        button_1X: 30.50
        clip: true
        has_Icon_End: false
        has_Icon_Start: false
        label: "Button"
        visible: button_Group.button_End
    }
}