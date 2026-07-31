import QtQuick
import QtQuick.Layouts
import QtQuick.Shapes

Rectangle {
    enum Type { Type_income, Type_expense, Type_transfer }

    id: transactionRow

    implicitHeight: 64
    height: implicitHeight
    Layout.fillWidth: true

    border.color: "#f1f5f9"
    border.width: 1
    color: "#ffffff"

    // Exposed Data Properties
    property int type_1: TransactionRow_1.Type.Type_expense
    property string transactionName: "Name"
    property string amountText: "$ 35"
    property string categoryText: "Category"
    property string methodText: "Method"
    property string dateText: "16/09/2024"

    // Action Signals
    signal editClicked()
    signal trashClicked()

    // Internal Type Configs matching Figma
    readonly property var typeConfig: {
        if (type_1 === TransactionRow_1.Type.Type_income) {
            return {
                label: "Income",
                color: "#16a34a",
                bg: "#dcfce7",
                arrow: "↙",
                circleBg: "#dcfce7"
            }
        } else if (type_1 === TransactionRow_1.Type.Type_transfer) {
            return {
                label: "Transfer",
                color: "#ca8a04",
                bg: "#fef9c3",
                arrow: "↗",
                circleBg: "#fef9c3"
            }
        }
        return {
            label: "Expense",
            color: "#dc2626",
            bg: "#fee2e2",
            arrow: "↗",
            circleBg: "#fee2e2"
        }
    }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 20
        anchors.rightMargin: 20
        spacing: 0

        // 1. TRANSACTION NAME & BADGE
        Item {
            Layout.fillWidth: true
            Layout.preferredWidth: 320
            Layout.fillHeight: true

            RowLayout {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                spacing: 12

                // Circle Icon Indicator
                Rectangle {
                    width: 32
                    height: 32
                    radius: 16
                    color: transactionRow.typeConfig.circleBg
                    Layout.alignment: Qt.AlignVCenter

                    Text {
                        anchors.centerIn: parent
                        text: transactionRow.typeConfig.arrow
                        font.pixelSize: 14
                        font.weight: Font.Bold
                        color: transactionRow.typeConfig.color
                    }
                }

                // Title & Subtitle Badge Column
                ColumnLayout {
                    spacing: 3
                    Layout.alignment: Qt.AlignVCenter
                    Layout.fillWidth: true

                    Text {
                        color: "#0f172a"
                        font.family: "Inter"
                        font.pixelSize: 14
                        font.weight: Font.Bold
                        text: transactionRow.transactionName
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                    }

                    Rectangle {
                        implicitWidth: badgeText.implicitWidth + 12
                        implicitHeight: 18
                        color: transactionRow.typeConfig.bg
                        radius: 9

                        Text {
                            id: badgeText
                            anchors.centerIn: parent
                            color: transactionRow.typeConfig.color
                            font.family: "Inter"
                            font.pixelSize: 11
                            font.weight: Font.Bold
                            text: transactionRow.typeConfig.label
                        }
                    }
                }
            }
        }

        // 2. AMOUNT
        Item {
            Layout.preferredWidth: 200
            Layout.fillHeight: true

            Text {
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                color: transactionRow.typeConfig.color
                font.family: "Intel One Mono"
                font.pixelSize: 15
                font.weight: Font.Bold
                text: transactionRow.amountText
            }
        }

        // 3. CATEGORY
        Item {
            Layout.preferredWidth: 180
            Layout.fillHeight: true

            Text {
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                color: "#475569"
                font.family: "Inter"
                font.pixelSize: 14
                font.weight: Font.Medium
                text: transactionRow.categoryText
                elide: Text.ElideRight
            }
        }

        // 4. METHOD
        Item {
            Layout.preferredWidth: 180
            Layout.fillHeight: true

            Text {
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                font.family: "Inter"
                font.pixelSize: 14
                font.weight: Font.Medium
                color: "#1e293b"
                text: transactionRow.methodText
                elide: Text.ElideRight
            }
        }

        // 5. TRANSACTION DATE
        Item {
            Layout.preferredWidth: 180
            Layout.fillHeight: true

            Text {
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                color: "#64748b"
                font.family: "Inter"
                font.pixelSize: 14
                font.weight: Font.Normal
                text: transactionRow.dateText
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
                        onClicked: transactionRow.editClicked()
                    }
                }

                Trash_1 {
                    implicitWidth: 18
                    implicitHeight: 18
                    _state: Trash_1.State_1.State_1_default

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: transactionRow.trashClicked()
                    }
                }
            }
        }
    }
}