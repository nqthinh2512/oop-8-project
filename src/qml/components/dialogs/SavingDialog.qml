import QtQuick
import ".."

Item {
    id: root
    anchors.fill: parent
    visible: false
    z: 999

    // --- Properties & Signals ---
    property var categoryList: []
    property bool isEditMode: false
    property int currentSavingId: -1
    property string errorMessage: ""

    signal accepted(bool isEdit, int id, string name, int priority, int categoryId, double current, double target, string dueDateStr)
    signal cancelled()

    function open()  { visible = true }
    function close() { visible = false; errorMessage = "" }

    function openForAdd() {
        isEditMode = false
        currentSavingId = -1
        errorMessage = ""
        title_1.text = "Add Saving"

        textField.text = ""
        amountFundedInput.text = ""
        saveGoalInput.text = ""

        dropdown_1.selectedIndex = 2
        dropdown_1.selectedText = "High"

        if (root.categoryList.length > 0) {
            dropdown_3.selectedIndex = 0
            dropdown_3.selectedText = root.categoryList[0].name
        }

        var nextMonth = new Date()
        nextMonth.setMonth(nextMonth.getMonth() + 1)
        date_Input_Field.text = Qt.formatDate(nextMonth, "dd/MM/yyyy")

        open()
    }

    function openForEdit(modelData) {
        isEditMode = true
        currentSavingId = modelData.id || -1
        errorMessage = ""
        title_1.text = "Edit Saving"

        textField.text = modelData.name || ""
        amountFundedInput.text = String(modelData.currentAmount || 0)
        saveGoalInput.text = String(modelData.targetAmount || 0)

        var priorityLabels = ["Low", "Medium", "High"]
        var pIdx = (typeof modelData.priority === "number") ? modelData.priority : 2
        dropdown_1.selectedIndex = pIdx
        dropdown_1.selectedText = priorityLabels[pIdx] || "High"

        for (var i = 0; i < root.categoryList.length; i++) {
            if (root.categoryList[i].id === modelData.categoryId) {
                dropdown_3.selectedIndex = i
                dropdown_3.selectedText = root.categoryList[i].name
                break
            }
        }

        date_Input_Field.text = modelData.dueDateText || ""
        open()
    }

    function showError(msg) { errorMessage = msg }

    // --- Dimmed overlay ---
    Rectangle {
        anchors.fill: parent
        color: "#66000000"
        MouseArea {
            anchors.fill: parent
            onClicked: { root.cancelled(); root.close() }
        }
    }

    // --- Dialog Card ---
    Rectangle {
        id: card
        anchors.centerIn: parent
        width: 500
        height: 510
        radius: 15
        color: "#ffffff"
        clip: true
        MouseArea { anchors.fill: parent } // block click-through

        // --- Title bar ---
        Rectangle {
            id: titleBar
            anchors.top: parent.top
            width: parent.width
            height: 60
            color: "#f8fafc"
            radius: 15
            // square bottom corners
            Rectangle {
                anchors.bottom: parent.bottom
                width: parent.width
                height: parent.radius
                color: parent.color
            }

            Text {
                id: title_1
                anchors.left: parent.left
                anchors.leftMargin: 20
                anchors.verticalCenter: parent.verticalCenter
                text: "Add Saving"
                color: "#191919"
                font.family: "Intel One Mono"
                font.pixelSize: 22
                font.weight: Font.DemiBold
            }
        }

        // --- Error message ---
        Text {
            id: errLabel
            anchors.top: titleBar.bottom
            anchors.topMargin: 4
            anchors.right: parent.right
            anchors.rightMargin: 16
            height: 20
            color: "#dc2626"
            font.family: "Roboto"
            font.pixelSize: 12
            horizontalAlignment: Text.AlignRight
            text: root.errorMessage
            visible: root.errorMessage !== ""
        }

        // --- Saving Title ---
        Column {
            id: titleSection
            anchors.top: titleBar.bottom
            anchors.topMargin: 14
            anchors.left: parent.left
            anchors.leftMargin: 20
            anchors.right: parent.right
            anchors.rightMargin: 20
            spacing: 6

            Text {
                text: "Saving Title"
                color: "#878787"
                font.family: "Intel One Mono"
                font.pixelSize: 14
                font.weight: Font.DemiBold
            }

            Rectangle {
                width: parent.width
                height: 40
                color: "#e9e9e9"
                radius: 10

                TextInput {
                    id: textField
                    anchors.fill: parent
                    anchors.leftMargin: 14
                    anchors.rightMargin: 14
                    verticalAlignment: Text.AlignVCenter
                    color: "#191919"
                    font.family: "Roboto"
                    font.pixelSize: 15
                    clip: true
                    selectByMouse: true

                    Text {
                        text: "Nhập tên mục tiêu tiết kiệm..."
                        color: "#aab0bb"
                        font: parent.font
                        visible: !parent.text && !parent.activeFocus
                        anchors.fill: parent
                        verticalAlignment: Text.AlignVCenter
                    }
                }
            }
        }

        // --- Priority & Category row ---
        Row {
            id: row1
            anchors.top: titleSection.bottom
            anchors.topMargin: 14
            anchors.left: parent.left
            anchors.leftMargin: 20
            spacing: 20

            Column {
                width: 220
                spacing: 6
                Text { text: "Priority"; color: "#878787"; font.family: "Intel One Mono"; font.pixelSize: 14; font.weight: Font.DemiBold }
                Dropdown_1 {
                    id: dropdown_1
                    width: 220; height: 36
                    model: ["Low", "Medium", "High"]
                    selectedText: "High"
                    selectedIndex: 2
                }
            }

            Column {
                width: 220
                spacing: 6
                Text { text: "Categories"; color: "#878787"; font.family: "Intel One Mono"; font.pixelSize: 14; font.weight: Font.DemiBold }
                Dropdown_1 {
                    id: dropdown_3
                    width: 220; height: 36
                    model: {
                        var names = []
                        for (var i = 0; i < root.categoryList.length; i++) names.push(root.categoryList[i].name)
                        return names
                    }
                    selectedText: root.categoryList.length > 0 ? root.categoryList[0].name : "Select Category"
                    selectedIndex: 0
                }
            }
        }

        // --- Amount Funded & Save Goal row ---
        Row {
            id: row2
            anchors.top: row1.bottom
            anchors.topMargin: 14
            anchors.left: parent.left
            anchors.leftMargin: 20
            spacing: 20

            Column {
                width: 220
                spacing: 6
                Text { text: "Amount Funded"; color: "#878787"; font.family: "Intel One Mono"; font.pixelSize: 14; font.weight: Font.DemiBold }
                Rectangle {
                    width: 220; height: 36
                    color: "#e9e9e9"; radius: 10
                    TextInput {
                        id: amountFundedInput
                        anchors.fill: parent; anchors.leftMargin: 14; anchors.rightMargin: 14
                        verticalAlignment: Text.AlignVCenter
                        color: "#191919"; font.family: "Roboto"; font.pixelSize: 15
                        clip: true; selectByMouse: true
                        inputMethodHints: Qt.ImhFormattedNumbersOnly
                        Text { text: "0"; color: "#aab0bb"; font: parent.font; visible: !parent.text && !parent.activeFocus; anchors.fill: parent; verticalAlignment: Text.AlignVCenter }
                    }
                }
            }

            Column {
                width: 220
                spacing: 6
                Text { text: "Save Goal"; color: "#878787"; font.family: "Intel One Mono"; font.pixelSize: 14; font.weight: Font.DemiBold }
                Rectangle {
                    width: 220; height: 36
                    color: "#e9e9e9"; radius: 10
                    TextInput {
                        id: saveGoalInput
                        anchors.fill: parent; anchors.leftMargin: 14; anchors.rightMargin: 14
                        verticalAlignment: Text.AlignVCenter
                        color: "#191919"; font.family: "Roboto"; font.pixelSize: 15
                        clip: true; selectByMouse: true
                        inputMethodHints: Qt.ImhFormattedNumbersOnly
                        Text { text: "0"; color: "#aab0bb"; font: parent.font; visible: !parent.text && !parent.activeFocus; anchors.fill: parent; verticalAlignment: Text.AlignVCenter }
                    }
                }
            }
        }

        // --- Due Date ---
        Column {
            id: dueDateSection
            anchors.top: row2.bottom
            anchors.topMargin: 14
            anchors.left: parent.left
            anchors.leftMargin: 20
            anchors.right: parent.right
            anchors.rightMargin: 20
            spacing: 6

            Text { text: "Due Date"; color: "#878787"; font.family: "Intel One Mono"; font.pixelSize: 14; font.weight: Font.DemiBold }
            Date_Input_Field_1 {
                id: date_Input_Field
                width: parent.width
                height: 42
            }
        }

        // --- Footer Buttons ---
        Row {
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 16
            anchors.right: parent.right
            anchors.rightMargin: 20
            spacing: 10

            UniversalButton_1 {
                id: cancelButton
                buttonText: "Cancel"
                height: 36
                width: 80
                _state: UniversalButton_1.State_1.State_1_default
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: { root.cancelled(); root.close() }
                }
            }

            UniversalButton_1 {
                id: saveButton
                buttonText: root.isEditMode ? "Save" : "Add"
                height: 36
                width: 80
                _state: UniversalButton_1.State_1.State_1_selected
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        var name = textField.text.trim()
                        if (name === "") {
                            root.showError("Tên không được để trống!")
                            return
                        }

                        var target = parseFloat(saveGoalInput.text) || 0.0
                        if (target <= 0) {
                            root.showError("Save Goal phải lớn hơn 0!")
                            return
                        }

                        var current = parseFloat(amountFundedInput.text) || 0.0
                        if (current > target) {
                            root.showError("Amount Funded không được lớn hơn Save Goal!")
                            return
                        }

                        var priorityVal = dropdown_1.selectedIndex
                        var catId = (root.categoryList.length > 0 && dropdown_3.selectedIndex < root.categoryList.length)
                            ? root.categoryList[dropdown_3.selectedIndex].id : 0
                        var dueDateStr = date_Input_Field.hasOwnProperty("text") ? date_Input_Field.text : ""

                        root.accepted(root.isEditMode, root.currentSavingId, name, priorityVal, catId, current, target, dueDateStr)
                        root.close()
                    }
                }
            }
        }
    }
}