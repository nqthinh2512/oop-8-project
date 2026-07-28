import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Rectangle {
    id: savingsPage

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
        // 2. TOP SUMMARY CARDS (3x PageBox_1)
        // =================================================================
        RowLayout {
            Layout.fillWidth: true
            spacing: 20

            PageBox_1 {
                boxTitle: "TOTAL SAVED"
                amountText: "1,000 VND"
                labelText: "Across All Goals"
            }

            PageBox_1 {
                boxTitle: "REMAINING"
                amountText: "1,000 VND"
                labelText: "To Reach All Target"
            }

            PageBox_1 {
                boxTitle: "COMPLETED"
                amountText: "0 / 3"
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

            // A. Table Toolbar (Search, Priority Filters, Dropdown, Add Saving Button)
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
                        buttonText: "+Add Saving"
                        _state: UniversalButton_1.State_1.State_1_selected
                        Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                        onClicked: console.log("Add Saving clicked")
                    }
                }
            }

            // B. Table Column Header Bar (Matching SavingRow_1 column wrappers)
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

                    // 1. SAVING
                    Item {
                        Layout.fillWidth: true
                        Layout.preferredWidth: 200
                        Layout.fillHeight: true

                        Text {
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            text: "SAVING"
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

                    // 5. DUE DATE
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
                        sName: "Name"
                        pVal: Priority_1.Priority_1.Priority_1_high
                        cat: "Category"
                        sText: "1,000 VND"
                        gText: "/ 20,000 VND"
                        pFrac: 0.67
                        subT: "67% saved"
                        dDate: "31/12/2012"
                    }
                    ListElement {
                        sName: "Name"
                        pVal: Priority_1.Priority_1.Priority_1_high
                        cat: "Category"
                        sText: "1,000 VND"
                        gText: "/ 20,000 VND"
                        pFrac: 0.67
                        subT: "67% saved"
                        dDate: "31/12/2012"
                    }
                    ListElement {
                        sName: "Name"
                        pVal: Priority_1.Priority_1.Priority_1_high
                        cat: "Category"
                        sText: "1,000 VND"
                        gText: "/ 20,000 VND"
                        pFrac: 0.67
                        subT: "67% saved"
                        dDate: "31/12/2012"
                    }
                }

                delegate: SavingRow_1 {
                    width: listView.width
                    savingName: model.sName
                    priorityVal: model.pVal
                    categoryText: model.cat
                    savedText: model.sText
                    goalText: model.gText
                    progressFraction: model.pFrac
                    progressSubText: model.subT
                    dueDateText: model.dDate

                    onEditClicked: console.log("Edit saving: " + model.sName)
                    onDeleteClicked: console.log("Delete saving: " + model.sName)
                }

                ScrollBar.vertical: ScrollBar {
                    policy: ScrollBar.AsNeeded
                }
            }
        }
    }
}