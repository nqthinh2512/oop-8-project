import QtQuick

Rectangle {
    id: text_Link

    property alias text_Link_1FontFamily: text_Link_1.font.family
    property alias text_Link_1FontPixelSize: text_Link_1.font.pixelSize
    property alias text_Link_1FontUnderline: text_Link_1.font.underline
    property alias text_Link_1Height: text_Link_1.height
    property alias text_Link_1LineHeight: text_Link_1.lineHeight
    property alias text_Link_1Width: text_Link_1.width

    property string _text: "Text Link"

    height: 22
    width: 68

    color: "transparent"

    Text {
        id: text_Link_1

        height: 22
        width: 69

        color: "#1e1e1e"
        font.family: "Inter"
        font.pixelSize: 16
        font.underline: true
        font.weight: Font.Normal
        horizontalAlignment: Text.AlignLeft
        lineHeight: 22.40
        lineHeightMode: Text.FixedHeight
        text: text_Link._text
        verticalAlignment: Text.AlignTop
    }
}