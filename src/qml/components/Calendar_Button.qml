import QtQuick

Rectangle {
    enum State_1 { State_1_Default, State_1_Hover, State_1_Active, State_1_Disabled, State_1_Range, State_1_Range_Disabled, State_1_Hidden}

    id: calendar_Button

    property alias day_pickerTextFormat: day_picker.textFormat
    property alias day_pickerVisible: day_picker.visible
    property alias day_pickerWidth: day_picker.width
    property alias day_pickerX: day_picker.x

    property int _state: Calendar_Button.State_1.State_1_Default
    property string number: "1"

    height: 40
    width: 40

    border.color: "white"
    border.width: 0
    color: "transparent"
    radius: 8

    states: [
        State {
            name: "State=Default"
            when: calendar_Button._state === Calendar_Button.State_1.State_1_Default
    
            PropertyChanges {
                color: "transparent"
                target: calendar_Button
            }
            PropertyChanges {
                border.width: 0
                target: calendar_Button
            }
            PropertyChanges {
                border.color: "white"
                target: calendar_Button
            }
            PropertyChanges {
                target: day_picker
                text: calendar_Button.number
            }
            PropertyChanges {
                color: "#1e1e1e"
                target: day_picker
            }
            PropertyChanges {
                target: day_picker
                visible: true
            }
            PropertyChanges {
                target: day_picker
                textFormat: Text.AutoText
            }
        },
        State {
            name: "State=Hover"
            when: calendar_Button._state === Calendar_Button.State_1.State_1_Hover
    
            PropertyChanges {
                color: "#ffffff"
                target: calendar_Button
            }
            PropertyChanges {
                border.width: 1
                target: calendar_Button
            }
            PropertyChanges {
                border.color: "#d9d9d9"
                target: calendar_Button
            }
            PropertyChanges {
                target: day_picker
                text: calendar_Button.number
            }
            PropertyChanges {
                color: "#2c2c2c"
                target: day_picker
            }
            PropertyChanges {
                target: day_picker
                visible: true
            }
            PropertyChanges {
                target: day_picker
                textFormat: Text.AutoText
            }
        },
        State {
            name: "State=Active"
            when: calendar_Button._state === Calendar_Button.State_1.State_1_Active
    
            PropertyChanges {
                color: "#2c2c2c"
                target: calendar_Button
            }
            PropertyChanges {
                border.width: 0
                target: calendar_Button
            }
            PropertyChanges {
                border.color: "white"
                target: calendar_Button
            }
            PropertyChanges {
                target: day_picker
                text: calendar_Button.number
            }
            PropertyChanges {
                color: "#f5f5f5"
                target: day_picker
            }
            PropertyChanges {
                target: day_picker
                visible: true
            }
            PropertyChanges {
                target: day_picker
                textFormat: Text.AutoText
            }
        },
        State {
            name: "State=Hidden"
            when: calendar_Button._state === Calendar_Button.State_1.State_1_Hidden
    
            PropertyChanges {
                color: "transparent"
                target: calendar_Button
            }
            PropertyChanges {
                border.width: 0
                target: calendar_Button
            }
            PropertyChanges {
                border.color: "white"
                target: calendar_Button
            }
            PropertyChanges {
                target: day_picker
                text: "1"
            }
            PropertyChanges {
                color: "#1e1e1e"
                target: day_picker
            }
            PropertyChanges {
                target: day_picker
                visible: false
            }
            PropertyChanges {
                target: day_picker
                textFormat: Text.PlainText
            }
        },
        State {
            name: "State=Disabled"
            when: calendar_Button._state === Calendar_Button.State_1.State_1_Disabled
    
            PropertyChanges {
                color: "transparent"
                target: calendar_Button
            }
            PropertyChanges {
                border.width: 0
                target: calendar_Button
            }
            PropertyChanges {
                border.color: "white"
                target: calendar_Button
            }
            PropertyChanges {
                target: day_picker
                text: calendar_Button.number
            }
            PropertyChanges {
                color: "#b3b3b3"
                target: day_picker
            }
            PropertyChanges {
                target: day_picker
                visible: true
            }
            PropertyChanges {
                target: day_picker
                textFormat: Text.AutoText
            }
        },
        State {
            name: "State=Range"
            when: calendar_Button._state === Calendar_Button.State_1.State_1_Range
    
            PropertyChanges {
                color: "#f5f5f5"
                target: calendar_Button
            }
            PropertyChanges {
                border.width: 0
                target: calendar_Button
            }
            PropertyChanges {
                border.color: "white"
                target: calendar_Button
            }
            PropertyChanges {
                target: day_picker
                text: calendar_Button.number
            }
            PropertyChanges {
                color: "#2c2c2c"
                target: day_picker
            }
            PropertyChanges {
                target: day_picker
                visible: true
            }
            PropertyChanges {
                target: day_picker
                textFormat: Text.AutoText
            }
        },
        State {
            name: "State=Range Disabled"
            when: calendar_Button._state === Calendar_Button.State_1.State_1_Range_Disabled
    
            PropertyChanges {
                color: "transparent"
                target: calendar_Button
            }
            PropertyChanges {
                border.width: 0
                target: calendar_Button
            }
            PropertyChanges {
                border.color: "white"
                target: calendar_Button
            }
            PropertyChanges {
                target: day_picker
                text: calendar_Button.number
            }
            PropertyChanges {
                color: "#b3b3b3"
                target: day_picker
            }
            PropertyChanges {
                target: day_picker
                visible: true
            }
            PropertyChanges {
                target: day_picker
                textFormat: Text.AutoText
            }
        }
    ]

    Text {
        id: day_picker

        x: 16
        y: 9

        height: 22
        width: 9

        color: "#1e1e1e"
        font.family: "Inter"
        font.pixelSize: 16
        font.weight: Font.Normal
        horizontalAlignment: Text.AlignHCenter
        lineHeight: 22.40
        lineHeightMode: Text.FixedHeight
        text: calendar_Button.number
        textFormat: Text.AutoText
        verticalAlignment: Text.AlignVCenter
        visible: true
    }
}