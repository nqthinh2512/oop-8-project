import QtQuick

Rectangle {
    id: deleteCategoryDialog

    height: 251
    width: 500

    color: "#ffffff"
    radius: 15

    Image {
        id: title

        source: Qt.resolvedUrl("../../assets/title_10.png")

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
            text: "“Deleting” category"
            textFormat: Text.PlainText
            verticalAlignment: Text.AlignTop
            wrapMode: Text.Wrap
        }
    }
    Rectangle {
        id: dropdown

        y: 75

        height: 98
        width: 500

        color: "transparent"

        Text {
            id: label

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
            text: "Choose the category of [page] you wish to move this category to:"
            textFormat: Text.PlainText
            verticalAlignment: Text.AlignTop
            wrapMode: Text.Wrap
        }
        Dropdown_1 {
            id: dropdown_1

            x: 20
            y: 64

            height: 34
            width: 460

            _state: Dropdown_1.State_1.State_1_default
            clip: true
        }
    }
    Image {
        id: choice

        y: 198

        source: Qt.resolvedUrl("../../assets/choice_1.png")

        UniversalButton_1 {
            id: cancelButton

            x: 239
            y: 9

            height: 35
            width: 75

            _state: UniversalButton_1.State_1.State_1_default
        }
        UniversalButton_1 {
            id: saveButton

            x: 339
            y: 9

            height: 35
            width: 141

            _state: UniversalButton_1.State_1.State_1_selected
            color: "#f85154"
        }
    }
}