import QtQuick
import QtQuick.Layouts

Item {
    enum Priority_1 { Priority_1_high, Priority_1_medium, Priority_1_low }

    id: root

    property int priority_2: Priority_1.Priority_1.Priority_1_medium

    implicitWidth: badge.implicitWidth
    implicitHeight: 24
    width: implicitWidth
    height: implicitHeight

    readonly property var priorityConfig: {
        if (root.priority_2 === Priority_1.Priority_1.Priority_1_high) {
            return { text: "High", color: "#dc2626", bg: "#fee2e2" }
        } else if (root.priority_2 === Priority_1.Priority_1.Priority_1_low) {
            return { text: "Low", color: "#16a34a", bg: "#dcfce7" }
        }
        return { text: "Medium", color: "#ca8a04", bg: "#fef9c3" }
    }

    Rectangle {
        id: badge
        anchors.verticalCenter: parent.verticalCenter
        implicitWidth: label.implicitWidth + 20
        implicitHeight: 24
        radius: 12
        color: root.priorityConfig.bg

        Text {
            id: label
            anchors.centerIn: parent
            font.family: "Inter"
            font.pixelSize: 12
            font.weight: Font.Bold
            color: root.priorityConfig.color
            text: root.priorityConfig.text
        }
    }
}