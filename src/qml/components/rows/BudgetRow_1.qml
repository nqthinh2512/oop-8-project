import QtQuick
import src
import QtQuick.Layouts
import QtQuick.Shapes

Rectangle {
    id: budgetRow

    property string budgetName: "Name"
    property int priorityVal: Priority_1.Priority_1.Priority_1_medium
    property string categoryText: "Category"
    property string spentText: "1,000 VND"
    property string limitText: "/ 20,000 VND"
    property real progressFraction: 0.67
    property string progressSubText: "67% saved"
    property string startDate: "31/12/2012"
    property string endDate: "31/12/2013"
    property int periodVal: DateCycle_1.Period.Period_yearly
    property int statusVal: 0

    signal editClicked()
    signal deleteClicked()

    implicitHeight: 64
    height: implicitHeight
    Layout.fillWidth: true

    border.color: AppTheme.bgHover
    border.width: 1
    color: AppTheme.bgCard

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 20
        anchors.rightMargin: 20
        spacing: 0

        // 1. BUDGET NAME
        Item {
            Layout.fillWidth: true
            Layout.preferredWidth: 260
            Layout.fillHeight: true

            Text {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.rightMargin: 8
                anchors.verticalCenter: parent.verticalCenter
                color: AppTheme.textMain
                font.family: "Inter"
                font.pixelSize: 14
                font.weight: Font.Bold
                text: budgetRow.budgetName
                elide: Text.ElideRight
            }
        }
        // 2. PRIORITY BADGE
        Item {
            Layout.preferredWidth: 100
            Layout.fillHeight: true

            Priority_1 {
                anchors.left: parent.left
                anchors.leftMargin: 12
                anchors.verticalCenter: parent.verticalCenter
                priority_2: budgetRow.priorityVal
            }
        }

        // 3. CATEGORY
        Item {
            Layout.preferredWidth: 160
            Layout.fillHeight: true

            Text {
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                color: "#475569"
                font.family: "Inter"
                font.pixelSize: 14
                font.weight: Font.Medium
                text: budgetRow.categoryText
                elide: Text.ElideRight
            }
        }

        // 4. PROGRESS
        Item {
            Layout.preferredWidth: 280
            Layout.fillHeight: true

            ProgressInfo_1 {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.rightMargin: 30
                anchors.verticalCenter: parent.verticalCenter
                spentText: budgetRow.spentText
                limitText: budgetRow.limitText
                progressFraction: budgetRow.progressFraction
                subText: budgetRow.progressSubText
                progressColor: {
                    if (budgetRow.statusVal === 0) return "#10b981"; // Safe - Green
                    if (budgetRow.statusVal === 1) return "#eab308"; // Warning - Yellow
                    if (budgetRow.statusVal === 2) return "#f97316"; // Danger - Orange
                    if (budgetRow.statusVal === 3) return "#ef4444"; // Over - Red
                    return "#3b82f6"; // Default Blue
                }
            }
        }

        // 5. DATE & CYCLE
        Item {
            Layout.preferredWidth: 240
            Layout.fillHeight: true

            DateCycle_1 {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.rightMargin: 16
                anchors.verticalCenter: parent.verticalCenter
                startDate: budgetRow.startDate
                endDate: budgetRow.endDate
                period_1: budgetRow.periodVal
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

                Edit_2 {
                    implicitWidth: 18
                    implicitHeight: 18
                    _state: Edit_2.State_1.State_1_default

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: budgetRow.editClicked()
                    }
                }

                Trash_1 {
                    implicitWidth: 18
                    implicitHeight: 18
                    _state: Trash_1.State_1.State_1_default

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: budgetRow.deleteClicked()
                    }
                }
            }
        }
    }
}
