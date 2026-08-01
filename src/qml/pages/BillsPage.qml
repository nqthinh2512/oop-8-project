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
                boxTitle: "TOTAL PAID"
                amountText: billsController.totalPaid.toLocaleString(Qt.locale(), 'f', 0) + " VND"
                labelText: "Amount Paid"
            }

            PageBox_1 {
                boxTitle: "UPCOMING (ON TIME)"
                amountText: billsController.totalOnTime.toLocaleString(Qt.locale(), 'f', 0) + " VND"
                labelText: "To Be Paid"
            }

            PageBox_1 {
                boxTitle: "OVERDUE"
                amountText: billsController.totalOverdue.toLocaleString(Qt.locale(), 'f', 0) + " VND"
                labelText: "Past Due"
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
                        placeholderText: "Search bill name"
                        Layout.preferredWidth: 260
                        text: billsController.searchKeyword
                        onTextEdited: function(newText) { billsController.searchKeyword = newText }
                    }

                    RowLayout {
                        spacing: 8

                        UniversalButton_1 {
                            buttonText: "All"
                            _state: billsController.filterType === -1 ? UniversalButton_1.State_1.State_1_selected : UniversalButton_1.State_1.State_1_default
                            onClicked: billsController.filterType = -1
                        }
                        UniversalButton_1 {
                            buttonText: "Paid"
                            _state: billsController.filterType === 0 ? UniversalButton_1.State_1.State_1_selected : UniversalButton_1.State_1.State_1_default
                            onClicked: billsController.filterType = 0
                        }
                        UniversalButton_1 {
                            buttonText: "Upcoming"
                            _state: billsController.filterType === 1 ? UniversalButton_1.State_1.State_1_selected : UniversalButton_1.State_1.State_1_default
                            onClicked: billsController.filterType = 1
                        }
                        UniversalButton_1 {
                            buttonText: "Overdue"
                            _state: billsController.filterType === 2 ? UniversalButton_1.State_1.State_1_selected : UniversalButton_1.State_1.State_1_default
                            onClicked: billsController.filterType = 2
                        }
                    }

                    Rectangle {
                        Layout.preferredWidth: 1
                        Layout.preferredHeight: 24
                        color: "#cbd5e1"
                    }

                    Dropdown_1 {
                        id: categoryFilterDropdown
                        Layout.preferredWidth: 200
                        
                        property var allCats: categoriesController.categoriesList
                        property var filteredCats: allCats.filter(function(c) { return c.parentId === 3; })
                        property var catData: [{id: 0, name: "All Main Categories"}].concat(filteredCats)
                        model: catData.map(function(c) { return c.name; })
                        selectedText: "All Main Categories"
                        
                        onSelected: function(index, value) {
                            if (index >= 0 && index < catData.length) {
                                billsController.categoryIdFilter = catData[index].id
                            }
                        }
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    UniversalButton_1 {
                        buttonText: "+ Add Bill"
                        _state: UniversalButton_1.State_1.State_1_selected
                        Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                        onClicked: {
                            billDialog.reset()
                            billDialog.open()
                        }
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

                boundsBehavior: Flickable.StopAtBounds

                model: billsController

                delegate: BillRow_1 {
                    width: listView.width
                    status_1: model.tStatus
                    billName: model.tName
                    amountText: model.tAmount
                    categoryText: model.tCat
                    dueDateText: model.tDate

                    onMarkPaidClicked: billsController.togglePaidStatus(model.tId)

                    onEditClicked: {
                        billDialog.reset()
                        billDialog.isEditMode = true
                        billDialog.billId = model.tId
                        billDialog.billTitle = model.tName
                        
                        var rawAmount = model.tAmount.replace(/[^0-9]/g, '')
                        billDialog.billAmount = rawAmount.replace(/\B(?=(\d{3})+(?!\d))/g, ",")
                        
                        billDialog.setCategoryName(model.tCat)
                        billDialog.setDateStr(model.tDate)
                        
                        billDialog.open()
                    }
                    onDeleteClicked: {
                        deleteDialog.pendingDeleteId = model.tId
                        deleteDialog.open()
                    }
                }

                ScrollBar.vertical: ScrollBar {
                    policy: ScrollBar.AsNeeded
                }
            }
        }
    }

    BillDialog {
        id: billDialog
        anchors.fill: parent

        onAccepted: {
            var dateStr = billDialog.dateField ? billDialog.dateField.selectedDate : "01/01/2026"
            if (isEditMode) {
                billsController.updateBill(
                    billId,
                    billTitle,
                    parseFloat(billAmount.replace(/,/g, '')) || 0.0,
                    dateStr, 
                    billDialog.billCategoryId
                )
            } else {
                billsController.addBill(
                    billTitle,
                    parseFloat(billAmount.replace(/,/g, '')) || 0.0,
                    dateStr, 
                    billDialog.billCategoryId
                )
            }
        }
    }

    DeleteDialog {
        id: deleteDialog
        property int pendingDeleteId: -1

        onAccepted: {
            if (pendingDeleteId !== -1) {
                billsController.deleteBill(pendingDeleteId)
                pendingDeleteId = -1
            }
        }
        onRejected: {
            pendingDeleteId = -1
        }
    }
}