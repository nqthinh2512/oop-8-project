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

    // Exposed Animation function
    function triggerLineAnimation() {
        accentLine.triggerAnimation()
    }

    signal viewAllClicked()

    spacing: 8
    Layout.fillWidth: true

    // 1. Header (Title + Optional View All Link)
    RowLayout {
        Layout.fillWidth: true
        Layout.preferredHeight: 28

        Text {
            font.family: "Inter"
            font.pixelSize: 18
            font.weight: Font.DemiBold
            color: AppTheme.textSub
            text: root.cardTitle
            Layout.fillWidth: true
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
        }

        View_all_1 {
            visible: root.showViewAll
            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
            onClicked: root.viewAllClicked()
        }
    }

    // 2. White / Dark Card Box
    Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: 90
        color: AppTheme.bgCard
        radius: 12
        border.color: AppTheme.bgHover
        border.width: 1
        clip: true

        ColumnLayout {
            anchors.fill: parent
            anchors.leftMargin: 20
            anchors.rightMargin: 20
            anchors.topMargin: 14
            anchors.bottomMargin: 12
            spacing: 10

            RowLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 8

                // Amount Text
                Text {
                    font.family: "Inter"
                    font.pixelSize: 21
                    font.weight: Font.Bold
                    color: AppTheme.textMain
                    text: root.amountText
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                    Layout.fillWidth: true
                    Layout.minimumWidth: 60
                }

                // Date Text
            //    Text {
            //        font.family: "Inter"
            //        font.pixelSize: 12
            //        font.weight: Font.Medium
            //        color: AppTheme.textMuted
            //        text: root.dateText
            //        verticalAlignment: Text.AlignVCenter
            //        Layout.alignment: Qt.AlignVCenter
            //    }

                // Optional Trend Badge (e.g. ↑ 8% or ↓ 5%)
                Rectangle {
                    visible: root.showTrend
                    implicitWidth: trendRow.implicitWidth + 16
                    implicitHeight: 28
                    radius: 14
                    border.color: root.isTrendUp 
                        ? (AppTheme.isDark ? Qt.rgba(0.08, 0.64, 0.29, 0.4) : "#d1fae5") 
                        : (AppTheme.isDark ? Qt.rgba(0.97, 0.44, 0.44, 0.4) : "#fee2e2")
                    border.width: 1
                    color: root.isTrendUp 
                        ? (AppTheme.isDark ? Qt.rgba(0.08, 0.64, 0.29, 0.2) : "#ecfdf5") 
                        : (AppTheme.isDark ? Qt.rgba(0.97, 0.44, 0.44, 0.2) : "#fef2f2")
                    Layout.alignment: Qt.AlignRight | Qt.AlignVCenter

                    RowLayout {
                        id: trendRow
                        anchors.centerIn: parent
                        spacing: 4

                        Text {
                            text: root.isTrendUp ? "↑" : "↓"
                            font.pixelSize: 13
                            font.weight: Font.Bold
                            color: root.isTrendUp ? "#10b981" : "#ef4444"
                        }

                        Text {
                            font.family: "Inter"
                            font.pixelSize: 13
                            font.weight: Font.DemiBold
                            color: root.isTrendUp ? "#10b981" : "#ef4444"
                            text: root.trendText
                        }
                    }
                }

                Layout.bottomMargin: -12
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

            Canvas {
                id: accentLine
                Layout.fillWidth: true
                Layout.preferredHeight: 3
                opacity: 0.8

                property real progress: 0.0

                onProgressChanged: requestPaint()

                function triggerAnimation() {
                    fillAnimation.stop();
                    progress = 0.0;
                    fillAnimation.start();
                }

                NumberAnimation {
                    id: fillAnimation
                    target: accentLine
                    property: "progress"
                    from: 0.0
                    to: 1.0
                    duration: 800
                    easing.type: Easing.OutCubic
                    running: true
                }

                onPaint: {
                    var ctx = getContext("2d");
                    ctx.reset();

                    var currentWidth = width * progress;
                    if (currentWidth <= 0) return;

                    var r = 1.5; // Original radius
                    var h = height;

                    ctx.fillStyle = root.accentLineColor;
                    ctx.beginPath();

                    ctx.roundedRect(0, 0, currentWidth, h, r, r);

                    ctx.fill();
                }
            }
        }
    }


}
