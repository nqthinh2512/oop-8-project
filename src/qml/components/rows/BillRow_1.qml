import QtQuick
import src
import QtQuick.Layouts
import QtQuick.Shapes

Rectangle {
    id: billRow

    enum Status { Status_paid, Status_overdue, Status_upcoming }

    property int status_1: BillRow_1.Status.Status_paid
    property string billName: "Name"
    property string amountText: "1,000 VND"
    property string categoryText: "Category"
    property string dueDateText: "31/12/2012"

    signal editClicked()
    signal deleteClicked()
    signal markPaidClicked()

    implicitHeight: 64
    height: implicitHeight
    Layout.fillWidth: true

    border.color: AppTheme.bgHover
    border.width: 1

    color: hoverHandler.hovered ? "#EEEEEE" : AppTheme.bgCard
    Behavior on color {
        ColorAnimation { duration: 150 }
    }

    HoverHandler {
        id: hoverHandler
        // cursorShape: Qt.PointingHandCursor
    }

    readonly property var statusConfig: {
        if (status_1 === BillRow_1.Status.Status_paid) {
            return { text: "Paid", color: "#16a34a", bg: AppTheme.isDark ? Qt.rgba(0.08, 0.64, 0.29, 0.2) : "#dcfce7", dateColor: AppTheme.textSub, icon: "✓" }
        } else if (status_1 === BillRow_1.Status.Status_overdue) {
            return { text: "Overdue", color: AppTheme.danger, bg: AppTheme.isDark ? Qt.rgba(0.97, 0.44, 0.44, 0.2) : "#fee2e2", dateColor: AppTheme.danger, icon: "!" }
        }
        return { text: "Upcoming", color: AppTheme.primary, bg: AppTheme.isDark ? Qt.rgba(0.37, 0.65, 0.98, 0.2) : "#dbeafe", dateColor: AppTheme.primary, icon: "🕒" }
    }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 20
        anchors.rightMargin: 20
        spacing: 0

        // 1. BILL NAME
        Item {
            Layout.fillWidth: true
            Layout.preferredWidth: 260
            Layout.fillHeight: true

            Text {
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                color: AppTheme.textMain
                font.family: "Inter"
                font.pixelSize: 14
                font.weight: Font.Bold
                text: billRow.billName
                elide: Text.ElideRight
                Layout.fillWidth: true
            }
        }

        // 2. AMOUNT
        Item {
            Layout.preferredWidth: 180
            Layout.fillHeight: true

            Text {
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                color: AppTheme.textMain
                font.family: "Intel One Mono"
                font.pixelSize: 15
                font.weight: Font.Bold
                text: billRow.amountText
                elide: Text.ElideRight
            }
        }

        // 3. CATEGORY
        Item {
            Layout.preferredWidth: 180
            Layout.fillHeight: true

            Text {
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                color: AppTheme.textSub
                font.family: "Inter"
                font.pixelSize: 14
                font.weight: Font.Medium
                text: billRow.categoryText
                elide: Text.ElideRight
            }
        }

        // 4. DUE DATE
        Item {
            Layout.preferredWidth: 180
            Layout.fillHeight: true

            Text {
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                color: billRow.statusConfig.dateColor
                font.family: "Intel One Mono"
                font.pixelSize: 14
                font.weight: Font.Bold
                text: billRow.dueDateText
                elide: Text.ElideRight
            }
        }

        // 5. STATUS BADGE
        Item {
            Layout.preferredWidth: 160
            Layout.fillHeight: true

            Rectangle {
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                implicitWidth: badgeRow.implicitWidth + 16
                implicitHeight: 24
                color: billRow.statusConfig.bg
                radius: 12

                RowLayout {
                    id: badgeRow
                    anchors.centerIn: parent
                    spacing: 4

                    Text {
                        text: billRow.statusConfig.icon
                        font.pixelSize: 11
                        font.weight: Font.Bold
                        color: billRow.statusConfig.color
                    }

                    Text {
                        font.family: "Inter"
                        font.pixelSize: 12
                        font.weight: Font.Bold
                        color: billRow.statusConfig.color
                        text: billRow.statusConfig.text
                    }
                }
            }
        }

        // 6. ACTIONS
        Item {
            Layout.preferredWidth: 100
            Layout.fillHeight: true

            RowLayout {
                anchors.right: parent.right
                anchors.rightMargin: 8
                anchors.verticalCenter: parent.verticalCenter
                spacing: 12

                Rectangle {
                    implicitWidth: 18
                    implicitHeight: 18
                    color: "transparent"
                    
                    Text {
                        anchors.centerIn: parent
                        text: "✓"
                        font.pixelSize: 16
                        font.weight: Font.Bold
                        color: "#16a34a"
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: billRow.markPaidClicked()
                    }
                }

                Edit_2 {
                    implicitWidth: 18
                    implicitHeight: 18
                    _state: Edit_2.State_1.State_1_default

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: billRow.editClicked()
                    }
                }

                Trash_1 {
                    implicitWidth: 18
                    implicitHeight: 18
                    _state: Trash_1.State_1.State_1_default

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: billRow.deleteClicked()
                    }
                }
            }
        }
    }
}
