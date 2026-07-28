import QtQuick

Rectangle {
    id: categoryDialog

    height: 318
    width: 500

    color: "#ffffff"
    radius: 15

    Image {
        id: title

        source: Qt.resolvedUrl("../../assets/title_12.png")

        Text {
            id: title_1

            x: 20
            y: 9

            height: 32
            width: 461

            color: "#191919"
            font.capitalization: Font.Capitalize
            font.family: "Intel One Mono"
            font.pixelSize: 24
            font.weight: Font.DemiBold
            horizontalAlignment: Text.AlignLeft
            lineHeight: 32
            lineHeightMode: Text.FixedHeight
            text: "Add Category"
            textFormat: Text.PlainText
            verticalAlignment: Text.AlignTop
            wrapMode: Text.Wrap
        }
    }
    Rectangle {
        id: titleInput

        y: 75

        height: 74
        width: 500

        color: "transparent"

        Text {
            id: category_Title

            x: 20

            height: 32
            width: 461

            color: "#878787"
            font.family: "Intel One Mono"
            font.pixelSize: 20
            font.weight: Font.DemiBold
            horizontalAlignment: Text.AlignLeft
            lineHeight: 32
            lineHeightMode: Text.FixedHeight
            text: "Category Title"
            textFormat: Text.PlainText
            verticalAlignment: Text.AlignTop
            wrapMode: Text.Wrap
        }
        Rectangle {
            id: inputBox

            x: 20
            y: 32

            height: 42
            width: 460

            color: "#e9e9e9"
            radius: 10

            Text {
                id: textField

                x: 20
                y: 9

                height: 24
                width: 68

                color: "#8049454f"
                font.family: "Roboto"
                font.pixelSize: 16
                font.weight: Font.Normal
                horizontalAlignment: Text.AlignLeft
                lineHeight: 24
                lineHeightMode: Text.FixedHeight
                text: "input text"
                textFormat: Text.PlainText
                verticalAlignment: Text.AlignVCenter
            }
        }
    }
    Rectangle {
        id: rowContainer

        y: 174

        height: 66
        width: 500

        color: "transparent"

        Rectangle {
            id: dropdown

            x: 20

            height: 66
            width: 225

            color: "transparent"

            Text {
                id: page

                height: 32
                width: 226

                color: "#878787"
                font.family: "Intel One Mono"
                font.pixelSize: 20
                font.weight: Font.DemiBold
                horizontalAlignment: Text.AlignLeft
                lineHeight: 32
                lineHeightMode: Text.FixedHeight
                text: "Page"
                textFormat: Text.PlainText
                verticalAlignment: Text.AlignTop
                wrapMode: Text.Wrap
            }
            Dropdown_1 {
                id: dropdown_1

                y: 32

                height: 34
                width: 225

                _state: Dropdown_1.State_1.State_1_default
                clip: true
            }
        }
        Rectangle {
            id: dropdown_2

            x: 255

            height: 66
            width: 225

            color: "transparent"

            Text {
                id: status

                height: 32
                width: 226

                color: "#878787"
                font.family: "Intel One Mono"
                font.pixelSize: 20
                font.weight: Font.DemiBold
                horizontalAlignment: Text.AlignLeft
                lineHeight: 32
                lineHeightMode: Text.FixedHeight
                text: "Status"
                textFormat: Text.PlainText
                verticalAlignment: Text.AlignTop
                wrapMode: Text.Wrap
            }
            Dropdown_1 {
                id: dropdown_3

                y: 32

                height: 34
                width: 225

                _state: Dropdown_1.State_1.State_1_default
                clip: true
            }
        }
    }
    Image {
        id: choice

        y: 265

        source: Qt.resolvedUrl("../../assets/choice_3.png")

        UniversalButton_1 {
            id: cancelButton

            x: 305
            y: 9

            height: 35
            width: 75

            _state: UniversalButton_1.State_1.State_1_default
        }
        UniversalButton_1 {
            id: saveButton

            x: 405
            y: 9

            height: 35
            width: 75

            _state: UniversalButton_1.State_1.State_1_selected
        }
    }
}