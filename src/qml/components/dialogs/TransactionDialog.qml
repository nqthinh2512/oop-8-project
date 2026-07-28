import QtQuick
import ".."


Item {
    id: root
    anchors.fill: parent
    visible: false
    z: 999

    signal accepted()
    signal rejected()

    function open() { visible = true }
    function close() { visible = false }

    // Dimmed background overlay
    Rectangle {
        anchors.fill: parent
        color: "#66000000"

        MouseArea {
            anchors.fill: parent
            onClicked: root.close()
        }
    }

    // Centered Dialog Card
    Rectangle {
        id: transactionDialog
        anchors.centerIn: parent

        height: 493
        width: 500

        color: "#ffffff"
        radius: 15
        clip: true

        // 1. Title Header
        Image {
            id: title
            source: Qt.resolvedUrl("../../assets/title_14.png")

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
                text: "Add Transaction"
                textFormat: Text.PlainText
                verticalAlignment: Text.AlignTop
                wrapMode: Text.Wrap
            }
        }

        // 2. Transaction Title Input
        Rectangle {
            id: titleInput
            y: 75
            height: 74
            width: 500
            color: "transparent"

            Text {
                id: transaction_Title
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
                text: "Transaction Title"
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

                TextInput {
                    id: textField
                    anchors.fill: parent
                    anchors.leftMargin: 15
                    anchors.rightMargin: 15
                    verticalAlignment: Text.AlignVCenter
                    color: "#191919"
                    font.family: "Roboto"
                    font.pixelSize: 16
                    font.weight: Font.Normal
                    clip: true
                    selectByMouse: true

                    Text {
                        text: "input text"
                        color: "#8049454f"
                        font: parent.font
                        visible: !parent.text && !parent.activeFocus
                        anchors.fill: parent
                        verticalAlignment: Text.AlignVCenter
                    }
                }
            }
        }

        // 3. Type, Categories, Amount & Account Row
        Rectangle {
            id: rowContainer
            y: 174
            height: 142
            width: 500
            color: "transparent"

            // Type Dropdown
            Rectangle {
                id: dropdown
                x: 20
                height: 66
                width: 225
                color: "transparent"

                Text {
                    id: type
                    height: 32
                    width: 226
                    color: "#878787"
                    font.family: "Intel One Mono"
                    font.pixelSize: 20
                    font.weight: Font.DemiBold
                    horizontalAlignment: Text.AlignLeft
                    lineHeight: 32
                    lineHeightMode: Text.FixedHeight
                    text: "Type"
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

            // Categories Dropdown
            Rectangle {
                id: dropdown_2
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
                    id: dropdown_3
                    y: 32
                    height: 34
                    width: 225
                    _state: Dropdown_1.State_1.State_1_default
                    clip: true
                }
            }

            // Amount Input
            Rectangle {
                id: dropdown_4
                x: 20
                y: 76
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

                    TextInput {
                        id: supporting_text
                        anchors.fill: parent
                        anchors.leftMargin: 15
                        anchors.rightMargin: 15
                        verticalAlignment: Text.AlignVCenter
                        color: "#191919"
                        font.family: "Roboto"
                        font.pixelSize: 16
                        font.weight: Font.Normal
                        clip: true
                        selectByMouse: true
                        inputMethodHints: Qt.ImhFormattedNumbersOnly

                        Text {
                            text: "input text"
                            color: "#8049454f"
                            font: parent.font
                            visible: !parent.text && !parent.activeFocus
                            anchors.fill: parent
                            verticalAlignment: Text.AlignVCenter
                        }
                    }
                }
            }

            // Account Input
            Rectangle {
                id: dropdown_5
                x: 255
                y: 76
                height: 66
                width: 225
                color: "transparent"

                Text {
                    id: account
                    height: 32
                    width: 226
                    color: "#878787"
                    font.family: "Intel One Mono"
                    font.pixelSize: 20
                    font.weight: Font.DemiBold
                    horizontalAlignment: Text.AlignLeft
                    lineHeight: 32
                    lineHeightMode: Text.FixedHeight
                    text: "Account"
                    textFormat: Text.PlainText
                    verticalAlignment: Text.AlignTop
                    wrapMode: Text.Wrap
                }

                Rectangle {
                    id: inputBox_2
                    y: 32
                    height: 34
                    width: 225
                    color: "#e9e9e9"
                    radius: 10

                    TextInput {
                        id: supporting_text_1
                        anchors.fill: parent
                        anchors.leftMargin: 15
                        anchors.rightMargin: 15
                        verticalAlignment: Text.AlignVCenter
                        color: "#191919"
                        font.family: "Roboto"
                        font.pixelSize: 16
                        font.weight: Font.Normal
                        clip: true
                        selectByMouse: true

                        Text {
                            text: "input text"
                            color: "#8049454f"
                            font: parent.font
                            visible: !parent.text && !parent.activeFocus
                            anchors.fill: parent
                            verticalAlignment: Text.AlignVCenter
                        }
                    }
                }
            }
        }

        // 4. Transaction Date Field
        Rectangle {
            id: dueDate
            y: 341
            height: 74
            width: 500
            color: "transparent"

            Text {
                id: transaction_Date
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
                text: "Transaction Date"
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

        // 5. Footer Action Buttons
        Image {
            id: choice
            y: 440
            source: Qt.resolvedUrl("../../assets/choice_5.png")

            UniversalButton_1 {
                id: cancelButton
                x: 305
                y: 9
                buttonText: "Cancel"
                height: 35
                width: 75
                _state: UniversalButton_1.State_1.State_1_default

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        root.rejected()
                        root.close()
                    }
                }
            }

            UniversalButton_1 {
                id: saveButton
                x: 405
                y: 9
                buttonText: "Add"
                height: 35
                width: 75
                _state: UniversalButton_1.State_1.State_1_selected

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        root.accepted()
                        root.close()
                    }
                }
            }
        }
    }
}