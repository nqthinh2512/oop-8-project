import QtQuick

Rectangle {
    id: calendar_Month_Field

    property alias chevron_downX: chevron_down.x
    property alias optionsSource: options.source
    property alias selectWidth: select.width
    property alias septemberWidth: september.width

    property bool has_Label: false
    property string label: "Label"
    property bool open: false
    property string value: "September"

    height: 28
    width: 240

    color: "transparent"

    Text {
        id: label_1

        height: 22
        width: 241

        color: "#1e1e1e"
        font.family: "Inter"
        font.pixelSize: 16
        font.weight: Font.Normal
        horizontalAlignment: Text.AlignLeft
        lineHeight: 22.40
        lineHeightMode: Text.FixedHeight
        text: calendar_Month_Field.label
        verticalAlignment: Text.AlignTop
        visible: calendar_Month_Field.has_Label
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
            id: september

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
            text: calendar_Month_Field.value
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

            source: Qt.resolvedUrl("../assets/options_3.png")
            visible: calendar_Month_Field.open
        }
    }
}