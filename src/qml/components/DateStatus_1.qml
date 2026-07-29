import QtQuick

Rectangle {
    enum State_1 { State_1_overdue, State_1_default}

    id: dateStatus

    property alias createdLabelFontPixelSize: createdLabel.font.pixelSize
    property alias createdLabelHeight: createdLabel.height
    property alias createdLabelWidth: createdLabel.width
    property alias createdLabelX: createdLabel.x
    property alias createdLabelY: createdLabel.y

    property int _state: DateStatus_1.State_1.State_1_overdue

    height: 56
    width: 200

    color: "transparent"

    states: [
        State {
            name: "state=overdue"
            when: dateStatus._state === DateStatus_1.State_1.State_1_overdue
    
            PropertyChanges {
                color: "#ff0004"
                target: createdLabel
            }
            PropertyChanges {
                target: overdue
                visible: true
            }
        },
        State {
            name: "state=default"
            when: dateStatus._state === DateStatus_1.State_1.State_1_default
    
            PropertyChanges {
                color: "#636363"
                target: createdLabel
            }
            PropertyChanges {
                target: overdue
                visible: false
            }
        }
    ]

    Text {
        id: createdLabel

        x: 15
        y: 17

        height: 22
        width: 100

        color: "#ff0004"
        font.family: "Intel One Mono"
        font.pixelSize: 16
        font.weight: Font.Normal
        horizontalAlignment: Text.AlignLeft
        text: "31/12/2012"
        textFormat: Text.PlainText
        verticalAlignment: Text.AlignVCenter
    }
    Rectangle {
        id: overdue

        x: 124
        y: 19.50

        height: 17
        width: 60

        border.color: "#ff8688"
        border.width: 0.50
        color: "#40ff7d7f"
        radius: 8
        visible: true

        Text {
            id: overdue_1

            x: 5
            y: 1

            height: 15
            width: 51

            color: "#ff0004"
            font.family: "Inter"
            font.pixelSize: 12
            font.weight: Font.DemiBold
            horizontalAlignment: Text.AlignLeft
            text: "Overdue"
            textFormat: Text.PlainText
            verticalAlignment: Text.AlignVCenter
        }
    }
}