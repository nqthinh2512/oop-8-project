import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Rectangle {
    id: categoriesPage

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
                text: "Categories"
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
        // 2. TABLE CONTAINER (Toolbar + Header + ListView Rows)
        // =================================================================
        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 0

            // A. Table Toolbar (Search, Filter Tabs, Dropdown, Add Category Button)
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
                            buttonText: "Active"
                            _state: UniversalButton_1.State_1.State_1_default
                        }
                        UniversalButton_1 {
                            buttonText: "Inactive"
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
                        buttonText: "+ Add Category"
                        _state: UniversalButton_1.State_1.State_1_selected
                        Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                        onClicked: console.log("Add Category clicked")
                    }
                }
            }

            // B. Table Column Header Bar (Matching CategoryRow_1 column wrappers)
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

                    // 1. MAIN CATEGORY
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
                            color: "#64748b"
                        }
                    }

                    // 2. CATEGORY NAME
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
                            color: "#64748b"
                        }
                    }

                    // 3. TOTAL MONEY BY CATEGORY
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
                            color: "#64748b"
                        }
                    }

                    // 4. STATUS
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

                    // 5. ACTIONS
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
                    ListElement { mCat: "Name"; catName: "Category"; amount: "1,000 VND"; statusVal: CategoryRow_1.Status.Status_inactive }
                    ListElement { mCat: "Name"; catName: "Category"; amount: "1,000 VND"; statusVal: CategoryRow_1.Status.Status_active }
                    ListElement { mCat: "Housing"; catName: "Rent & Mortgages"; amount: "15,000,000 VND"; statusVal: CategoryRow_1.Status.Status_active }
                    ListElement { mCat: "Food"; catName: "Groceries & Dining"; amount: "4,500,000 VND"; statusVal: CategoryRow_1.Status.Status_active }
                    ListElement { mCat: "Entertainment"; catName: "Movies & Games"; amount: "2,000,000 VND"; statusVal: CategoryRow_1.Status.Status_inactive }
                }

                delegate: CategoryRow_1 {
                    width: listView.width
                    mainCategoryName: model.mCat
                    categoryName: model.catName
                    totalAmountText: model.amount
                    status_1: model.statusVal

                    onEditClicked: console.log("Edit category: " + model.catName)
                    onDeleteClicked: console.log("Delete category: " + model.catName)
                }

                ScrollBar.vertical: ScrollBar {
                    policy: ScrollBar.AsNeeded
                }
            }
        }
    }
}