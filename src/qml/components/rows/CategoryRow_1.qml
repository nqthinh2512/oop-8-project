import QtQuick
import QtQuick.Layouts
import QtQuick.Shapes

Rectangle {
    enum Status { Status_inactive, Status_active }

    id: categoryRow

    property string mainCategoryName: "Name"
    property string categoryName: "Category"
    property string totalAmountText: "1,000 VND"
    property int status_1: CategoryRow_1.Status.Status_active

    signal editClicked()
    signal deleteClicked()

    implicitHeight: 64
    height: implicitHeight
    Layout.fillWidth: true

    border.color: "#f1f5f9"
    border.width: 1
    color: "#ffffff"

    readonly property var statusConfig: {
        if (status_1 === CategoryRow_1.Status.Status_active) {
            return { text: "Active", color: "#16a34a", bg: "#dcfce7" }
        }
        return { text: "Inactive", color: "#dc2626", bg: "#fee2e2" }
    }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 20
        anchors.rightMargin: 20
        spacing: 0

        // 1. MAIN CATEGORY
        Item {
            Layout.fillWidth: true
            Layout.preferredWidth: 280
            Layout.fillHeight: true

            Text {
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                color: "#0f172a"
                font.family: "Inter"
                font.pixelSize: 14
                font.weight: Font.Bold
                text: categoryRow.mainCategoryName
                elide: Text.ElideRight
            }
        }

        // 2. CATEGORY NAME
        Item {
            Layout.fillWidth: true
            Layout.preferredWidth: 260
            Layout.fillHeight: true

            Text {
                width: parent.width
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                color: "#475569"
                font.family: "Inter"
                font.pixelSize: 14
                font.weight: Font.Medium
                text: categoryRow.categoryName
                elide: Text.ElideRight
            }
        }

        // 3. TOTAL MONEY BY CATEGORY
        Item {
            Layout.fillWidth: true
            Layout.preferredWidth: 280
            Layout.fillHeight: true

            Text {
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                color: "#0f172a"
                font.family: "Intel One Mono"
                font.pixelSize: 15
                font.weight: Font.Bold
                text: categoryRow.totalAmountText
                elide: Text.ElideRight
            }
        }

        // 4. STATUS BADGE
        Item {
            Layout.preferredWidth: 160
            Layout.fillHeight: true

            Rectangle {
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                implicitWidth: badgeText.implicitWidth + 20
                implicitHeight: 24
                color: categoryRow.statusConfig.bg
                radius: 12

                Text {
                    id: badgeText
                    anchors.centerIn: parent
                    font.family: "Inter"
                    font.pixelSize: 12
                    font.weight: Font.Bold
                    color: categoryRow.statusConfig.color
                    text: categoryRow.statusConfig.text
                }
            }
        }

        // 5. ACTIONS
        Item {
            Layout.preferredWidth: 100
            Layout.fillHeight: true

            RowLayout {
                anchors.right: parent.right
                anchors.rightMargin: 8
                anchors.verticalCenter: parent.verticalCenter
                spacing: 12

                Edit_2 {
                    implicitWidth: 18
                    implicitHeight: 18
                    _state: Edit_2.State_1.State_1_default

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: categoryRow.editClicked()
                    }
                }

                Trash_1 {
                    implicitWidth: 18
                    implicitHeight: 18
                    _state: Trash_1.State_1.State_1_default

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: categoryRow.deleteClicked()
                    }
                }
            }
        }
    }
}