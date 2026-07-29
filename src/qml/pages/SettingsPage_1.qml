import QtQuick

Rectangle {
    id: settingsPage

    height: 1080
    width: 1522

    clip: true
    color: "#f5f7f9"

    Rectangle {
        id: settings

        height: 132
        width: 1522

        color: "transparent"

        Text {
            id: settings_1

            x: 33
            y: 32

            height: 44
            width: 1457

            color: "#000000"
            font.family: "Inter"
            font.pixelSize: 36
            font.weight: Font.Bold
            horizontalAlignment: Text.AlignLeft
            text: "Settings"
            textFormat: Text.PlainText
            verticalAlignment: Text.AlignTop
            wrapMode: Text.Wrap
        }
        Image {
            id: line_2

            x: 33
            y: 98

            source: Qt.resolvedUrl("../assets/line_7.png")
        }
    }
}