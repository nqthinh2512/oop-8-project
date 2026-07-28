import QtQuick
import QtQuick.Layouts

Item {
    id: root

    property string spentText: "1,000 VND"
    property string limitText: "/ 20,000 VND"
    property real progressFraction: 0.67
    property string subText: "67% saved"
    property color progressColor: "#3b82f6"

    implicitHeight: 48
    Layout.fillWidth: true

    ColumnLayout {
        anchors.fill: parent
        anchors.verticalCenter: parent.verticalCenter
        spacing: 4

        // Top Row: Spent / Limit
        RowLayout {
            Layout.fillWidth: true
            spacing: 4

            Text {
                font.family: "Intel One Mono"
                font.pixelSize: 13
                font.weight: Font.Bold
                color: "#0f172a"
                text: root.spentText
            }

            Text {
                font.family: "Intel One Mono"
                font.pixelSize: 12
                color: "#64748b"
                text: root.limitText
                Layout.fillWidth: true
            }
        }

        // Middle Row: Progress Bar Track
        Rectangle {
            Layout.fillWidth: true
            implicitHeight: 6
            radius: 3
            color: "#e2e8f0"

            Rectangle {
                width: parent.width * Math.min(Math.max(root.progressFraction, 0), 1)
                height: parent.height
                radius: 3
                color: root.progressColor
            }
        }

        // Bottom Row: SubText (67% saved)
        Text {
            font.family: "Intel One Mono"
            font.pixelSize: 11
            color: "#94a3b8"
            text: root.subText
            Layout.alignment: Qt.AlignHCenter
        }
    }
}