import QtQuick
import src
import QtQuick.Layouts

Rectangle {
    id: pageBox

    implicitHeight: 120
    height: implicitHeight
    Layout.fillWidth: true

    color: AppTheme.bgCard
    radius: 12
    border.color: AppTheme.border
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
            color: AppTheme.textSub
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
                color: AppTheme.textMain
                font.family: "Intel One Mono"
                font.pixelSize: 24
                font.weight: Font.Bold
                text: pageBox.amountText
                elide: Text.ElideRight
                Layout.fillWidth: true
            }

            Text {
                id: label
                color: AppTheme.textMuted
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
