import QtQuick
import src
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Dialogs
import QtCore
import "../components/dialogs"
import "../components"

Rectangle {
    id: categoriesPage

    color: AppTheme.bgApp
    clip: true


    onVisibleChanged: {
        if (!visible) {
            toolbarDropdown.menuOpen = false
            searchBar.text = ""
            categoriesController.resetFilters()
        }
    }

    CategoryDialog {
        id: categoryDialog

        onAccepted: (id, title, parentId, active) => {
            if (isEditMode && id !== -1) {
                categoriesController.updateCategory(id, title, parentId, active)
            } else {
                categoriesController.addCategory(title, parentId, active)
            }
        }
    }

    DeleteCategoryDialog {
        id: deleteCategoryDialog

        onAccepted: (targetId) => {
            if (deletingCategoryId !== -1) {
                categoriesController.migrateAndRemoveCategory(deletingCategoryId, targetId)
            }
        }

        onDeactivateRequested: () => {
            if (deletingCategoryId !== -1) {
                categoriesController.deactivateCategory(deletingCategoryId)
            }
        }
    }

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
                text: "Categories"
                font.family: "Inter"
                font.pixelSize: 32
                font.weight: Font.Bold
                color: AppTheme.textMain
            }

            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: AppTheme.border
            }
        }

        // =================================================================
        // 2. TABLE CONTAINER (Toolbar + Header + ListView Rows)
        // =================================================================
        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 0

            // A. Sleek Table Toolbar (Search Bar, Category Group Filter Dropdown, Add Button)
            Rectangle {
                Layout.fillWidth: true
                implicitHeight: 70
                color: AppTheme.bgCard
                border.color: AppTheme.border
                border.width: 1
                topLeftRadius: 12
                topRightRadius: 12
                z: 10

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 16
                    anchors.rightMargin: 16
                    spacing: 16

                    SearchBar_1 {
                        id: searchBar
                        placeholderText: "Search category name"
                        Layout.preferredWidth: 260

                        onTextChanged: {
                            categoriesController.searchText = searchBar.text
                        }
                    }

                    // Status Filter Buttons
                    RowLayout {
                        spacing: 6

                        UniversalButton_1 {
                            buttonText: "All"
                            _state: categoriesController.statusFilter === 0 ? UniversalButton_1.State_1.State_1_selected : UniversalButton_1.State_1.State_1_default
                            onClicked: categoriesController.statusFilter = 0
                        }

                        UniversalButton_1 {
                            buttonText: "Active"
                            _state: categoriesController.statusFilter === 1 ? UniversalButton_1.State_1.State_1_selected : UniversalButton_1.State_1.State_1_default
                            onClicked: categoriesController.statusFilter = 1
                        }

                        UniversalButton_1 {
                            buttonText: "Inactive"
                            _state: categoriesController.statusFilter === 2 ? UniversalButton_1.State_1.State_1_selected : UniversalButton_1.State_1.State_1_default
                            onClicked: categoriesController.statusFilter = 2
                        }
                    }

                    Rectangle { Layout.preferredWidth: 1; Layout.preferredHeight: 24; color: AppTheme.divider }

                    // Consolidated Category Group Filter Dropdown
                    Dropdown_1 {
                        id: toolbarDropdown
                        Layout.preferredWidth: 200
                        model: ["All Main Categories", "Income", "Expense", "Bill", "Budget", "Saving"]
                        selectedIndex: categoriesController.parentFilter

                        onSelected: (idx, val) => {
                            categoriesController.parentFilter = idx
                        }
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    UniversalButton_1 {
                        buttonText: "+ Add Category"
                        _state: UniversalButton_1.State_1.State_1_selected
                        Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                        onClicked: categoryDialog.openAdd()
                    }
                }
            }

            // B. Table Column Header Bar
            Rectangle {
                Layout.fillWidth: true
                implicitHeight: 48
                color: AppTheme.bgHover
                border.color: AppTheme.border
                border.width: 1

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 20
                    anchors.rightMargin: 20
                    spacing: 0

                    Item {
                        Layout.fillWidth: true
                        Layout.preferredWidth: 280
                        Layout.fillHeight: true

                        Text {
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            text: "MAIN CATEGORY"
                            font.family: "Inter"
                            font.pixelSize: 12
                            font.weight: Font.Bold
                            color: AppTheme.textSub
                        }
                    }

                    Item {
                        Layout.fillWidth: true
                        Layout.preferredWidth: 260
                        Layout.fillHeight: true

                        Text {
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            text: "CATEGORY NAME"
                            font.family: "Inter"
                            font.pixelSize: 12
                            font.weight: Font.Bold
                            color: AppTheme.textSub
                        }
                    }

                    Item {
                        Layout.fillWidth: true
                        Layout.preferredWidth: 280
                        Layout.fillHeight: true

                        Text {
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            text: "TOTAL MONEY BY CATEGORY"
                            font.family: "Inter"
                            font.pixelSize: 12
                            font.weight: Font.Bold
                            color: AppTheme.textSub
                        }
                    }

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
                            color: AppTheme.textSub
                        }
                    }

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
                            color: AppTheme.textSub
                        }
                    }
                }
            }

            // C. Dynamic Row ListView connected to categoriesController
            ListView {
                id: listView
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                spacing: 0

                model: categoriesController.categoriesList

                delegate: CategoryRow_1 {
                    width: listView.width
                    mainCategoryName: modelData.parentName
                    categoryName: modelData.name
                    totalAmountText: modelData.totalAmountFormatted
                    status_1: modelData.active ? CategoryRow_1.Status.Status_active : CategoryRow_1.Status.Status_inactive

                    onEditClicked: {
                        categoryDialog.openEdit(modelData.id, modelData.name, modelData.parentId, modelData.active)
                    }

                    onDeleteClicked: {
                        deleteCategoryDialog.openWithCategory(modelData.id, modelData.name)
                    }
                }

                ScrollBar.vertical: ScrollBar {
                    policy: ScrollBar.AsNeeded
                }
            }
        }
    }
}
