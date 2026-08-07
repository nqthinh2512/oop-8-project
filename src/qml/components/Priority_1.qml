import QtQuick
import src
import QtQuick.Layouts

Item {
    id: root
    property int priority_2: 1 // 0 = Low, 1 = Medium, 2 = High

    implicitWidth: badge.implicitWidth
    implicitHeight: 24
    width: implicitWidth
    height: implicitHeight

    readonly property var priorityConfig: {
        if (root.priority_2 === 2) {
            return { text: "High", color: "#dc2626", bg: "#fee2e2" }
        } else if (root.priority_2 === 0) {
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
