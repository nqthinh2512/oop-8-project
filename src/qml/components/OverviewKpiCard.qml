import QtQuick
import src
import QtQuick.Layouts
import QtQuick.Shapes

ColumnLayout {
    id: root

    // Exposed API Properties
    property string cardTitle: "Title"
    property bool showViewAll: false

    property string amountText: "$0"
    property string dateText: "Month, Year"

    property bool showTrend: false
    property string trendText: "0%"
    property bool isTrendUp: true
    property color accentLineColor: "#5186f8"

    signal viewAllClicked()

    spacing: 9
    Layout.fillWidth: true

    // 1. Header (Title + Optional View All Link)
    RowLayout {
        Layout.fillWidth: true
        Layout.preferredHeight: 32

        Text {
            font.family: "Inter"
            font.pixelSize: 22
            font.weight: Font.Normal
            color: "#878787"
            text: root.cardTitle
            Layout.fillWidth: true
            verticalAlignment: Text.AlignVCenter
        }

        View_all_1 {
            visible: root.showViewAll
            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
            onClicked: root.viewAllClicked()
        }
    }

    // 2. White Card Box
    Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: 96
        color: AppTheme.bgCard
        radius: 12

        ColumnLayout {
            anchors.fill: parent
            anchors.leftMargin: 24
            anchors.rightMargin: 24
            anchors.topMargin: 16
            anchors.bottomMargin: 16
            spacing: 12

            RowLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 16

                // Amount Text
                Text {
                    font.family: "Inter"
                    font.pixelSize: 26
                    font.weight: Font.Bold
                    color: AppTheme.textMain
                    text: root.amountText
                    verticalAlignment: Text.AlignVCenter
                }

                // Date Text
                Text {
                    font.family: "Inter"
                    font.pixelSize: 14
                    font.weight: Font.Medium
                    color: "#878787"
                    text: root.dateText
                    verticalAlignment: Text.AlignVCenter
                }

                // Spacer pushing trend badge to right edge
                Item {
                    Layout.fillWidth: true
                }

                // Optional Trend Badge (e.g. ↑ 8% or ↓ 5%)
                Rectangle {
                    visible: root.showTrend
                    implicitWidth: trendRow.implicitWidth + 20
                    implicitHeight: 34
                    radius: 17
                    border.color: root.isTrendUp ? "#d1fae5" : "#fee2e2"
                    border.width: 1
                    color: root.isTrendUp ? "#ecfdf5" : "#fef2f2"
                    Layout.alignment: Qt.AlignRight | Qt.AlignVCenter

                    RowLayout {
                        id: trendRow
                        anchors.centerIn: parent
                        spacing: 4

                        Text {
                            text: root.isTrendUp ? "↑" : "↓"
                            font.pixelSize: 15
                            font.weight: Font.Bold
                            color: root.isTrendUp ? "#10b981" : "#ef4444"
                        }

                        Text {
                            font.family: "Inter"
                            font.pixelSize: 15
                            font.weight: Font.DemiBold
                            color: root.isTrendUp ? "#10b981" : "#ef4444"
                            text: root.trendText
                        }
                    }
                }
            }

            // Accent Underline under amount/date
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 2
                color: root.accentLineColor
                opacity: 0.6
            }
        }
    }
}
