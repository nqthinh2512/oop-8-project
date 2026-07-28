import QtQuick
import QtQuick.Layouts

Rectangle {
    id: pageBox

    implicitHeight: 120
    height: implicitHeight
    Layout.fillWidth: true

    color: "#ffffff"
    radius: 12
    border.color: "#e2e8f0"
    border.width: 1

    // Exposed API Properties for Data Binding
    property string boxTitle: "TITLE"
    property string amountText: "$0.00"
    property string labelText: "Label"

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 8

        // 1. Card Title (e.g., "TOTAL DUE", "TOTAL OVERDUE", "TOTAL PAID")
        Text {
            id: title
            color: "#64748b"
            font.family: "Intel One Mono"
            font.pixelSize: 13
            font.weight: Font.Bold
            text: pageBox.boxTitle.toUpperCase()
            elide: Text.ElideRight
            Layout.fillWidth: true
        }

        // 2. Main Value & Secondary Label
        ColumnLayout {
            spacing: 2
            Layout.fillWidth: true

            Text {
                id: amount_1
                color: "#0f172a"
                font.family: "Intel One Mono"
                font.pixelSize: 24
                font.weight: Font.Bold
                text: pageBox.amountText
                elide: Text.ElideRight
                Layout.fillWidth: true
            }

            Text {
                id: label
                color: "#94a3b8"
                font.family: "Inter"
                font.pixelSize: 13
                font.weight: Font.Medium
                text: pageBox.labelText
                elide: Text.ElideRight
                Layout.fillWidth: true
            }
        }
    }
}