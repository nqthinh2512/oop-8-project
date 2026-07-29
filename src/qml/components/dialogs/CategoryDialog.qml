import QtQuick
import "../"

Item {
    id: root
    anchors.fill: parent
    visible: false
    z: 999

    property bool isEditMode: false
    property int editingCategoryId: -1

    signal accepted(int id, string title, int parentId, bool active)
    signal rejected()

    property alias categoryTitleText: textField.text
    property int selectedParentId: pageDropdown.selectedIndex + 1
    property bool selectedActive: statusDropdown.selectedIndex === 0

    function openAdd() {
        isEditMode = false
        editingCategoryId = -1
        dialogTitleText.text = "Add Category"
        textField.text = ""
        pageDropdown.selectedIndex = 0
        pageDropdown.selectedText = "Income"
        statusDropdown.selectedIndex = 0
        statusDropdown.selectedText = "Active"
        visible = true
    }

    function openEdit(id, currentTitle, currentParentId, currentActive) {
        isEditMode = true
        editingCategoryId = id
        dialogTitleText.text = "Edit Category"
        textField.text = currentTitle

        var parentNames = ["Income", "Expense", "Bill", "Budget", "Saving"]
        var pIdx = (currentParentId >= 1 && currentParentId <= 5) ? (currentParentId - 1) : 0
        pageDropdown.selectedIndex = pIdx
        pageDropdown.selectedText = parentNames[pIdx]

        statusDropdown.selectedIndex = currentActive ? 0 : 1
        statusDropdown.selectedText = currentActive ? "Active" : "Inactive"

        visible = true
    }

    function open() { openAdd() }
    function close() { visible = false }

    // Dimmed background overlay
    Rectangle {
        anchors.fill: parent
        color: "#66000000"

        MouseArea {
            anchors.fill: parent
            onClicked: root.close()
        }
    }

    // Centered Dialog Card
    Rectangle {
        id: categoryDialog
        anchors.centerIn: parent

        height: 318
        width: 500

        color: "#ffffff"
        radius: 15
        clip: false

        // Absorb clicks inside the card so they don't reach the dimmed overlay
        MouseArea { anchors.fill: parent }

        // 1. Title Header
        Image {
            id: title
            source: Qt.resolvedUrl("../../assets/title_12.png")

            Text {
                id: dialogTitleText
                x: 20
                y: 9
                height: 32
                width: 461
                color: "#191919"
                font.capitalization: Font.Capitalize
                font.family: "Intel One Mono"
                font.pixelSize: 24
                font.weight: Font.DemiBold
                horizontalAlignment: Text.AlignLeft
                lineHeight: 32
                lineHeightMode: Text.FixedHeight
                text: "Add Category"
                textFormat: Text.PlainText
                verticalAlignment: Text.AlignTop
                wrapMode: Text.Wrap
            }
        }

        // 2. Category Title Input
        Rectangle {
            id: titleInput
            y: 75
            height: 74
            width: 500
            color: "transparent"

            Text {
                id: category_Title
                x: 20
                height: 32
                width: 461
                color: "#878787"
                font.family: "Intel One Mono"
                font.pixelSize: 20
                font.weight: Font.DemiBold
                horizontalAlignment: Text.AlignLeft
                lineHeight: 32
                lineHeightMode: Text.FixedHeight
                text: "Category Title"
                textFormat: Text.PlainText
                verticalAlignment: Text.AlignTop
                wrapMode: Text.Wrap
            }

            Rectangle {
                id: inputBox
                x: 20
                y: 32
                height: 42
                width: 460
                color: "#e9e9e9"
                radius: 10

                TextInput {
                    id: textField
                    anchors.fill: parent
                    anchors.leftMargin: 15
                    anchors.rightMargin: 15
                    verticalAlignment: Text.AlignVCenter
                    color: "#191919"
                    font.family: "Roboto"
                    font.pixelSize: 16
                    font.weight: Font.Normal
                    clip: true
                    selectByMouse: true

                    Text {
                        text: "input text"
                        color: "#8049454f"
                        font: parent.font
                        visible: !parent.text && !parent.activeFocus
                        anchors.fill: parent
                        verticalAlignment: Text.AlignVCenter
                    }
                }
            }
        }

        // 3. Page & Status Dropdown Row
        Rectangle {
            id: rowContainer
            y: 174
            height: 66
            width: 500
            color: "transparent"

            // Page Dropdown (Income, Expense, Bill, Budget, Saving)
            Rectangle {
                id: dropdown
                x: 20
                height: 66
                width: 225
                color: "transparent"

                Text {
                    id: page
                    height: 32
                    width: 226
                    color: "#878787"
                    font.family: "Intel One Mono"
                    font.pixelSize: 20
                    font.weight: Font.DemiBold
                    horizontalAlignment: Text.AlignLeft
                    lineHeight: 32
                    lineHeightMode: Text.FixedHeight
                    text: "Main Category"
                    textFormat: Text.PlainText
                    verticalAlignment: Text.AlignTop
                    wrapMode: Text.Wrap
                }

                Dropdown_1 {
                    id: pageDropdown
                    y: 32
                    height: 34
                    width: 225
                    model: ["Income", "Expense", "Bill", "Budget", "Saving"]
                    selectedText: "Income"
                    selectedIndex: 0
                    z: 10
                }
            }

            // Status Dropdown (Active, Inactive)
            Rectangle {
                id: dropdown_2
                x: 255
                height: 66
                width: 225
                color: "transparent"

                Text {
                    id: status
                    height: 32
                    width: 226
                    color: "#878787"
                    font.family: "Intel One Mono"
                    font.pixelSize: 20
                    font.weight: Font.DemiBold
                    horizontalAlignment: Text.AlignLeft
                    lineHeight: 32
                    lineHeightMode: Text.FixedHeight
                    text: "Status"
                    textFormat: Text.PlainText
                    verticalAlignment: Text.AlignTop
                    wrapMode: Text.Wrap
                }

                Dropdown_1 {
                    id: statusDropdown
                    y: 32
                    height: 34
                    width: 225
                    model: ["Active", "Inactive"]
                    selectedText: "Active"
                    selectedIndex: 0
                    z: 10
                }
            }
        }

        // 4. Footer Action Buttons
        Image {
            id: choice
            y: 265
            source: Qt.resolvedUrl("../../assets/choice_3.png")

            UniversalButton_1 {
                id: cancelButton
                x: 305
                y: 9
                buttonText: "Cancel"
                height: 35
                width: 75
                _state: UniversalButton_1.State_1.State_1_default

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        root.rejected()
                        root.close()
                    }
                }
            }

            UniversalButton_1 {
                id: saveButton
                x: 405
                y: 9
                buttonText: "Save"
                height: 35
                width: 75
                _state: UniversalButton_1.State_1.State_1_selected

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        root.accepted(editingCategoryId, textField.text, pageDropdown.selectedIndex + 1, statusDropdown.selectedIndex === 0)
                        root.close()
                    }
                }
            }
        }
    }
}