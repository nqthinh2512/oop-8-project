import QtQuick
import ".."


Item {
    id: root
    anchors.fill: parent
    visible: false
    z: 999

    // --- Properties & Signals kết nối với SavingsPage ---
    property var categoryList: []
    property bool isEditMode: false
    property int currentSavingId: -1
    property string errorMessage: ""

    signal accepted(bool isEdit, int id, string name, int priority, int categoryId, double current, double target, string dueDateStr)
    signal cancelled()

    // --- Các hàm API công khai ---
    function open() { visible = true }
    function close() { visible = false; errorMessage = "" }

    function openForAdd() {
        isEditMode = false
        currentSavingId = -1
        errorMessage = ""
        title_1.text = "Add Saving"
        saveButton.buttonText = "Add"

        // Reset tất cả ô nhập
        textField.text = ""
        amountFundedInput.text = "0"
        saveGoalInput.text = ""

        // Reset Priority về High
        priorityDropdown.selectedIndex = 2
        priorityDropdown.selectedText = "High"

        // Reset Category về mục đầu tiên nếu có
        if (root.categoryList.length > 0) {
            categoryDropdown.selectedIndex = 0
            categoryDropdown.selectedText = root.categoryList[0].name
        }

        // Ngày mặc định: tháng sau
        var nextMonth = new Date()
        nextMonth.setMonth(nextMonth.getMonth() + 1)
        if (date_Input_Field.hasOwnProperty("text"))
            date_Input_Field.text = Qt.formatDate(nextMonth, "dd/MM/yyyy")

        open()
    }

    function openForEdit(modelData) {
        isEditMode = true
        currentSavingId = modelData.id || -1
        errorMessage = ""
        title_1.text = "Edit Saving"
        saveButton.buttonText = "Save"

        // Nap dữ liệu cần sửa
        textField.text = modelData.name || ""
        amountFundedInput.text = String(modelData.currentAmount || 0)
        saveGoalInput.text = String(modelData.targetAmount || 0)

        // Priority
        var priorityLabels = ["Low", "Medium", "High"]
        var pIdx = (typeof modelData.priority === "number") ? modelData.priority : 2
        priorityDropdown.selectedIndex = pIdx
        priorityDropdown.selectedText = priorityLabels[pIdx] || "High"

        // Category: tìm đúng index theo categoryId
        for (var i = 0; i < root.categoryList.length; i++) {
            if (root.categoryList[i].id === modelData.categoryId) {
                categoryDropdown.selectedIndex = i
                categoryDropdown.selectedText = root.categoryList[i].name
                break
            }
        }

        // Due Date
        if (date_Input_Field.hasOwnProperty("text"))
            date_Input_Field.text = modelData.dueDateText || ""

        open()
    }

    function showError(msg) {
        errorMessage = msg
    }

    // --- Dimmed background overlay ---
    Rectangle {
        anchors.fill: parent
        color: "#66000000"

        MouseArea {
            anchors.fill: parent
            onClicked: {
                root.cancelled()
                root.close()
            }
        }
    }

    // --- Centered Dialog Card ---
    Rectangle {
        id: savingDialog
        anchors.centerIn: parent

        height: 540
        width: 500

        color: "#ffffff"
        radius: 15
        clip: true

        // Chống click xuyên qua nền mờ
        MouseArea { anchors.fill: parent }

        // 1. Title Header
        Image {
            id: title
            source: Qt.resolvedUrl("../../assets/title_11.png")

            Text {
                id: title_1
                x: 20
                y: 9
                height: 32
                width: 300
                color: "#191919"
                font.capitalization: Font.Capitalize
                font.family: "Intel One Mono"
                font.pixelSize: 24
                font.weight: Font.DemiBold
                horizontalAlignment: Text.AlignLeft
                lineHeight: 32
                lineHeightMode: Text.FixedHeight
                text: "Add Saving"
                textFormat: Text.PlainText
                verticalAlignment: Text.AlignTop
                wrapMode: Text.Wrap
            }

            // Thông báo lỗi
            Text {
                id: errLabel
                x: 200
                y: 14
                height: 24
                width: 280
                color: "#dc2626"
                font.family: "Roboto"
                font.pixelSize: 12
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignVCenter
                text: root.errorMessage
                visible: root.errorMessage !== ""
                elide: Text.ElideRight
            }
        }

        // 2. Saving Title Field
        Rectangle {
            id: titleInput
            y: 75
            height: 74
            width: 500
            color: "transparent"

            Text {
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
                text: "Saving Title"
                textFormat: Text.PlainText
                verticalAlignment: Text.AlignTop
                wrapMode: Text.Wrap
            }

            Rectangle {
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
                        text: "Nhập tên mục tiêu tiết kiệm..."
                        color: "#8049454f"
                        font: parent.font
                        visible: !parent.text && !parent.activeFocus
                        anchors.fill: parent
                        verticalAlignment: Text.AlignVCenter
                    }
                }
            }
        }

        // 3. Priority, Categories, Amount Funded & Save Goal Grid Row
        Rectangle {
            id: rowContainer
            y: 174
            height: 142
            width: 500
            color: "transparent"

            // Priority Dropdown
            Rectangle {
                x: 20
                height: 66
                width: 225
                color: "transparent"

                Text {
                    height: 32
                    width: 226
                    color: "#878787"
                    font.family: "Intel One Mono"
                    font.pixelSize: 20
                    font.weight: Font.DemiBold
                    horizontalAlignment: Text.AlignLeft
                    lineHeight: 32
                    lineHeightMode: Text.FixedHeight
                    text: "Priority"
                    textFormat: Text.PlainText
                    verticalAlignment: Text.AlignTop
                    wrapMode: Text.Wrap
                }

                Dropdown_1 {
                    id: priorityDropdown
                    y: 32
                    height: 34
                    width: 225
                    _state: Dropdown_1.State_1.State_1_default
                    clip: true
                    model: ["Low", "Medium", "High"]
                    selectedText: "High"
                    selectedIndex: 2
                }
            }

            // Categories Dropdown
            Rectangle {
                x: 255
                height: 66
                width: 225
                color: "transparent"

                Text {
                    height: 32
                    width: 226
                    color: "#878787"
                    font.family: "Intel One Mono"
                    font.pixelSize: 20
                    font.weight: Font.DemiBold
                    horizontalAlignment: Text.AlignLeft
                    lineHeight: 32
                    lineHeightMode: Text.FixedHeight
                    text: "Categories"
                    textFormat: Text.PlainText
                    verticalAlignment: Text.AlignTop
                    wrapMode: Text.Wrap
                }

                Dropdown_1 {
                    id: categoryDropdown
                    y: 32
                    height: 34
                    width: 225
                    _state: Dropdown_1.State_1.State_1_default
                    clip: true
                    model: {
                        var names = []
                        for (var i = 0; i < root.categoryList.length; i++) names.push(root.categoryList[i].name)
                        return names
                    }
                    selectedText: root.categoryList.length > 0 ? root.categoryList[0].name : "Select Category"
                    selectedIndex: 0
                }
            }

            // Amount Funded Input
            Rectangle {
                x: 20
                y: 76
                height: 66
                width: 225
                color: "transparent"

                Text {
                    height: 32
                    width: 226
                    color: "#878787"
                    font.family: "Intel One Mono"
                    font.pixelSize: 20
                    font.weight: Font.DemiBold
                    horizontalAlignment: Text.AlignLeft
                    lineHeight: 32
                    lineHeightMode: Text.FixedHeight
                    text: "Amount Funded"
                    textFormat: Text.PlainText
                    verticalAlignment: Text.AlignTop
                    wrapMode: Text.Wrap
                }

                Rectangle {
                    y: 32
                    height: 34
                    width: 225
                    color: "#e9e9e9"
                    radius: 10

                    TextInput {
                        id: amountFundedInput
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
                        inputMethodHints: Qt.ImhFormattedNumbersOnly

                        Text {
                            text: "0"
                            color: "#8049454f"
                            font: parent.font
                            visible: !parent.text && !parent.activeFocus
                            anchors.fill: parent
                            verticalAlignment: Text.AlignVCenter
                        }
                    }
                }
            }

            // Save Goal Input
            Rectangle {
                x: 255
                y: 76
                height: 66
                width: 225
                color: "transparent"

                Text {
                    height: 32
                    width: 226
                    color: "#878787"
                    font.family: "Intel One Mono"
                    font.pixelSize: 20
                    font.weight: Font.DemiBold
                    horizontalAlignment: Text.AlignLeft
                    lineHeight: 32
                    lineHeightMode: Text.FixedHeight
                    text: "Save Goal"
                    textFormat: Text.PlainText
                    verticalAlignment: Text.AlignTop
                    wrapMode: Text.Wrap
                }

                Rectangle {
                    y: 32
                    height: 34
                    width: 225
                    color: "#e9e9e9"
                    radius: 10

                    TextInput {
                        id: saveGoalInput
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
                        inputMethodHints: Qt.ImhFormattedNumbersOnly

                        Text {
                            text: "0"
                            color: "#8049454f"
                            font: parent.font
                            visible: !parent.text && !parent.activeFocus
                            anchors.fill: parent
                            verticalAlignment: Text.AlignVCenter
                        }
                    }
                }
            }
        }

        // 4. Due Date Field
        Rectangle {
            id: dueDateSection
            y: 341
            height: 74
            width: 500
            color: "transparent"

            Text {
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
                text: "Due Date"
                textFormat: Text.PlainText
                verticalAlignment: Text.AlignTop
                wrapMode: Text.Wrap
            }

            Date_Input_Field_1 {
                id: date_Input_Field
                x: 20
                y: 32
                height: 42
                width: 460
            }
        }

        // 5. Footer Action Buttons
        Image {
            id: choice
            y: 440
            source: Qt.resolvedUrl("../../assets/choice_2.png")

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
                        root.cancelled()
                        root.close()
                    }
                }
            }

            UniversalButton_1 {
                id: saveButton
                x: 405
                y: 9
                buttonText: root.isEditMode ? "Save" : "Add"
                height: 35
                width: 75
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
                            root.showError("Mục tiêu tiết kiệm phải > 0!")
                            return
                        }

                        var current = parseFloat(amountFundedInput.text) || 0.0
                        if (current > target) {
                            root.showError("Số tiền đã góp không được > mục tiêu!")
                            return
                        }

                        var priorityVal = priorityDropdown.selectedIndex
                        var catId = (root.categoryList.length > 0 && categoryDropdown.selectedIndex < root.categoryList.length)
                            ? root.categoryList[categoryDropdown.selectedIndex].id : 0
                        var dueDateStr = date_Input_Field.hasOwnProperty("text") ? date_Input_Field.text : ""

                        root.accepted(
                            root.isEditMode,
                            root.currentSavingId,
                            name,
                            priorityVal,
                            catId,
                            current,
                            target,
                            dueDateStr
                        )
                        root.close()
                    }
                }
            }
        }
    }
}