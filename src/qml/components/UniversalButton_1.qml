import QtQuick

Rectangle {
    enum State_1 { State_1_default, State_1_hover, State_1_selected }

    id: universalButton

    // Exposed API Properties
    property int _state: UniversalButton_1.State_1.State_1_default
    property string buttonText: "Button"
    property alias universalButtonBorderWidth: universalButton.border.width

    // Signals
    signal clicked()

    implicitWidth: label.implicitWidth + 28
    implicitHeight: 38
    width: implicitWidth
    height: implicitHeight

    radius: height / 2
    border.color: "#d1d5db"
    border.width: 1
    color: "transparent"

    // Dynamic Visual Properties based on State
    states: [
        State {
            name: "default"
            when: universalButton._state === UniversalButton_1.State_1.State_1_default

            PropertyChanges {
                target: universalButton
                border.width: 1
                border.color: "#d1d5db"
                color: "#ffffff"
            }
            PropertyChanges {
                target: label
                color: "#4b5563"
                font.weight: Font.Medium
            }
        },
        State {
            name: "hover"
            when: universalButton._state === UniversalButton_1.State_1.State_1_hover

            PropertyChanges {
                target: universalButton
                border.width: 1
                border.color: "#3b82f6"
                color: "#eff6ff"
            }
            PropertyChanges {
                target: label
                color: "#2563eb"
                font.weight: Font.DemiBold
            }
        },
        State {
            name: "selected"
            when: universalButton._state === UniversalButton_1.State_1.State_1_selected

            PropertyChanges {
                target: universalButton
                border.width: 0
                border.color: "transparent"
                color: "#3b82f6"
            }
            PropertyChanges {
                target: label
                color: "#ffffff"
                font.weight: Font.Bold
            }
        }
    ]

    // Button Text Label
    Text {
        id: label
        anchors.centerIn: parent

        font.family: "Inter"
        font.pixelSize: 14
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        text: universalButton.buttonText
    }

    // Interactivity
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onEntered: {
            if (universalButton._state !== UniversalButton_1.State_1.State_1_selected) {
                universalButton._state = UniversalButton_1.State_1.State_1_hover
            }
        }
        onExited: {
            if (universalButton._state !== UniversalButton_1.State_1.State_1_selected) {
                universalButton._state = UniversalButton_1.State_1.State_1_default
            }
        }
        onClicked: universalButton.clicked()
    }
}