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
        id: budgetDialog
        anchors.centerIn: parent

        height: 683
        width: 500

        color: "#ffffff"
        radius: 15
        clip: true

        // 1. Title Header
        Image {
            id: title
            source: Qt.resolvedUrl("../../assets/title_9.png")

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
                text: "Add Budget"
                textFormat: Text.PlainText
                verticalAlignment: Text.AlignTop
                wrapMode: Text.Wrap
            }
        }

        // 2. Budget Title Field
        Rectangle {
            id: titleInput
            y: 75
            height: 74
            width: 500
            color: "transparent"

            Text {
                id: budget_Title
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
                text: "Budget Title"
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

        // 3. Priority, Categories, Amount Spent & Budget Limit Grid Row
        Rectangle {
            id: rowContainer
            y: 174
            height: 142
            width: 500
            color: "transparent"

            // Priority Dropdown
            Rectangle {
                id: dropdown
                x: 20
                height: 66
                width: 225
                color: "transparent"

                Text {
                    id: priority
                    height: 32
                    width: 226
                    color: "#878787"
                    font.family: "Intel One Mono"
                    font.pixelSize: 20
                    font.weight: Font.DemiBold
                    horizontalAlignment: Text.AlignLeft
                    lineHeight: 32
                    lineHeightMode: Text.FixedHeight
                    text: "Priority"
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

            // Amount Spent Input
            Rectangle {
                id: dropdown_4
                x: 20
                y: 76
                height: 66
                width: 225
                color: "transparent"

                Text {
                    id: amount_Spent
                    height: 32
                    width: 226
                    color: "#878787"
                    font.family: "Intel One Mono"
                    font.pixelSize: 20
                    font.weight: Font.DemiBold
                    horizontalAlignment: Text.AlignLeft
                    lineHeight: 32
                    lineHeightMode: Text.FixedHeight
                    text: "Amount Spent"
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

            // Budget Limit Input
            Rectangle {
                id: dropdown_5
                x: 255
                y: 76
                height: 66
                width: 225
                color: "transparent"

                Text {
                    id: budget_Limit
                    height: 32
                    width: 226
                    color: "#878787"
                    font.family: "Intel One Mono"
                    font.pixelSize: 20
                    font.weight: Font.DemiBold
                    horizontalAlignment: Text.AlignLeft
                    lineHeight: 32
                    lineHeightMode: Text.FixedHeight
                    text: "Budget Limit"
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
        }

        // 4. Start Date Field
        Rectangle {
            id: startDate
            y: 341
            height: 74
            width: 500
            color: "transparent"

            Text {
                id: start_Date
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
                text: "Start Date"
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

        // 5. Due Date Field
        Rectangle {
            id: dueDate
            y: 440
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
                id: date_Input_Field_1
                x: 20
                y: 32
                height: 42
                width: 460
            }
        }

        // 6. Period Field
        Rectangle {
            id: dropdown_6
            y: 539
            height: 66
            width: 500
            color: "transparent"

            Text {
                id: period
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
                text: "Period"
                textFormat: Text.PlainText
                verticalAlignment: Text.AlignTop
                wrapMode: Text.Wrap
            }

            Dropdown_1 {
                id: dropdown_7
                x: 20
                y: 32
                height: 34
                width: 460
                _state: Dropdown_1.State_1.State_1_default
                clip: true
            }
        }

        // 7. Footer Action Buttons
        Image {
            id: choice
            y: 630
            source: Qt.resolvedUrl("../../assets/choice.png")

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