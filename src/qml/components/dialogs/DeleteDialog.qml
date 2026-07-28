import QtQuick

Rectangle {
    id: deleteDialog

    height: 217
    width: 500

    color: "#ffffff"
    radius: 15

    Image {
        id: title

        source: Qt.resolvedUrl("../../assets/title_15.png")

        Text {
            id: title_1

            x: 20
            y: 9

            height: 32
            width: 461

            color: "#191919"
            font.family: "Intel One Mono"
            font.pixelSize: 24
            font.weight: Font.DemiBold
            horizontalAlignment: Text.AlignLeft
            lineHeight: 32
            lineHeightMode: Text.FixedHeight
            text: "Deleting"
            textFormat: Text.PlainText
            verticalAlignment: Text.AlignTop
            wrapMode: Text.Wrap
        }
    }
    Rectangle {
        id: label

        y: 75

        height: 64
        width: 500

        color: "transparent"

        Text {
            id: label_1

            x: 20

            height: 64
            width: 461

            color: "#878787"
            font.family: "Intel One Mono"
            font.pixelSize: 18
            font.weight: Font.DemiBold
            horizontalAlignment: Text.AlignLeft
            lineHeight: 32
            lineHeightMode: Text.FixedHeight
            text: "Are you really sure you want to delete this ?"
            textFormat: Text.PlainText
            verticalAlignment: Text.AlignTop
            wrapMode: Text.Wrap
        }
    }
    Image {
        id: choice

        y: 164

        source: Qt.resolvedUrl("../../assets/choice_6.png")

        UniversalButton_1 {
            id: cancelButton

            x: 307
            y: 9

            height: 35
            width: 75

            _state: UniversalButton_1.State_1.State_1_default
        }
        UniversalButton_1 {
            id: saveButton

            x: 407
            y: 9

            height: 35
            width: 73

            _state: UniversalButton_1.State_1.State_1_selected
            color: "#f85154"
        }
    }
}