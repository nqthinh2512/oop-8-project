import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Rectangle {
    id: billsPage

    color: "#f8fafc"
    clip: true

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 24
        spacing: 20

        // =================================================================
        // 1. PAGE TITLE & DIVIDER LINE
        // =================================================================
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 16

            Text {
                text: "Bills"
                font.family: "Inter"
                font.pixelSize: 32
                font.weight: Font.Bold
                color: "#0f172a"
            }

            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: "#e2e8f0"
            }
        }

        // =================================================================
        // 2. TOP SUMMARY CARDS (3x PageBox_1)
        // =================================================================
        RowLayout {
            Layout.fillWidth: true
            spacing: 20

            PageBox_1 {
                boxTitle: "TOTAL DUE"
                amountText: "1,000 VND"
                labelText: "Across All Bills"
            }

            PageBox_1 {
                boxTitle: "TOTAL OVERDUE"
                amountText: "1,000 VND"
                labelText: "1 Bill Past Due"
            }

            PageBox_1 {
                boxTitle: "TOTAL PAID"
                amountText: "1,000 VND"
                labelText: "1 Bill Paid This Month"
            }
        }

        // =================================================================
        // 3. TABLE CONTAINER (Toolbar + Header + ListView Rows)
        // =================================================================
        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 0

            // A. Table Toolbar (Filter buttons, Dropdown, Add Bill)
            Rectangle {
                Layout.fillWidth: true
                implicitHeight: 70
                color: "#ffffff"
                border.color: "#e2e8f0"
                border.width: 1
                topLeftRadius: 12
                topRightRadius: 12

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 16
                    anchors.rightMargin: 16
                    spacing: 14

                    SearchBar_1 {
                        id: searchBar
                        placeholderText: "Search category name"
                        Layout.preferredWidth: 260
                    }

                    RowLayout {
                        spacing: 8

                        UniversalButton_1 {
                            buttonText: "All"
                            _state: UniversalButton_1.State_1.State_1_selected
                        }
                        UniversalButton_1 {
                            buttonText: "Paid"
                            _state: UniversalButton_1.State_1.State_1_default
                        }
                        UniversalButton_1 {
                            buttonText: "Upcoming"
                            _state: UniversalButton_1.State_1.State_1_default
                        }
                        UniversalButton_1 {
                            buttonText: "Overdue"
                            _state: UniversalButton_1.State_1.State_1_default
                        }
                    }

                    Rectangle {
                        Layout.preferredWidth: 1
                        Layout.preferredHeight: 24
                        color: "#cbd5e1"
                    }

                    Dropdown_1 {
                        selectedText: "All Main Categories"
                        Layout.preferredWidth: 200
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    UniversalButton_1 {
                        buttonText: "+ Add Bill"
                        _state: UniversalButton_1.State_1.State_1_selected
                        Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                        onClicked: console.log("Add Bill clicked")
                    }
                }
            }

            // B. Table Column Header Bar (Matching BillRow_1 column wrappers exactly)
            Rectangle {
                Layout.fillWidth: true
                implicitHeight: 48
                color: "#f1f5f9"
                border.color: "#e2e8f0"
                border.width: 1

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 20
                    anchors.rightMargin: 20
                    spacing: 0

                    // 1. BILL
                    Item {
                        Layout.fillWidth: true
                        Layout.preferredWidth: 260
                        Layout.fillHeight: true

                        Text {
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            text: "BILL"
                            font.family: "Inter"
                            font.pixelSize: 12
                            font.weight: Font.Bold
                            color: "#64748b"
                        }
                    }

                    // 2. AMOUNT
                    Item {
                        Layout.preferredWidth: 180
                        Layout.fillHeight: true

                        Text {
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            text: "AMOUNT"
                            font.family: "Inter"
                            font.pixelSize: 12
                            font.weight: Font.Bold
                            color: "#64748b"
                        }
                    }

                    // 3. CATEGORY
                    Item {
                        Layout.preferredWidth: 180
                        Layout.fillHeight: true

                        Text {
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            text: "CATEGORY"
                            font.family: "Inter"
                            font.pixelSize: 12
                            font.weight: Font.Bold
                            color: "#64748b"
                        }
                    }

                    // 4. DUE DATE
                    Item {
                        Layout.preferredWidth: 180
                        Layout.fillHeight: true

                        Text {
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            text: "DUE DATE"
                            font.family: "Inter"
                            font.pixelSize: 12
                            font.weight: Font.Bold
                            color: "#64748b"
                        }
                    }

                    // 5. STATUS
                    Item {
                        Layout.preferredWidth: 160
                        Layout.fillHeight: true

                        Text {
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            text: "STATUS"
                            font.family: "Inter"
                            font.pixelSize: 12
                            font.weight: Font.Bold
                            color: "#64748b"
                        }
                    }

                    // 6. ACTIONS
                    Item {
                        Layout.preferredWidth: 100
                        Layout.fillHeight: true

                        Text {
                            anchors.right: parent.right
                            anchors.rightMargin: 8
                            anchors.verticalCenter: parent.verticalCenter
                            text: "ACTIONS"
                            font.family: "Inter"
                            font.pixelSize: 12
                            font.weight: Font.Bold
                            color: "#64748b"
                        }
                    }
                }
            }

            // C. Dynamic Data Rows Container
            ListView {
                id: listView
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                spacing: 0

                model: ListModel {
                    ListElement { name: "Name"; amount: "1,000 VND"; category: "Category"; date: "31/12/2012"; statusVal: BillRow_1.Status.Status_overdue }
                    ListElement { name: "Name"; amount: "1,000 VND"; category: "Category"; date: "31/12/2012"; statusVal: BillRow_1.Status.Status_upcoming }
                    ListElement { name: "Name"; amount: "1,000 VND"; category: "Category"; date: "31/12/2012"; statusVal: BillRow_1.Status.Status_paid }
                    ListElement { name: "Electricity Bill"; amount: "120,000 VND"; category: "Utilities"; date: "30/07/2026"; statusVal: BillRow_1.Status.Status_overdue }
                    ListElement { name: "Internet Subscription"; amount: "450,000 VND"; category: "Services"; date: "02/08/2026"; statusVal: BillRow_1.Status.Status_upcoming }
                    ListElement { name: "Water Supply"; amount: "300,000 VND"; category: "Utilities"; date: "05/08/2026"; statusVal: BillRow_1.Status.Status_paid }
                }

                delegate: BillRow_1 {
                    width: listView.width
                    status_1: model.statusVal
                    billName: model.name
                    amountText: model.amount
                    categoryText: model.category
                    dueDateText: model.date

                    onEditClicked: console.log("Edit bill: " + model.name)
                    onDeleteClicked: console.log("Delete bill: " + model.name)
                }

                ScrollBar.vertical: ScrollBar {
                    policy: ScrollBar.AsNeeded
                }
            }
        }
    }
}