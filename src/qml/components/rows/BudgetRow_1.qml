import QtQuick
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

    signal editClicked()
    signal deleteClicked()

    implicitHeight: 64
    height: implicitHeight
    Layout.fillWidth: true

    border.color: "#f1f5f9"
    border.width: 1
    color: "#ffffff"

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 20
        anchors.rightMargin: 20
        spacing: 0

        // 1. BUDGET NAME
        Item {
            Layout.fillWidth: true
            Layout.preferredWidth: 200
            Layout.fillHeight: true

            Text {
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                color: "#0f172a"
                font.family: "Inter"
                font.pixelSize: 14
                font.weight: Font.Bold
                text: budgetRow.budgetName
                elide: Text.ElideRight
            }
        }

        // 2. PRIORITY BADGE
        Item {
            Layout.preferredWidth: 140
            Layout.fillHeight: true

            Priority_1 {
                anchors.left: parent.left
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
                anchors.rightMargin: 16
                anchors.verticalCenter: parent.verticalCenter
                spentText: budgetRow.spentText
                limitText: budgetRow.limitText
                progressFraction: budgetRow.progressFraction
                subText: budgetRow.progressSubText
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