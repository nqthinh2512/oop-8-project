import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Dialogs
import QtCore

Rectangle {
    id: budgetsPage

    color: "#f8fafc"
    clip: true

    FileDialog {
        id: exportFileDialog
        title: "Export Budgets to CSV"
        fileMode: FileDialog.SaveFile
        nameFilters: ["CSV Files (*.csv)", "All Files (*)"]
        defaultSuffix: "csv"
        currentFolder: StandardPaths.standardLocations(StandardPaths.DocumentsLocation)[0]
        currentFile: "file:///" + StandardPaths.writableLocation(StandardPaths.DocumentsLocation) + "/budgets_export.csv"
        onAccepted: {
            budgetsController.exportToCSV(selectedFile.toString())
        }
    }

    // budgetsController đã được main.cpp bơm sẵn vào QML qua context property — KHÔNG cần khai báo lại ở đây

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 24
        spacing: 20

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
            Rectangle { Layout.fillWidth: true; height: 1; color: "#e2e8f0" }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 20

            PageBox_1 {
                boxTitle: "TOTAL SPENT"
                amountText: budgetsController.totalSpentText
                labelText: "Across All Budgets"
            }
            PageBox_1 {
                boxTitle: "TOTAL LIMIT"
                amountText: budgetsController.totalLimitText
                labelText: "Across All Budgets"
            }
            PageBox_1 {
                boxTitle: "REMAINING"
                amountText: budgetsController.totalRemainingText
                labelText: "Available To Spend"
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 0

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
                        onTextChanged: budgetsController.searchText = text
                    }

                    RowLayout {
                        spacing: 8
                        UniversalButton_1 {
                            buttonText: "All"
                            _state: budgetsController.priorityFilter === -1 ? UniversalButton_1.State_1.State_1_selected : UniversalButton_1.State_1.State_1_default
                            onClicked: budgetsController.priorityFilter = -1
                        }
                        UniversalButton_1 {
                            buttonText: "High"
                            _state: budgetsController.priorityFilter === 2 ? UniversalButton_1.State_1.State_1_selected : UniversalButton_1.State_1.State_1_default
                            onClicked: budgetsController.priorityFilter = 2                        }
                        UniversalButton_1 {
                            buttonText: "Medium"
                            _state: budgetsController.priorityFilter === 1 ? UniversalButton_1.State_1.State_1_selected : UniversalButton_1.State_1.State_1_default
                            onClicked: budgetsController.priorityFilter = 1
                        }
                        UniversalButton_1 {
                            buttonText: "Low"
                            _state: budgetsController.priorityFilter === 0 ? UniversalButton_1.State_1.State_1_selected : UniversalButton_1.State_1.State_1_default
                            onClicked: budgetsController.priorityFilter = 0
                        }
                    }

                    Rectangle { Layout.preferredWidth: 1; Layout.preferredHeight: 24; color: "#cbd5e1" }

                    // ===== Dropdown_1 thật cho category filter =====
                    Dropdown_1 {
                        id: categoryFilterDropdown
                        Layout.preferredWidth: 200
                        selectedText: "All Main Categories"
                        selectedIndex: 0

                        // categoryOptionsFull giữ nguyên object {id, name} để tra ngược categoryId khi chọn
                        property var categoryOptionsFull: {
                            var opts = [{id: 0, name: "All Main Categories"}]
                            var cats = budgetsController.categoryOptions
                            for (var i = 0; i < cats.length; i++) opts.push(cats[i])
                            return opts
                        }
                        // Dropdown_1.model chỉ nhận mảng string tên hiển thị
                        model: {
                            var names = []
                            for (var i = 0; i < categoryOptionsFull.length; i++) names.push(categoryOptionsFull[i].name)
                            return names
                        }

                        onSelected: (index, value) => {
                            budgetsController.categoryFilter = categoryOptionsFull[index].id
                        }
                    }

                    Item { Layout.fillWidth: true }

                    UniversalButton_1 {
                        buttonText: "Export CSV"
                        onClicked: exportFileDialog.open()
                    }

                    UniversalButton_1 {
                        buttonText: "+Add Budget"
                        _state: UniversalButton_1.State_1.State_1_selected
                        Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                        onClicked: {
                            budgetDialogContent.openForAdd()
                        }
                    }
                }
            }

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
                        Text { anchors.left: parent.left; anchors.verticalCenter: parent.verticalCenter; text: "BUDGET"; font.family: "Inter"; font.pixelSize: 12; font.weight: Font.Bold; color: "#64748b" } }
                    Item { Layout.preferredWidth: 100; Layout.fillHeight: true
                        Text { anchors.left: parent.left; anchors.verticalCenter: parent.verticalCenter; text: "PRIORITY"; font.family: "Inter"; font.pixelSize: 12; font.weight: Font.Bold; color: "#64748b" } }
                    Item { Layout.preferredWidth: 160; Layout.fillHeight: true
                        Text { anchors.left: parent.left; anchors.verticalCenter: parent.verticalCenter; text: "CATEGORY"; font.family: "Inter"; font.pixelSize: 12; font.weight: Font.Bold; color: "#64748b" } }
                    Item { Layout.preferredWidth: 280; Layout.fillHeight: true
                        Text { anchors.left: parent.left; anchors.verticalCenter: parent.verticalCenter; text: "PROGRESS"; font.family: "Inter"; font.pixelSize: 12; font.weight: Font.Bold; color: "#64748b" } }
                    Item { Layout.preferredWidth: 240; Layout.fillHeight: true
                        Text { anchors.left: parent.left; anchors.verticalCenter: parent.verticalCenter; text: "DATE & CYCLE"; font.family: "Inter"; font.pixelSize: 12; font.weight: Font.Bold; color: "#64748b" } }
                    Item { Layout.preferredWidth: 100; Layout.fillHeight: true
                        Text { anchors.right: parent.right; anchors.rightMargin: 8; anchors.verticalCenter: parent.verticalCenter; text: "ACTIONS"; font.family: "Inter"; font.pixelSize: 12; font.weight: Font.Bold; color: "#64748b" } }
                }
            }

            ListView {
                id: listView
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                spacing: 0

                model: budgetsController.budgetsList

                delegate: BudgetRow_1 {
                    width: listView.width
                    budgetName: modelData.name
                    priorityVal: modelData.priority
                    categoryText: modelData.categoryText
                    spentText: modelData.spentText
                    limitText: modelData.limitText
                    progressFraction: modelData.progressFraction
                    progressSubText: modelData.progressSubText
                    startDate: modelData.startDateText
                    endDate: modelData.endDateText
                    periodVal: modelData.period

                    onEditClicked: {
                        budgetDialogContent.openForEdit(modelData)
                    }
                    onDeleteClicked: {
                        deleteDialogContent.openForDelete(modelData.id, modelData.name)
                    }
                }

                ScrollBar.vertical: ScrollBar { policy: ScrollBar.AsNeeded }
            }
        }
    }

    BudgetDialog {
        id: budgetDialogContent
        categoryList: budgetsController.categoryOptions
        onAccepted: (isEdit, id, name, priority, categoryId, spent, limit, startDateStr, endDateStr) => {
            var ok
            if (isEdit)
                ok = budgetsController.updateBudget(id, name, priority, categoryId, limit, spent, startDateStr, endDateStr)
            else
                ok = budgetsController.addBudget(name, priority, categoryId, limit, spent, startDateStr, endDateStr)

            if (ok) {
                budgetDialogContent.close()
            } else {
                budgetDialogContent.showError("Dữ liệu không hợp lệ — kiểm tra lại hạn mức và ngày tháng")
            }
        }

    }

    DeleteDialog {
        id: deleteDialogContent
        onAccepted: (id) => {
            budgetsController.removeBudget(id)
        }
        // onRejected: không cần làm gì thêm — DeleteDialog tự đóng chính nó (root.close())
    }
}