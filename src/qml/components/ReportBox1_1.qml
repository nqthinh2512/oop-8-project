import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root

    property string titleText: "MONTHLY INCOME"
    property string amountText: "1,000 VND"
    property string labelText: "July 2026"
    property string subtitleText: "+4.2% vs June"
    property color subtitleColor: "#6366f1"

    implicitHeight: 140
    Layout.fillWidth: true
    Layout.preferredWidth: 1
    clip: true

    color: "#ffffff"
    border.color: "#e2e8f0"
    border.width: 1
    radius: 12

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 18
        spacing: 6

        // Card Title
        Text {
            font.family: "Intel One Mono"
            font.pixelSize: 12
            font.weight: Font.Bold
            color: "#64748b"
            text: root.titleText.toUpperCase()
            elide: Text.ElideRight
            Layout.fillWidth: true
        }

        // Amount & Label
        Text {
            font.family: "Intel One Mono"
            font.pixelSize: 20
            font.weight: Font.Bold
            color: "#0f172a"
            text: root.amountText
            elide: Text.ElideRight
            Layout.fillWidth: true
        }

        Text {
            font.family: "Inter"
            font.pixelSize: 12
            color: "#64748b"
            text: root.labelText
            elide: Text.ElideRight
            Layout.fillWidth: true
        }

        Item { Layout.fillHeight: true }

        // Subtitle / Trend
        Text {
            font.family: "Inter"
            font.pixelSize: 11
            font.weight: Font.Medium
            color: root.subtitleColor
            text: root.subtitleText
            elide: Text.ElideRight
            visible: root.subtitleText.length > 0
            Layout.fillWidth: true
        }
    }
}