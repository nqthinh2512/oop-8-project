import QtQuick

Rectangle {
    id: calendar_Year_Field

    property alias chevron_downX: chevron_down.x
    property alias elementWidth: element.width
    property alias selectWidth: select.width

    property string value: "2025"

    height: 28
    width: 240

    color: "transparent"

    Text {
        id: label

        height: 22
        width: 241

        color: "#1e1e1e"
        font.family: "Inter"
        font.pixelSize: 16
        font.weight: Font.Normal
        horizontalAlignment: Text.AlignLeft
        lineHeight: 22.40
        lineHeightMode: Text.FixedHeight
        text: "Label"
        textFormat: Text.PlainText
        verticalAlignment: Text.AlignTop
        visible: false
        wrapMode: Text.Wrap
    }
    Rectangle {
        id: select

        height: 28
        width: 240

        border.color: "#d9d9d9"
        border.width: 1
        color: "#ffffff"
        radius: 8

        Text {
            id: element

            x: 6
            y: 6

            height: 16
            width: 205

            color: "#1e1e1e"
            font.family: "Inter"
            font.pixelSize: 16
            font.weight: Font.Normal
            horizontalAlignment: Text.AlignLeft
            lineHeight: 16
            lineHeightMode: Text.FixedHeight
            text: calendar_Year_Field.value
            verticalAlignment: Text.AlignTop
            wrapMode: Text.Wrap
        }
        Chevron_down {
            id: chevron_down

            x: 218
            y: 6

            clip: true
        }
        Image {
            id: options

            x: 8
            y: 8

            source: Qt.resolvedUrl("../assets/options.png")
            visible: false
        }
    }
}