import QtQuick

Rectangle {
    id: billDialog

    height: 417
    width: 500

    color: "#ffffff"
    radius: 15

    Image {
        id: title

        source: Qt.resolvedUrl("../../assets/title_13.png")

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
            text: "Add Bill"
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
            id: bill_Title

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
            text: "Bill Title"
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
                id: amount

                height: 32
                width: 226

                color: "#878787"
                font.family: "Intel One Mono"
                font.pixelSize: 20
                font.weight: Font.DemiBold
                horizontalAlignment: Text.AlignLeft
                lineHeight: 32
                lineHeightMode: Text.FixedHeight
                text: "Amount"
                textFormat: Text.PlainText
                verticalAlignment: Text.AlignTop
                wrapMode: Text.Wrap
            }
            Rectangle {
                id: inputBox_1

                y: 32

                height: 34
                width: 225

                color: "#e9e9e9"
                radius: 10

                Text {
                    id: supporting_text

                    x: 20
                    y: 5

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
            id: dropdown_1

            x: 255

            height: 66
            width: 225

            color: "transparent"

            Text {
                id: categories

                height: 32
                width: 226

                color: "#878787"
                font.family: "Intel One Mono"
                font.pixelSize: 20
                font.weight: Font.DemiBold
                horizontalAlignment: Text.AlignLeft
                lineHeight: 32
                lineHeightMode: Text.FixedHeight
                text: "Categories"
                textFormat: Text.PlainText
                verticalAlignment: Text.AlignTop
                wrapMode: Text.Wrap
            }
            Dropdown_1 {
                id: dropdown_2

                y: 32

                height: 34
                width: 225

                _state: Dropdown_1.State_1.State_1_default
                clip: true
            }
        }
    }
    Rectangle {
        id: dueDate

        y: 265

        height: 74
        width: 500

        color: "transparent"

        Text {
            id: due_Date

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
            text: "Due Date"
            textFormat: Text.PlainText
            verticalAlignment: Text.AlignTop
            wrapMode: Text.Wrap
        }
        Date_Input_Field_1 {
            id: date_Input_Field

            x: 20
            y: 32

            height: 42
            width: 460
        }
    }
    Image {
        id: choice

        y: 364

        source: Qt.resolvedUrl("../../assets/choice_4.png")

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