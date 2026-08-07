import QtQuick
import src
import QtQuick.Layouts
import QtQuick.Effects

Rectangle {
    id: sidebar_menu

    implicitWidth: 330
    width: implicitWidth
    Layout.preferredWidth: 330
    Layout.fillHeight: true
    color: AppTheme.bgCard
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
        color: AppTheme.border
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
            color: AppTheme.border
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

        Rectangle {
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: 290
            height: 1
            color: AppTheme.border
        }

        // 3. user profile
        ColumnLayout {
            Layout.alignment: Qt.AlignBottom

            RowLayout {
                Layout.fillWidth: true
                // Layout.topMargin: 8
                // Layout.bottomMargin: 8
                Layout.leftMargin: 24
                spacing: 12

                Rectangle {
                    id: avatarCircle
                    width: 72
                    height: 72
                    radius: 36
                    color: settingsController.avatarColor
                    border.color: AppTheme.border
                    border.width: 1
                    clip: true

                    Image {
                        id: avatarImage
                        anchors.fill: parent
                        source: settingsController.avatarImagePath
                        visible: settingsController.avatarImagePath !== ""
                        fillMode: Image.PreserveAspectCrop
                    }

                    Text {
                        anchors.centerIn: parent
                        visible: settingsController.avatarImagePath === ""
                        text: settingsController.initials
                        color: AppTheme.bgCard
                        font.family: "Inter"
                        font.pixelSize: 30
                        font.weight: Font.Bold
                    }
                }

                ColumnLayout {
                    Text {
                        // anchors.topMargin: 0

                        text: settingsController.fullName

                        font.family: "Inter"
                        font.pixelSize: 20
                        font.weight: Font.Bold
                    }

                    Text {
                        text: settingsController.email

                        font.family: "Inter"
                        font.pixelSize: 16
                        font.weight: Font.Light
                    }
                }


            }

        }

        // Bottom Divider Line
        Rectangle {
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: 290
            height: 1
            color: AppTheme.border
        }
    }
}
