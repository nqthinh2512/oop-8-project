import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Rectangle {
    id: budgetsPage

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
                text: "Budgets"
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
                boxTitle: "TOTAL SPENT"
                amountText: "1,000 VND"
                labelText: "Across All Budgets"
            }

            PageBox_1 {
                boxTitle: "TOTAL LIMIT"
                amountText: "1,000 VND"
                labelText: "Across All Budgets"
            }

            PageBox_1 {
                boxTitle: "REMAINING"
                amountText: "1,000 VND"
                labelText: "Available To Spend"
            }
        }

        // =================================================================
        // 3. TABLE CONTAINER (Toolbar + Header + ListView Rows)
        // =================================================================
        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 0

            // A. Table Toolbar (Search, Priority Tabs, Dropdown, Add Budget)
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
                        placeholderText: "Search Budget"
                        Layout.preferredWidth: 260
                    }

                    RowLayout {
                        spacing: 8

                        UniversalButton_1 {
                            buttonText: "All"
                            _state: UniversalButton_1.State_1.State_1_selected
                        }
                        UniversalButton_1 {
                            buttonText: "High"
                            _state: UniversalButton_1.State_1.State_1_default
                        }
                        UniversalButton_1 {
                            buttonText: "Medium"
                            _state: UniversalButton_1.State_1.State_1_default
                        }
                        UniversalButton_1 {
                            buttonText: "Low"
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
                        buttonText: "+Add Budget"
                        _state: UniversalButton_1.State_1.State_1_selected
                        Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                        onClicked: console.log("Add Budget clicked")
                    }
                }
            }

            // B. Table Column Header Bar (Exact matching BudgetRow_1 columns)
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

                    // 1. BUDGET
                    Item {
                        Layout.fillWidth: true
                        Layout.preferredWidth: 200
                        Layout.fillHeight: true

                        Text {
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            text: "BUDGET"
                            font.family: "Inter"
                            font.pixelSize: 12
                            font.weight: Font.Bold
                            color: "#64748b"
                        }
                    }

                    // 2. PRIORITY
                    Item {
                        Layout.preferredWidth: 140
                        Layout.fillHeight: true

                        Text {
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            text: "PRIORITY"
                            font.family: "Inter"
                            font.pixelSize: 12
                            font.weight: Font.Bold
                            color: "#64748b"
                        }
                    }

                    // 3. CATEGORY
                    Item {
                        Layout.preferredWidth: 160
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

                    // 4. PROGRESS
                    Item {
                        Layout.preferredWidth: 280
                        Layout.fillHeight: true

                        Text {
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            text: "PROGRESS"
                            font.family: "Inter"
                            font.pixelSize: 12
                            font.weight: Font.Bold
                            color: "#64748b"
                        }
                    }

                    // 5. DATE & CYCLE
                    Item {
                        Layout.preferredWidth: 240
                        Layout.fillHeight: true

                        Text {
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            text: "DATE & CYCLE"
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

            // C. Dynamic Row ListView
            ListView {
                id: listView
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                spacing: 0

                model: ListModel {
                    ListElement {
                        bName: "Name"
                        pVal: Priority_1.Priority_1.Priority_1_medium
                        cat: "Category"
                        sText: "1,000 VND"
                        lText: "/ 20,000 VND"
                        pFrac: 0.67
                        subT: "67% saved"
                        sDate: "31/12/2012"
                        eDate: "31/12/2013"
                        perVal: DateCycle_1.Period.Period_yearly
                    }
                    ListElement {
                        bName: "Name"
                        pVal: Priority_1.Priority_1.Priority_1_medium
                        cat: "Category"
                        sText: "1,000 VND"
                        lText: "/ 20,000 VND"
                        pFrac: 0.67
                        subT: "67% saved"
                        sDate: "31/12/2012"
                        eDate: "31/12/2013"
                        perVal: DateCycle_1.Period.Period_yearly
                    }
                    ListElement {
                        bName: "Name"
                        pVal: Priority_1.Priority_1.Priority_1_medium
                        cat: "Category"
                        sText: "1,000 VND"
                        lText: "/ 20,000 VND"
                        pFrac: 0.67
                        subT: "67% saved"
                        sDate: "31/12/2012"
                        eDate: "31/12/2013"
                        perVal: DateCycle_1.Period.Period_yearly
                    }
                }

                delegate: BudgetRow_1 {
                    width: listView.width
                    budgetName: model.bName
                    priorityVal: model.pVal
                    categoryText: model.cat
                    spentText: model.sText
                    limitText: model.lText
                    progressFraction: model.pFrac
                    progressSubText: model.subT
                    startDate: model.sDate
                    endDate: model.eDate
                    periodVal: model.perVal

                    onEditClicked: console.log("Edit budget: " + model.bName)
                    onDeleteClicked: console.log("Delete budget: " + model.bName)
                }

                ScrollBar.vertical: ScrollBar {
                    policy: ScrollBar.AsNeeded
                }
            }
        }
    }
}