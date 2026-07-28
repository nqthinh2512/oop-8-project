import QtQuick

Image {
    id: type_bill

    source: Qt.resolvedUrl("../assets/type_bill_1.png")

    Rectangle {
        id: item_details

        height: 40
        width: 146

        color: "transparent"
        visible: false

        Text {
            id: titleLabel

            height: 24
            width: 147

            color: "#191919"
            font.family: "Inter"
            font.pixelSize: 16
            font.weight: Font.DemiBold
            horizontalAlignment: Text.AlignLeft
            lineHeight: 24
            lineHeightMode: Text.FixedHeight
            text: "Name"
            textFormat: Text.PlainText
            verticalAlignment: Text.AlignTop
            wrapMode: Text.Wrap
        }
        Text {
            id: categoryLabel

            y: 24

            height: 16
            width: 54

            color: "#9f9f9f"
            font.family: "Inter"
            font.pixelSize: 12
            font.weight: Font.Normal
            horizontalAlignment: Text.AlignLeft
            lineHeight: 16
            lineHeightMode: Text.FixedHeight
            text: "Category"
            textFormat: Text.PlainText
            verticalAlignment: Text.AlignTop
        }
    }
    Rectangle {
        id: price

        x: 106.50

        height: 40
        width: 157

        color: "transparent"
        visible: false

        Text {
            id: amountLabel

            x: 94

            height: 24
            width: 64

            color: "#4a4a4a"
            font.family: "Inter"
            font.pixelSize: 16
            font.weight: Font.DemiBold
            horizontalAlignment: Text.AlignRight
            lineHeight: 24
            lineHeightMode: Text.FixedHeight
            text: "$money"
            textFormat: Text.PlainText
            verticalAlignment: Text.AlignTop
        }
        Text {
            id: dateLabel

            x: 129
            y: 24

            height: 16
            width: 29

            color: "#8c7653"
            font.family: "Inter"
            font.pixelSize: 12
            font.weight: Font.ExtraBold
            horizontalAlignment: Text.AlignLeft
            lineHeight: 16
            lineHeightMode: Text.FixedHeight
            text: "Date"
            textFormat: Text.PlainText
            verticalAlignment: Text.AlignTop
        }
    }
}