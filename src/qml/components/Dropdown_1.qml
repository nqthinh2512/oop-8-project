import QtQuick
import QtQuick.Layouts
import QtQuick.Shapes

Rectangle {
    enum State_1 { State_1_default, State_1_hover }

    id: dropdown

    // ===== Exposed API Properties =====
    property int _state: Dropdown_1.State_1.State_1_default
    property string selectedText: "Select Choice"
    property int selectedIndex: 0
    property var model: []
    property alias dropdownBorderWidth: dropdown.border.width
    property bool menuOpen: false

    // ===== Signals =====
    signal selected(int index, string value)
    signal clicked()

    implicitWidth: 200
    implicitHeight: 38
    width: implicitWidth
    height: implicitHeight

    color: "#ffffff"
    radius: 8
    border.color: menuOpen || dropdown._state === Dropdown_1.State_1.State_1_hover ? "#3b82f6" : "#d1d5db"
    border.width: 1

    // ===== Button Label + Chevron Icon =====
    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 14
        anchors.rightMargin: 14
        spacing: 8

        Text {
            id: label
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter

            font.family: "Inter"
            font.pixelSize: 14
            font.weight: Font.Medium
            color: menuOpen || dropdown._state === Dropdown_1.State_1.State_1_hover ? "#2563eb" : "#4b5563"
            text: dropdown.selectedText
            elide: Text.ElideRight
        }

        // Chevron Down/Up Icon
        Item {
            Layout.preferredWidth: 12
            Layout.preferredHeight: 8
            Layout.alignment: Qt.AlignVCenter

            Shape {
                anchors.centerIn: parent
                width: 10
                height: 6

                ShapePath {
                    fillColor: "#00000000"
                    strokeColor: menuOpen || dropdown._state === Dropdown_1.State_1.State_1_hover ? "#2563eb" : "#64748b"
                    strokeWidth: 1.8

                    PathSvg {
                        path: menuOpen ? "M 0 5 L 5 0 L 10 5" : "M 0 0 L 5 5 L 10 0"
                    }
                }
            }
        }
    }

    // ===== Click Handler: Toggle menu open/close =====
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onEntered: dropdown._state = Dropdown_1.State_1.State_1_hover
        onExited: dropdown._state = Dropdown_1.State_1.State_1_default
        onClicked: {
            dropdown.clicked()
            if (dropdown.model && dropdown.model.length > 0) {
                dropdown.menuOpen = !dropdown.menuOpen
            }
        }
    }

    // ===================================================================
    // OVERLAY + MENU: Both parented to Window.contentItem so they float
    // above ALL containers, dialogs, and z-layers in the application.
    // This avoids clipping, z-order, and hit-testing issues entirely.
    // ===================================================================

    // Fullscreen click-outside overlay
    MouseArea {
        id: clickOutsideOverlay
        parent: Window.window ? Window.window.contentItem : dropdown
        visible: dropdown.menuOpen
        x: 0
        y: 0
        width: parent ? parent.width : 0
        height: parent ? parent.height : 0
        z: 99998

        onClicked: dropdown.menuOpen = false
    }

    // Dropdown Menu (positioned below the button in window coordinates)
    DropdownDialogBox {
        id: menuBox
        parent: Window.window ? Window.window.contentItem : dropdown
        visible: dropdown.menuOpen
        z: 99999
        width: dropdown.width

        // Recalculate position each time menu opens (menuOpen triggers binding re-evaluation)
        x: dropdown.menuOpen ? dropdown.mapToItem(parent, 0, 0).x : 0
        y: dropdown.menuOpen ? dropdown.mapToItem(parent, 0, dropdown.height + 4).y : 0

        model: dropdown.model
        selectedIndex: dropdown.selectedIndex

        onItemSelected: (index, value) => {
            dropdown.selectedIndex = index
            dropdown.selectedText = value
            dropdown.menuOpen = false
            dropdown.selected(index, value)
        }
    }
}