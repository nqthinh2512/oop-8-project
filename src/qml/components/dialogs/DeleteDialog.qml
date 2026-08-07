import QtQuick
import QtQuick.Controls
import QtQuick.Controls.impl
import src
import ".."

Item {
    id: root
    anchors.fill: parent
    visible: false
    z: 999

    // --- Properties & Signals truyền dữ liệu ---
    property int targetId: -1
    property string itemName: ""

    // Alias để có thể chỉnh sửa tiêu đề/thông báo trực tiếp từ bên ngoài nếu cần
    property alias titleText: title_1.text
    property alias messageText: label_1.text

    signal accepted(int id)
    signal rejected()

    // --- Các hàm điều khiển ---
    function open() { visible = true }
    function close() { visible = false }

    // Mở dialog với thông tin đối tượng cụ thể cần xóa
    function openForDelete(id, name) {
        targetId = id
        itemName = name || ""

        if (itemName !== "") {
            label_1.text = "Are you really sure you want to delete \"" + itemName + "\"?"
        } else {
            label_1.text = "Are you really sure you want to delete this ?"
        }

        open()
    }

    // --- Dimmed background overlay ---
    Rectangle {
        anchors.fill: parent
        color: "#CC000000"

        MouseArea {
            anchors.fill: parent
            onClicked: {
                root.rejected()
                root.close()
            }
        }
    }

    // --- Centered Dialog Card ---
    Rectangle {
        id: deleteDialog
        anchors.centerIn: parent

        height: 217
        width: 500

        color: AppTheme.bgCard
        radius: 15
        clip: true

        // Absorb clicks inside the card so they don't reach the dimmed overlay
        MouseArea { anchors.fill: parent }

        // Header Title
        ColorImage {
        color: AppTheme.textMain
            id: title
            source: Qt.resolvedUrl("../../assets/title_15.png")

            Text {
                id: title_1
                x: 20
                y: 9
                height: 32
                width: 461
                color: AppTheme.textMain
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

        // Confirmation Message
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
                elide: Text.ElideRight
            }
        }

        // Action Buttons
        ColorImage {
        color: AppTheme.textMain
            id: choice
            y: 164
            source: Qt.resolvedUrl("../../assets/choice_6.png")

            UniversalButton_1 {
                id: cancelButton
                x: 307
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
                x: 407
                y: 9
                height: 35
                width: 73
                buttonText: "Delete"
                _state: UniversalButton_1.State_1.State_1_selected
                color: "#f85154"

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        root.accepted(root.targetId)
                        root.close()
                    }
                }
            }
        }
    }
}
