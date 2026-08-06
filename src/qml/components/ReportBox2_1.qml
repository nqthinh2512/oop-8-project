import QtQuick
import src
import QtQuick.Layouts

Rectangle {
    id: root

    property string titleText: "Bills"

    property string row1Label: "Total Due"
    property string row1Amount: "100,000 VND"

    property string row2Label: "Overdue"
    property string row2Amount: "2,000,000 VND"

    property string row3Label: "Paid"
    property string row3Amount: "1,000 VND"

    implicitHeight: 160
    Layout.fillWidth: true
    Layout.preferredWidth: 1
    clip: true

    color: AppTheme.bgCard
    border.color: AppTheme.border
    border.width: 1
    radius: 12

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 18
        spacing: 10

        // Title Header
        Text {
            font.family: "Intel One Mono"
            font.pixelSize: 15
            font.weight: Font.Bold
            color: AppTheme.textMain
            text: root.titleText
            Layout.fillWidth: true
        }

        Rectangle {
            Layout.fillWidth: true
            height: 1
            color: AppTheme.border
        }

        // Data Rows
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 8

            // Row 1
            RowLayout {
                Layout.fillWidth: true
                Text {
                    font.family: "Inter"
                    font.pixelSize: 13
                    color: AppTheme.textSub
                    text: root.row1Label
                    Layout.fillWidth: true
                    elide: Text.ElideRight
                }
                Text {
                    font.family: "Intel One Mono"
                    font.pixelSize: 13
                    font.weight: Font.Bold
                    color: AppTheme.textMain
                    text: root.row1Amount
                    elide: Text.ElideRight
                }
            }

            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: AppTheme.bgHover
            }

            // Row 2
            RowLayout {
                Layout.fillWidth: true
                Text {
                    font.family: "Inter"
                    font.pixelSize: 13
                    color: AppTheme.textSub
                    text: root.row2Label
                    Layout.fillWidth: true
                    elide: Text.ElideRight
                }
                Text {
                    font.family: "Intel One Mono"
                    font.pixelSize: 13
                    font.weight: Font.Bold
                    color: AppTheme.textMain
                    text: root.row2Amount
                    elide: Text.ElideRight
                }
            }

            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: AppTheme.bgHover
            }

            // Row 3
            RowLayout {
                Layout.fillWidth: true
                Text {
                    font.family: "Inter"
                    font.pixelSize: 13
                    color: AppTheme.textSub
                    text: root.row3Label
                    Layout.fillWidth: true
                    elide: Text.ElideRight
                }
                Text {
                    font.family: "Intel One Mono"
                    font.pixelSize: 13
                    font.weight: Font.Bold
                    color: AppTheme.textMain
                    text: root.row3Amount
                    elide: Text.ElideRight
                }
            }
        }
    }
}
