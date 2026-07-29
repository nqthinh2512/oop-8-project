import QtQuick

Rectangle {
    id: compareBar

    height: 180
    width: 52

    color: "transparent"
    visible: false

    Rectangle {
        id: bar

        x: 6

        height: 150
        width: 40

        color: "transparent"

        Rectangle {
            id: expense

            y: 43

            height: 107
            width: 16

            color: "#ff8e90"
            topLeftRadius: 4
            topRightRadius: 4
        }
        Rectangle {
            id: income

            x: 24

            height: 150
            width: 16

            color: "#299d91"
            topLeftRadius: 4
            topRightRadius: 4
        }
    }
    Text {
        id: _date

        y: 160

        height: 20
        width: 53

        color: "#9f9f9f"
        font.family: "Inter"
        font.pixelSize: 14
        font.weight: Font.Normal
        horizontalAlignment: Text.AlignHCenter
        lineHeight: 20
        lineHeightMode: Text.FixedHeight
        text: "17 Sun"
        textFormat: Text.PlainText
        verticalAlignment: Text.AlignTop
        wrapMode: Text.Wrap
    }
}