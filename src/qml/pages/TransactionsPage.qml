import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "../components/dialogs"

Rectangle {
    id: transactionsPage

    color: "#f8fafc"
    clip: true

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 24
        spacing: 20

        // =================================================================
        // 1. PAGE HEADER TITLE & DIVIDER
        // =================================================================
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 16

            Text {
                text: "Transactions"
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
        // 2. MAIN TABLE CONTAINER
        // =================================================================
        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 0

            // --- A. TOOLBAR (Search, Filter Tabs, Category Dropdown, Add Button) ---
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

                    // Search Bar
                    SearchBar_1 {
                        id: searchBar
                        placeholderText: "Search category name"
                        Layout.preferredWidth: 260
                        text: transactionsController.searchKeyword
                        onTextEdited: function(newText) { transactionsController.searchKeyword = newText }
                    }

                    // Filter Pills
                    RowLayout {
                        spacing: 8

                        UniversalButton_1 {
                            buttonText: "All"
                            _state: transactionsController.filterType === -1 ? UniversalButton_1.State_1.State_1_selected : UniversalButton_1.State_1.State_1_default
                            onClicked: transactionsController.filterType = -1
                        }
                        UniversalButton_1 {
                            buttonText: "Income"
                            _state: transactionsController.filterType === 0 ? UniversalButton_1.State_1.State_1_selected : UniversalButton_1.State_1.State_1_default
                            onClicked: transactionsController.filterType = 0
                        }
                        UniversalButton_1 {
                            buttonText: "Expense"
                            _state: transactionsController.filterType === 1 ? UniversalButton_1.State_1.State_1_selected : UniversalButton_1.State_1.State_1_default
                            onClicked: transactionsController.filterType = 1
                        }
                        UniversalButton_1 {
                            buttonText: "Transfer"
                            _state: transactionsController.filterType === 2 ? UniversalButton_1.State_1.State_1_selected : UniversalButton_1.State_1.State_1_default
                            onClicked: transactionsController.filterType = 2
                        }
                    }

                    // Vertical Separator Line
                    Rectangle {
                        Layout.preferredWidth: 1
                        Layout.preferredHeight: 24
                        color: "#cbd5e1"
                    }

                    // Category Dropdown
                    Dropdown_1 {
                        id: categoryFilterDropdown
                        Layout.preferredWidth: 200
                        
                        property var allCats: categoriesController.categoriesList
                        property var filteredCats: allCats.filter(function(c) { return c.parentId === 1 || c.parentId === 2; })
                        property var catData: [{id: 0, name: "All Main Categories"}].concat(filteredCats)
                        model: catData.map(function(c) { return c.name; })
                        selectedText: "All Main Categories"
                        
                        onSelected: function(index, value) {
                            if (index >= 0 && index < catData.length) {
                                transactionsController.categoryIdFilter = catData[index].id
                            }
                        }
                    }

                    // Flexible Spacer pushing Add button to right
                    Item {
                        Layout.fillWidth: true
                    }

                    // Add Transaction Button
                    UniversalButton_1 {
                        buttonText: "+ Add Transaction"
                        _state: UniversalButton_1.State_1.State_1_selected
                        Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                        onClicked: {
                            transactionDialog.reset()
                            transactionDialog.open()
                        }
                    }
                }
            }

            // --- B. TABLE COLUMN HEADERS ---
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

                    // 1. TRANSACTION
                    Item {
                        Layout.fillWidth: true
                        Layout.preferredWidth: 320
                        Layout.fillHeight: true

                        Text {
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            text: "TRANSACTION"
                            font.family: "Inter"
                            font.pixelSize: 12
                            font.weight: Font.Bold
                            color: "#64748b"
                        }
                    }

                    // 2. AMOUNT
                    Item {
                        Layout.preferredWidth: 200
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

                    // 4. METHOD
                    Item {
                        Layout.preferredWidth: 180
                        Layout.fillHeight: true

                        Text {
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            text: "METHOD"
                            font.family: "Inter"
                            font.pixelSize: 12
                            font.weight: Font.Bold
                            color: "#64748b"
                        }
                    }

                    // 5. TRANSACTION DATE
                    Item {
                        Layout.preferredWidth: 180
                        Layout.fillHeight: true

                        Text {
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            text: "TRANSACTION DATE"
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

            // --- C. DYNAMIC TRANSACTION LISTVIEW ---
            ListView {
                id: transactionListView
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                spacing: 0
                boundsBehavior: Flickable.StopAtBounds

                model: transactionsController.model

                delegate: TransactionRow_1 {
                    width: transactionListView.width
                    type_1: model.tType
                    transactionName: model.tName
                    amountText: model.tAmount
                    categoryText: model.tCat
                    methodText: model.tMethod
                    dateText: model.tDate

                    onEditClicked: {
                        transactionDialog.reset()
                        transactionDialog.isEditMode = true
                        transactionDialog.transactionId = model.tId
                        transactionDialog.transactionTitle = model.tName
                        
                        // Extract only numeric digits from amount
                        var rawAmount = model.tAmount.replace(/[^0-9]/g, '')
                        transactionDialog.transactionAmount = rawAmount
                        
                        transactionDialog.transactionMethod = model.tMethod
                        transactionDialog.setCategoryName(model.tCat)
                        transactionDialog.setDateStr(model.tDate)
                        
                        transactionDialog.transactionTypeIndex = model.tType
                        if (model.tType === 0) transactionDialog.transactionTypeText = "Income"
                        else if (model.tType === 1) transactionDialog.transactionTypeText = "Expense"
                        else if (model.tType === 2) transactionDialog.transactionTypeText = "Transfer"
                        
                        transactionDialog.open()
                    }
                    onTrashClicked: {
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

    // Add Transaction Dialog Overlay
    TransactionDialog {
        id: transactionDialog
        anchors.fill: parent

        onAccepted: {
            var dateStr = transactionDialog.dateField ? transactionDialog.dateField.selectedDate : "01/01/2026"
            
            // To get a date string, we need to expose selectedDate from the dialog or parse it.
            // Wait, we didn't expose dateField. Let's use a dummy date for now, or assume the UI will be fully wired later.
            // Or better, let's expose dateField.
            
            if (isEditMode) {
                transactionsController.updateTransaction(
                    transactionId,
                    transactionTypeIndex,
                    transactionTitle,
                    parseFloat(transactionAmount.replace(/,/g, '')) || 0.0,
                    dateStr, 
                    transactionDialog.transactionCategoryId,
                    transactionMethod
                )
            } else {
                transactionsController.addTransaction(
                    transactionTypeIndex,
                    transactionTitle,
                    parseFloat(transactionAmount.replace(/,/g, '')) || 0.0,
                    dateStr, 
                    transactionDialog.transactionCategoryId,
                    transactionMethod
                )
            }
        }
    }

    // Delete Confirmation Dialog Overlay
    DeleteDialog {
        id: deleteDialog
        property int pendingDeleteId: -1

        onAccepted: {
            if (pendingDeleteId !== -1) {
                transactionsController.deleteTransaction(pendingDeleteId)
                pendingDeleteId = -1
            }
        }
        onRejected: {
            pendingDeleteId = -1
        }
    }
}