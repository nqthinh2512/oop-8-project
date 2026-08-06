import QtQuick
import src

Rectangle {
    id: toggle

    // Exposed API Properties
    property bool checked: false
    property string activeColor: AppTheme.primary
    property string inactiveColor: AppTheme.border

    // Signals
    signal toggled(bool checked)

    implicitWidth: 48
    implicitHeight: 28
    width: implicitWidth
    height: implicitHeight

    radius: height / 2
    color: checked ? activeColor : inactiveColor
    border.color: checked ? Qt.darker(activeColor, 1.1) : AppTheme.divider
    border.width: 1

    Behavior on color { ColorAnimation { duration: 200 } }

    Rectangle {
        id: knob
        width: toggle.height - 4
        height: toggle.height - 4
        radius: width / 2
        color: AppTheme.bgCard
        
        x: toggle.checked ? toggle.width - width - 2 : 2
        y: 2
        
        Behavior on x { NumberAnimation { duration: 200; easing.type: Easing.OutQuad } }

        // Subtle knob shadow outline
        Rectangle {
            anchors.fill: parent
            radius: parent.radius
            color: "transparent"
            border.color: "#20000000"
            border.width: 1
        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            toggle.checked = !toggle.checked
            toggle.toggled(toggle.checked)
        }
    }
}
