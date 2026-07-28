import QtQuick
import QtQuick.Layouts

Rectangle {
    id: sidebar_menu

    implicitWidth: 330
    width: implicitWidth
    Layout.preferredWidth: 330
    Layout.fillHeight: true
    color: "#ffffff"
    clip: true

    property int selectedIndex: 0
    signal pageChanged(int index)

    readonly property var menuItems: [0, 1, 2, 3, 4, 5, 6, 7]

    // Right border line separating sidebar from page content
    Rectangle {
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: 1
        color: "#e2e8f0"
        z: 2
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.topMargin: 20
        anchors.bottomMargin: 24
        spacing: 18

        // 1. App Header Logo
        Sidebar_menu_app_name_1 {
            id: appLogo
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: 290
            Layout.preferredHeight: 70
        }

        // Top Divider Line
        Rectangle {
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: 290
            height: 1
            color: "#e2e8f0"
        }

        // 2. Navigation Items List (290px wide, centered)
        ColumnLayout {
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: 290
            spacing: 10

            Repeater {
                model: sidebar_menu.menuItems

                Sidebar_item_1 {
                    _item: modelData
                    Layout.alignment: Qt.AlignHCenter
                    Layout.preferredWidth: 290
                    Layout.preferredHeight: 54

                    isSelected: sidebar_menu.selectedIndex === index

                    onClicked: {
                        sidebar_menu.selectedIndex = index
                        sidebar_menu.pageChanged(index)
                    }
                }
            }
        }

        // Flexible Bottom Spacer
        Item {
            Layout.fillHeight: true
        }

        // Bottom Divider Line
        Rectangle {
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: 290
            height: 1
            color: "#e2e8f0"
        }
    }
}