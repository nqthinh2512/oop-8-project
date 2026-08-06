import QtQuick
import src

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
    border.color: AppTheme.border
    border.width: 1
    color: "transparent"

    // Dynamic Visual Properties based on State
    states: [
        State {
            name: "selected"
            when: universalButton._state === UniversalButton_1.State_1.State_1_selected

            PropertyChanges {
                target: universalButton
                border.width: 0
                border.color: "transparent"
                color: AppTheme.primary
            }
            PropertyChanges {
                target: label
                color: AppTheme.bgCard
                font.weight: Font.Bold
            }
        },
        State {
            name: "hover"
            when: universalButton._state === UniversalButton_1.State_1.State_1_hover || (mouseArea.containsMouse && universalButton._state !== UniversalButton_1.State_1.State_1_selected)

            PropertyChanges {
                target: universalButton
                border.width: 1
                border.color: AppTheme.primary
                color: AppTheme.isDark ? AppTheme.bgHover : "#eff6ff"
            }
            PropertyChanges {
                target: label
                color: AppTheme.primary
                font.weight: Font.DemiBold
            }
        },
        State {
            name: "default"
            when: universalButton._state === UniversalButton_1.State_1.State_1_default && !mouseArea.containsMouse

            PropertyChanges {
                target: universalButton
                border.width: 1
                border.color: AppTheme.border
                color: AppTheme.bgCard
            }
            PropertyChanges {
                target: label
                color: AppTheme.textMain
                font.weight: Font.Medium
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

        onClicked: universalButton.clicked()
    }
}
