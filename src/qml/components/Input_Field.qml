import QtQuick

Rectangle {
    enum State_1 { State_1_Disabled, State_1_Default, State_1_Error}
    enum Value_Type { Value_Type_Default, Value_Type_Placeholder}

    id: input_Field

    property alias errorColor: error.color
    property alias errorWidth: error.width
    property alias errorY: error.y
    property alias inputHeight: input.height
    property alias inputWidth: input.width
    property alias inputY: input.y
    property alias labelFontLetterSpacing: label.font.letterSpacing
    property alias labelFontPixelSize: label.font.pixelSize
    property alias labelFontWeight: label.font.weight
    property alias labelHeight: label.height
    property alias labelLineHeight: label.lineHeight
    property alias labelWidth: label.width
    property alias valueColor: value.color
    property alias valueFontFamily: value.font.family
    property alias valueFontPixelSize: value.font.pixelSize
    property alias valueHeight: value.height
    property alias valueLineHeight: value.lineHeight
    property alias valueVisible: value.visible
    property alias valueWidth: value.width

    property int _state: Input_Field.State_1.State_1_Default
    property string description: "Description"
    property string error: "Error"
    property bool has_Description: false
    property bool has_Error: false
    property bool has_Label: true
    property string label: "Label"
    property string value: "Value"
    property int value_Type_1: Input_Field.Value_Type.Value_Type_Default

    height: 70
    width: 120

    color: "transparent"

    states: [
        State {
            name: "State=Default, Value Type=Default"
            when: input_Field._state === Input_Field.State_1.State_1_Default && input_Field.value_Type_1 === Input_Field.Value_Type.Value_Type_Default
    
            PropertyChanges {
                color: "#1e1e1e"
                target: label
            }
            PropertyChanges {
                color: "#ffffff"
                target: input
            }
            PropertyChanges {
                border.color: "#d9d9d9"
                target: input
            }
            PropertyChanges {
                color: "#1e1e1e"
                target: value
            }
            PropertyChanges {
                color: "#1e1e1e"
                target: error
            }
        },
        State {
            name: "State=Default, Value Type=Placeholder"
            when: input_Field._state === Input_Field.State_1.State_1_Default && input_Field.value_Type_1 === Input_Field.Value_Type.Value_Type_Placeholder
    
            PropertyChanges {
                color: "#1e1e1e"
                target: label
            }
            PropertyChanges {
                color: "#ffffff"
                target: input
            }
            PropertyChanges {
                border.color: "#d9d9d9"
                target: input
            }
            PropertyChanges {
                color: "#b3b3b3"
                target: value
            }
            PropertyChanges {
                color: "#1e1e1e"
                target: error
            }
        },
        State {
            name: "State=Error, Value Type=Placeholder"
            when: input_Field._state === Input_Field.State_1.State_1_Error && input_Field.value_Type_1 === Input_Field.Value_Type.Value_Type_Placeholder
    
            PropertyChanges {
                color: "#1e1e1e"
                target: label
            }
            PropertyChanges {
                color: "#ffffff"
                target: input
            }
            PropertyChanges {
                border.color: "#900b09"
                target: input
            }
            PropertyChanges {
                color: "#b3b3b3"
                target: value
            }
            PropertyChanges {
                color: "#900b09"
                target: error
            }
        },
        State {
            name: "State=Error, Value Type=Default"
            when: input_Field._state === Input_Field.State_1.State_1_Error && input_Field.value_Type_1 === Input_Field.Value_Type.Value_Type_Default
    
            PropertyChanges {
                color: "#1e1e1e"
                target: label
            }
            PropertyChanges {
                color: "#ffffff"
                target: input
            }
            PropertyChanges {
                border.color: "#900b09"
                target: input
            }
            PropertyChanges {
                color: "#1e1e1e"
                target: value
            }
            PropertyChanges {
                color: "#900b09"
                target: error
            }
        },
        State {
            name: "State=Disabled, Value Type=Placeholder"
            when: input_Field._state === Input_Field.State_1.State_1_Disabled && input_Field.value_Type_1 === Input_Field.Value_Type.Value_Type_Placeholder
    
            PropertyChanges {
                color: "#b3b3b3"
                target: label
            }
            PropertyChanges {
                color: "#d9d9d9"
                target: input
            }
            PropertyChanges {
                border.color: "#b3b3b3"
                target: input
            }
            PropertyChanges {
                color: "#b3b3b3"
                target: value
            }
            PropertyChanges {
                color: "#1e1e1e"
                target: error
            }
        },
        State {
            name: "State=Disabled, Value Type=Default"
            when: input_Field._state === Input_Field.State_1.State_1_Disabled && input_Field.value_Type_1 === Input_Field.Value_Type.Value_Type_Default
    
            PropertyChanges {
                color: "#b3b3b3"
                target: label
            }
            PropertyChanges {
                color: "#d9d9d9"
                target: input
            }
            PropertyChanges {
                border.color: "#b3b3b3"
                target: input
            }
            PropertyChanges {
                color: "#b3b3b3"
                target: value
            }
            PropertyChanges {
                color: "#1e1e1e"
                target: error
            }
        }
    ]

    Text {
        id: label

        height: 22
        width: 121

        color: "#1e1e1e"
        font.family: "Inter"
        font.letterSpacing: 0
        font.pixelSize: 16
        font.weight: Font.Normal
        horizontalAlignment: Text.AlignLeft
        lineHeight: 22.40
        lineHeightMode: Text.FixedHeight
        text: input_Field.label
        verticalAlignment: Text.AlignTop
        visible: input_Field.has_Label
        wrapMode: Text.Wrap
    }
    Text {
        id: description

        y: 30

        height: 22
        width: 241

        color: "#757575"
        font.family: "Inter"
        font.pixelSize: 16
        font.weight: Font.Normal
        horizontalAlignment: Text.AlignLeft
        lineHeight: 22.40
        lineHeightMode: Text.FixedHeight
        text: input_Field.description
        verticalAlignment: Text.AlignTop
        visible: input_Field.has_Description
        wrapMode: Text.Wrap
    }
    Rectangle {
        id: input

        y: 30

        height: 40
        width: 120

        border.color: "#d9d9d9"
        border.width: 1
        clip: true
        color: "#ffffff"
        radius: 8

        Text {
            id: value

            x: 16
            y: 12

            height: 16
            width: 89

            color: "#1e1e1e"
            font.family: "Inter"
            font.pixelSize: 16
            font.weight: Font.Normal
            horizontalAlignment: Text.AlignLeft
            lineHeight: 16
            lineHeightMode: Text.FixedHeight
            text: input_Field.value
            verticalAlignment: Text.AlignTop
            visible: true
            wrapMode: Text.Wrap
        }
    }
    Text {
        id: error

        y: 78

        height: 22
        width: 38

        color: "#1e1e1e"
        font.family: "Inter"
        font.pixelSize: 16
        font.weight: Font.Normal
        horizontalAlignment: Text.AlignLeft
        lineHeight: 22.40
        lineHeightMode: Text.FixedHeight
        text: input_Field.error
        verticalAlignment: Text.AlignTop
        visible: input_Field.has_Error
    }
}