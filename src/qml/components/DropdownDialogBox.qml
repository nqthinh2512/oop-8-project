import QtQuick
import QtQuick.Controls

Rectangle {
    id: dropdownDialogBox

    // ===== Dynamic API =====
    property var model: []                    // String array: ["Option A", "Option B", ...]
    property int selectedIndex: -1            // Currently selected item index
    signal itemSelected(int index, string value)

    // Bounded height: dynamic up to 216px (approx 5-6 items), scrollable thereafter
    width: 240
    height: Math.min(listView.contentHeight + 16, 216)

    border.color: "#d1d5db"
    border.width: 1
    color: "#ffffff"
    radius: 8

    // Drop-shadow effect (subtle)
    Rectangle {
        anchors.fill: parent
        anchors.margins: -1
        radius: parent.radius + 1
        color: "#0a000000"
        z: -1
    }

    ListView {
        id: listView
        anchors.fill: parent
        anchors.topMargin: 8
        anchors.bottomMargin: 8
        clip: true
        model: dropdownDialogBox.model

        delegate: DropdownItem {
            width: listView.width
            height: 36
            clip: true

            // Set display text from model data — proportional to Dropdown_1 button
            placeholder_1Text: modelData
            placeholder_1FontPixelSize: 14
            placeholder_1Height: 20
            placeholder_1Width: width - 32
            placeholder_1X: 14
            placeholder_1Y: 8

            // Manage selection + hover state
            _state: {
                if (index === dropdownDialogBox.selectedIndex) {
                    return itemMouse.containsMouse
                        ? DropdownItem.State_1.State_1_hover_selected
                        : DropdownItem.State_1.State_1_selected
                } else {
                    return itemMouse.containsMouse
                        ? DropdownItem.State_1.State_1_hover
                        : DropdownItem.State_1.State_1_Default
                }
            }

            MouseArea {
                id: itemMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    dropdownDialogBox.selectedIndex = index
                    dropdownDialogBox.itemSelected(index, modelData)
                }
            }
        }


    }
}