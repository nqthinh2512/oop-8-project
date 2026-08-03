import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Dialogs

Rectangle {
    id: savingsPage

    color: "#f8fafc"
    clip: true

    FileDialog {
        id: exportFileDialog
        title: "Export Savings to CSV"
        fileMode: FileDialog.SaveFile
        nameFilters: ["CSV Files (*.csv)", "All Files (*)"]
        defaultSuffix: "csv"
        currentFile: "savings_export.csv"
        onAccepted: {
            savingsController.exportToCSV(selectedFile.toString())
        }
    }

    // savingsController đã được main.cpp bơm sẵn vào QML qua context property

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
                text: "Savings"
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
        // 2. TOP SUMMARY CARDS — Kết nối với savingsController
        // =================================================================
        RowLayout {
            Layout.fillWidth: true
            spacing: 20

            PageBox_1 {
                boxTitle: "TOTAL SAVED"
                amountText: savingsController.totalSavedText
                labelText: "Across All Goals"
            }

            PageBox_1 {
                boxTitle: "REMAINING"
                amountText: savingsController.totalRemainingText
                labelText: "To Reach All Target"
            }

            PageBox_1 {
                boxTitle: "COMPLETED"
                amountText: savingsController.completedText
                labelText: "Goals Fully Funded"
            }
        }

        // =================================================================
        // 3. TABLE CONTAINER (Toolbar + Header + ListView Rows)
        // =================================================================
        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 0

            // A. Table Toolbar
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
                        placeholderText: "Search Saving"
                        Layout.preferredWidth: 260
                        onTextChanged: savingsController.searchText = text
                    }

                    RowLayout {
                        spacing: 8

                        UniversalButton_1 {
                            buttonText: "All"
                            _state: savingsController.priorityFilter === -1
                                    ? UniversalButton_1.State_1.State_1_selected
                                    : UniversalButton_1.State_1.State_1_default
                            onClicked: savingsController.priorityFilter = -1
                        }
                        UniversalButton_1 {
                            buttonText: "High"
                            _state: savingsController.priorityFilter === 2
                                    ? UniversalButton_1.State_1.State_1_selected
                                    : UniversalButton_1.State_1.State_1_default
                            onClicked: savingsController.priorityFilter = 2
                        }
                        UniversalButton_1 {
                            buttonText: "Medium"
                            _state: savingsController.priorityFilter === 1
                                    ? UniversalButton_1.State_1.State_1_selected
                                    : UniversalButton_1.State_1.State_1_default
                            onClicked: savingsController.priorityFilter = 1
                        }
                        UniversalButton_1 {
                            buttonText: "Low"
                            _state: savingsController.priorityFilter === 0
                                    ? UniversalButton_1.State_1.State_1_selected
                                    : UniversalButton_1.State_1.State_1_default
                            onClicked: savingsController.priorityFilter = 0
                        }
                    }

                    Rectangle {
                        Layout.preferredWidth: 1
                        Layout.preferredHeight: 24
                        color: "#cbd5e1"
                    }

                    // Category filter dropdown
                    Dropdown_1 {
                        id: categoryFilterDropdown
                        Layout.preferredWidth: 200
                        selectedText: "All Main Categories"
                        selectedIndex: 0

                        property var categoryOptionsFull: {
                            var opts = [{id: 0, name: "All Main Categories"}]
                            var cats = savingsController.categoryOptions
                            for (var i = 0; i < cats.length; i++) opts.push(cats[i])
                            return opts
                        }
                        model: {
                            var names = []
                            for (var i = 0; i < categoryOptionsFull.length; i++) names.push(categoryOptionsFull[i].name)
                            return names
                        }

                        onSelected: (index, value) => {
                            savingsController.categoryFilter = categoryOptionsFull[index].id
                        }
                    }

                    Item { Layout.fillWidth: true }

                    UniversalButton_1 {
                        buttonText: "Export CSV"
                        onClicked: exportFileDialog.open()
                    }

                    UniversalButton_1 {
                        buttonText: "+Add Saving"
                        _state: UniversalButton_1.State_1.State_1_selected
                        Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                        onClicked: {
                            savingDialogContent.openForAdd()
                        }
                    }
                }
            }

            // B. Table Column Header Bar
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

                    Item { Layout.fillWidth: true; Layout.preferredWidth: 260; Layout.fillHeight: true
                        Text { anchors.left: parent.left; anchors.verticalCenter: parent.verticalCenter; text: "SAVING"; font.family: "Inter"; font.pixelSize: 12; font.weight: Font.Bold; color: "#64748b" } }
                    Item { Layout.preferredWidth: 80; Layout.fillHeight: true
                        Text { anchors.left: parent.left; anchors.verticalCenter: parent.verticalCenter; text: "PRIORITY"; font.family: "Inter"; font.pixelSize: 12; font.weight: Font.Bold; color: "#64748b" } }
                    Item { Layout.preferredWidth: 160; Layout.fillHeight: true
                        Text { anchors.left: parent.left; anchors.verticalCenter: parent.verticalCenter; text: "CATEGORY"; font.family: "Inter"; font.pixelSize: 12; font.weight: Font.Bold; color: "#64748b" } }
                    Item { Layout.preferredWidth: 280; Layout.fillHeight: true
                        Text { anchors.left: parent.left; anchors.verticalCenter: parent.verticalCenter; text: "PROGRESS"; font.family: "Inter"; font.pixelSize: 12; font.weight: Font.Bold; color: "#64748b" } }
                    Item { Layout.preferredWidth: 180; Layout.fillHeight: true
                        Text { anchors.left: parent.left; anchors.verticalCenter: parent.verticalCenter; text: "DUE DATE"; font.family: "Inter"; font.pixelSize: 12; font.weight: Font.Bold; color: "#64748b" } }
                    Item { Layout.preferredWidth: 100; Layout.fillHeight: true
                        Text { anchors.right: parent.right; anchors.rightMargin: 8; anchors.verticalCenter: parent.verticalCenter; text: "ACTIONS"; font.family: "Inter"; font.pixelSize: 12; font.weight: Font.Bold; color: "#64748b" } }
                }
            }

            // C. Dynamic Row ListView — Kết nối với savingsController.savingsList
            ListView {
                id: listView
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                spacing: 0

                model: savingsController.savingsList

                delegate: SavingRow_1 {
                    width: listView.width
                    savingName: modelData.sName
                    priorityVal: modelData.priorityVal
                    categoryText: modelData.cat
                    savedText: modelData.sText
                    goalText: modelData.gText
                    progressFraction: modelData.pFrac
                    progressSubText: modelData.subT
                    dueDateText: modelData.dDate

                    onEditClicked: {
                        savingDialogContent.openForEdit(modelData)
                    }
                    onDeleteClicked: {
                        deleteDialogContent.openForDelete(modelData.id, modelData.sName)
                    }
                }

                ScrollBar.vertical: ScrollBar {
                    policy: ScrollBar.AsNeeded
                }
            }
        }
    }

    // =================================================================
    // 4. SAVING DIALOG (Add / Edit)
    // =================================================================
    SavingDialog {
        id: savingDialogContent
        categoryList: savingsController.categoryOptions

        onAccepted: (isEdit, id, name, priority, categoryId, current, target, dueDateStr) => {
            var ok
            if (isEdit)
                ok = savingsController.updateSaving(id, name, priority, categoryId, target, current, dueDateStr)
            else
                ok = savingsController.addSaving(name, priority, categoryId, target, current, dueDateStr)

            if (!ok) {
                savingDialogContent.showError("Dữ liệu không hợp lệ — kiểm tra lại!")
            }
        }
    }

    // =================================================================
    // 5. DELETE CONFIRMATION DIALOG
    // =================================================================
    DeleteDialog {
        id: deleteDialogContent
        onAccepted: (id) => {
            savingsController.removeSaving(id)
        }
    }
}