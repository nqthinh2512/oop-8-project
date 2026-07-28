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
        id: deleteCategoryDialog
        anchors.centerIn: parent

        height: 251
        width: 500

        color: "#ffffff"
        radius: 15
        clip: true

        // 1. Header Title
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

        // 2. Category Migration Dropdown Field
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

        // 3. Footer Action Buttons
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
                buttonText: "Cancel"
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
                x: 339
                y: 9
                height: 35
                width: 141
                buttonText: "Move & Delete"
                _state: UniversalButton_1.State_1.State_1_selected
                color: "#f85154"

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