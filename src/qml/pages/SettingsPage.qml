import QtQuick

Rectangle {
    id: settingsPage

    height: 1117
    width: 1728

    clip: true
    color: "#f5f7f9"

    Rectangle {
        id: settings

        height: 140
        width: 1337

        color: "transparent"

        Text {
            id: settings_1

            y: 40

            height: 44
            width: 1338

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

            y: 98

            source: Qt.resolvedUrl("../assets/line_6.png")
        }
    }
}