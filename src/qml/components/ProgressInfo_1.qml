import QtQuick
import src
import QtQuick.Layouts

Item {
    id: root

    property string spentText: "1,000 VND"
    property string limitText: "/ 20,000 VND"
    property real progressFraction: 0.67
    property string subText: "67% saved"
    property color progressColor: AppTheme.primary

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
                color: AppTheme.textMain
                text: root.spentText
            }

            Text {
                font.family: "Intel One Mono"
                font.pixelSize: 12
                color: AppTheme.textSub
                text: root.limitText
                Layout.fillWidth: true
            }
        }

        // Middle Row: Progress Bar Track
        Rectangle {
            id: fillBarBackground

            Layout.fillWidth: true
            implicitHeight: 6
            radius: 3
            color: AppTheme.border

            Rectangle {
                id: fillBar

                height: parent.height
                radius: 3
                color: root.progressColor

                readonly property real targetWidth: parent.width * Math.min(Math.max(root.progressFraction, 0), 1)

                NumberAnimation on width {
                    id: fillAnimation
                    from: 0
                    to: fillBar.targetWidth
                    duration: 600
                    easing.type: Easing.OutCubic
                    running: false
                }

                Component.onCompleted: fillAnimation.restart()

                onVisibleChanged: {
                    if (visible) {
                        fillAnimation.restart()
                    }
                }
            }
        }

        // Bottom Row: SubText (67% saved)
        Text {
            font.family: "Intel One Mono"
            font.pixelSize: 11
            color: AppTheme.textMuted
            text: root.subText
            Layout.alignment: Qt.AlignHCenter
        }
    }
}
