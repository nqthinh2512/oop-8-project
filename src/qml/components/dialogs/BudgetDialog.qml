import QtQuick
import ".."

Item {
    id: root
    anchors.fill: parent
    visible: false
    z: 999

    // --- Properties & Signals kết nối với BudgetsPage ---
    property var categoryList: []
    property bool isEditMode: false
    property int currentBudgetId: -1
    property string errorMessage: ""

    signal accepted(bool isEdit, int id, string name, int priority, int categoryId, double spent, double limit, string startDateStr, string endDateStr)
    signal cancelled()

    // --- Các hàm API công khai ---
    function open() { visible = true }
    function close() { visible = false; errorMessage = "" }

    function openForAdd() {
        isEditMode = false
        currentBudgetId = -1
        errorMessage = ""
        title_1.text = "Add Budget"
        saveButton.buttonText = "Add"

        // Reset dữ liệu ô nhập
        textField.text = ""
        supporting_text.text = ""
        supporting_text_1.text = ""

        // Reset Priority về Medium
        dropdown_1.selectedIndex = 1
        dropdown_1.selectedText = "Medium"

        // Reset Category về mục đầu tiên (nếu có)
        if (root.categoryList.length > 0) {
            dropdown_3.selectedIndex = 0
            dropdown_3.selectedText = root.categoryList[0].name
        }

        // Reset Period về Monthly
        dropdown_7.selectedIndex = 1
        dropdown_7.selectedText = "Monthly"

        // Gán ngày mặc định — ĐÚNG định dạng dd/MM/yyyy mà Date_Input_Field_1 thật sự dùng
        if (date_Input_Field.hasOwnProperty("text"))
            date_Input_Field.text = Qt.formatDate(new Date(), "dd/MM/yyyy")
        if (date_Input_Field_1.hasOwnProperty("text"))
            date_Input_Field_1.text = Qt.formatDate(new Date(new Date().setMonth(new Date().getMonth() + 1)), "dd/MM/yyyy")

        open()
    }

    function openForEdit(modelData) {
        isEditMode = true
        currentBudgetId = modelData.id || -1
        errorMessage = ""
        title_1.text = "Edit Budget"
        saveButton.buttonText = "Save"

        // Nạp dữ liệu cần sửa
        textField.text = modelData.name || ""
        var rawSpent = modelData.spentText ? modelData.spentText.replace(/[^0-9]/g, '') : "0"
        supporting_text.text = rawSpent.replace(/\B(?=(\d{3})+(?!\d))/g, ",")
        var rawLimit = modelData.limitText ? modelData.limitText.replace(/[^0-9]/g, '') : ""
        supporting_text_1.text = rawLimit.replace(/\B(?=(\d{3})+(?!\d))/g, ",")

        // Priority: modelData.priority là int (0=Low,1=Medium,2=High)
        var priorityLabels = ["Low", "Medium", "High"]
        var pIdx = (typeof modelData.priority === "number") ? modelData.priority : 1
        dropdown_1.selectedIndex = pIdx
        dropdown_1.selectedText = priorityLabels[pIdx] || "Medium"

        // Category: tìm đúng index theo categoryId
        for (var i = 0; i < root.categoryList.length; i++) {
            if (root.categoryList[i].id === modelData.categoryId) {
                dropdown_3.selectedIndex = i
                dropdown_3.selectedText = root.categoryList[i].name
                break
            }
        }

        if (date_Input_Field.hasOwnProperty("text"))
            date_Input_Field.text = modelData.startDateText || ""
        if (date_Input_Field_1.hasOwnProperty("text"))
            date_Input_Field_1.text = modelData.endDateText || ""

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
        id: budgetDialog
        anchors.centerIn: parent

        height: 683
        width: 500

        color: "#ffffff"
        radius: 15
        clip: true

        // Chống click xuyên qua nền mờ
        MouseArea { anchors.fill: parent }

        // 1. Title Header
        Image {
            id: title
            source: Qt.resolvedUrl("../../assets/title_9.png")

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
                text: "Add Budget"
                textFormat: Text.PlainText
                verticalAlignment: Text.AlignTop
                wrapMode: Text.Wrap
            }

            // Hiển thị thông báo lỗi (nếu có)
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

        // 2. Budget Title Field
        Rectangle {
            id: titleInput
            y: 75
            height: 74
            width: 500
            color: "transparent"

            Text {
                id: budget_Title
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
                text: "Budget Title"
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
                        text: "Enter budget title..."
                        color: "#8049454f"
                        font: parent.font
                        visible: !parent.text && !parent.activeFocus
                        anchors.fill: parent
                        verticalAlignment: Text.AlignVCenter
                    }
                }
            }
        }

        // 3. Priority, Categories, Amount Spent & Budget Limit Grid Row
        Rectangle {
            id: rowContainer
            y: 174
            height: 142
            width: 500
            color: "transparent"

            // Priority Dropdown
            Rectangle {
                id: dropdown
                x: 20
                height: 66
                width: 225
                color: "transparent"

                Text {
                    id: priority
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
                    id: dropdown_1
                    y: 32
                    height: 34
                    width: 225
                    _state: Dropdown_1.State_1.State_1_default
                    clip: true
                    // ===== THÊM: model cho Priority, nếu không có model thì bấm vào không mở menu =====
                    model: ["Low", "Medium", "High"]
                    selectedText: "Medium"
                    selectedIndex: 1
                }
            }

            // Categories Dropdown
            Rectangle {
                id: dropdown_2
                x: 255
                height: 66
                width: 225
                color: "transparent"

                Text {
                    id: categories
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
                    id: dropdown_3
                    y: 32
                    height: 34
                    width: 225
                    _state: Dropdown_1.State_1.State_1_default
                    clip: true
                    // ===== THÊM: model lấy từ root.categoryList (do BudgetsPage truyền vào) =====
                    model: {
                        var names = []
                        for (var i = 0; i < root.categoryList.length; i++) names.push(root.categoryList[i].name)
                        return names
                    }
                    selectedText: root.categoryList.length > 0 ? root.categoryList[0].name : "Select Category"
                    selectedIndex: 0
                }
            }

            // Amount Spent Input
            Rectangle {
                id: dropdown_4
                x: 20
                y: 76
                height: 66
                width: 225
                color: "transparent"

                Text {
                    id: amount_Spent
                    height: 32
                    width: 226
                    color: "#878787"
                    font.family: "Intel One Mono"
                    font.pixelSize: 20
                    font.weight: Font.DemiBold
                    horizontalAlignment: Text.AlignLeft
                    lineHeight: 32
                    lineHeightMode: Text.FixedHeight
                    text: "Amount Spent"
                    textFormat: Text.PlainText
                    verticalAlignment: Text.AlignTop
                    wrapMode: Text.Wrap
                }

                Rectangle {
                    id: inputBox_1
                    y: 32
                    height: 34
                    width: 225
                    color: "#e9e9e9"
                    radius: 10

                    TextInput {
                        id: supporting_text
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
                        enabled: true
                        inputMethodHints: Qt.ImhFormattedNumbersOnly
                        onTextChanged: {
                            if (activeFocus) {
                                var raw = text.replace(/[^0-9]/g, "")
                                var formatted = raw.replace(/\B(?=(\d{3})+(?!\d))/g, ",")
                                if (text !== formatted) {
                                    var oldLen = text.length
                                    var pos = cursorPosition
                                    text = formatted
                                    cursorPosition = Math.min(formatted.length, Math.max(0, pos + (formatted.length - oldLen)))
                                }
                            }
                        }

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

            // Budget Limit Input
            Rectangle {
                id: dropdown_5
                x: 255
                y: 76
                height: 66
                width: 225
                color: "transparent"

                Text {
                    id: budget_Limit
                    height: 32
                    width: 226
                    color: "#878787"
                    font.family: "Intel One Mono"
                    font.pixelSize: 20
                    font.weight: Font.DemiBold
                    horizontalAlignment: Text.AlignLeft
                    lineHeight: 32
                    lineHeightMode: Text.FixedHeight
                    text: "Budget Limit"
                    textFormat: Text.PlainText
                    verticalAlignment: Text.AlignTop
                    wrapMode: Text.Wrap
                }

                Rectangle {
                    id: inputBox_2
                    y: 32
                    height: 34
                    width: 225
                    color: "#e9e9e9"
                    radius: 10

                    TextInput {
                        id: supporting_text_1
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
                        onTextChanged: {
                            if (activeFocus) {
                                var raw = text.replace(/[^0-9]/g, "")
                                var formatted = raw.replace(/\B(?=(\d{3})+(?!\d))/g, ",")
                                if (text !== formatted) {
                                    var oldLen = text.length
                                    var pos = cursorPosition
                                    text = formatted
                                    cursorPosition = Math.min(formatted.length, Math.max(0, pos + (formatted.length - oldLen)))
                                }
                            }
                        }

                        Text {
                            text: "1,000,000"
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

        // 4. Start Date Field
        Rectangle {
            id: startDate
            y: 341
            height: 74
            width: 500
            color: "transparent"

            Text {
                id: start_Date
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
                text: "Start Date"
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

        // 5. Due Date Field
        Rectangle {
            id: dueDate
            y: 440
            height: 74
            width: 500
            color: "transparent"

            Text {
                id: due_Date
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
                id: date_Input_Field_1
                x: 20
                y: 32
                height: 42
                width: 460
            }
        }

        // 6. Period Field
        Rectangle {
            id: dropdown_6
            y: 539
            height: 66
            width: 500
            color: "transparent"

            Text {
                id: period
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
                text: "Period"
                textFormat: Text.PlainText
                verticalAlignment: Text.AlignTop
                wrapMode: Text.Wrap
            }

            Dropdown_1 {
                id: dropdown_7
                x: 20
                y: 32
                height: 34
                width: 460
                _state: Dropdown_1.State_1.State_1_default
                clip: true
                // ===== THÊM: model cho Period (chưa lưu vào backend, chỉ hiển thị UI) =====
                model: ["Weekly", "Monthly", "Yearly"]
                selectedText: "Monthly"
                selectedIndex: 1
            }
        }

        // 7. Footer Action Buttons
        Image {
            id: choice
            y: 630
            source: Qt.resolvedUrl("../../assets/choice.png")

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
                        var priorityVal = dropdown_1.selectedIndex
                        // ===== SỬA: lấy categoryId bằng cách tra ngược root.categoryList theo selectedIndex,
                        // vì Dropdown_1 không có property "selectedCategoryId" =====
                        var catId = (root.categoryList.length > 0 && dropdown_3.selectedIndex < root.categoryList.length)
                            ? root.categoryList[dropdown_3.selectedIndex].id : 0
                        var spent = parseFloat(supporting_text.text.replace(/,/g, '')) || 0.0
                        var limit = parseFloat(supporting_text_1.text.replace(/,/g, '')) || 0.0
                        var startStr = date_Input_Field.hasOwnProperty("text") ? date_Input_Field.text : ""
                        var endStr = date_Input_Field_1.hasOwnProperty("text") ? date_Input_Field_1.text : ""

                        if (name === "" || isNaN(limit) || limit <= 0) {
                            root.showError("Tên và hạn mức không hợp lệ!")
                            return
                        }

                        root.accepted(
                            root.isEditMode,
                            root.currentBudgetId,
                            name,
                            priorityVal,
                            catId,
                            spent,
                            limit,
                            startStr,
                            endStr
                        )
                    }
                }
            }
        }
    }
}