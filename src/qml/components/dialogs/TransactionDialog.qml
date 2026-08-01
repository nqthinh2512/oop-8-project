import QtQuick
import ".."


Item {
    id: root
    anchors.fill: parent
    visible: false
    z: 999

    signal accepted()
    signal rejected()

    property bool isEditMode: false
    property int transactionId: -1
    property string transactionTitle: ""
    property string transactionAmount: ""
    property string transactionMethod: ""
    property int transactionCategoryId: 0
    property alias transactionTypeIndex: dropdown_1.selectedIndex
    property alias transactionTypeText: dropdown_1.selectedText
    property alias dateField: date_Input_Field
    property bool isValidating: false

    function setDateStr(dateStr) {
        var parts = dateStr.split("/");
        if (parts.length === 3) {
            date_Input_Field.setDate(parseInt(parts[0]), parseInt(parts[1]), parseInt(parts[2]));
        }
    }

    function setCategoryName(catName) {
        var allCats = categoriesController.categoriesList;
        var list = allCats.filter(function(c) { return c.parentId === 1 || c.parentId === 2; });
        for (var i = 0; i < list.length; i++) {
            if (list[i].name === catName) {
                dropdown_3.selectedIndex = i;
                dropdown_3.selectedText = catName;
                transactionCategoryId = list[i].id;
                return;
            }
        }
        if (list.length > 0) {
            dropdown_3.selectedIndex = 0;
            dropdown_3.selectedText = list[0].name;
            transactionCategoryId = list[0].id;
        }
    }

    function open() { visible = true }
    function close() { visible = false }

    function reset() {
        isEditMode = false;
        transactionId = -1;
        transactionTitle = "";
        transactionAmount = "";
        transactionMethod = "";
        transactionTypeIndex = 0;
        transactionTypeText = "Income";
        isValidating = false;
        dateField.clear();
        
        var allCats = categoriesController.categoriesList;
        var list = allCats.filter(function(c) { return c.parentId === 1 || c.parentId === 2; });
        if (list.length > 0) {
            dropdown_3.selectedIndex = 0;
            dropdown_3.selectedText = list[0].name;
            transactionCategoryId = list[0].id;
        } else {
            transactionCategoryId = 0;
            dropdown_3.selectedText = "Select Category";
        }
    }

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
        id: transactionDialog
        anchors.centerIn: parent

        height: 493
        width: 500

        color: "#ffffff"
        radius: 15
        clip: true

        // Absorb clicks inside the card so they don't reach the dimmed overlay
        MouseArea { anchors.fill: parent }

        // 1. Title Header
        Image {
            id: title
            source: Qt.resolvedUrl("../../assets/title_14.png")

            Text {
                id: title_1
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
                text: root.isEditMode ? "Edit Transaction" : "Add Transaction"
                textFormat: Text.PlainText
                verticalAlignment: Text.AlignTop
                wrapMode: Text.Wrap
            }
        }

        // 2. Transaction Title Input
        Rectangle {
            id: titleInput
            y: 75
            height: 74
            width: 500
            color: "transparent"

            Text {
                id: transaction_Title
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
                text: "Transaction Title"
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
                border.color: (root.isValidating && root.transactionTitle.trim() === "") ? "red" : "transparent"
                border.width: (root.isValidating && root.transactionTitle.trim() === "") ? 1 : 0

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
                    maximumLength: 30
                    text: root.transactionTitle
                    onTextChanged: root.transactionTitle = text

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

        // 3. Type, Categories, Amount & Method Row
        Rectangle {
            id: rowContainer
            y: 174
            height: 142
            width: 500
            color: "transparent"

            // Type Dropdown
            Rectangle {
                id: dropdown
                x: 20
                height: 66
                width: 225
                color: "transparent"

                Text {
                    id: type
                    height: 32
                    width: 226
                    color: "#878787"
                    font.family: "Intel One Mono"
                    font.pixelSize: 20
                    font.weight: Font.DemiBold
                    horizontalAlignment: Text.AlignLeft
                    lineHeight: 32
                    lineHeightMode: Text.FixedHeight
                    text: "Type"
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
                    model: ["Income", "Expense", "Transfer"]
                    selectedText: "Income" // Default
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
                    
                    property var allCats: categoriesController.categoriesList
                    property var catList: allCats.filter(function(c) { return c.parentId === 1 || c.parentId === 2; })
                    model: catList.map(function(c) { return c.name; })
                    selectedText: catList.length > 0 ? catList[0].name : "Select Category"
                    
                    onSelected: function(index, value) {
                        if (index >= 0 && index < catList.length) {
                            root.transactionCategoryId = catList[index].id
                        }
                    }
                }
            }

            // Amount Input
            Rectangle {
                id: dropdown_4
                x: 20
                y: 76
                height: 66
                width: 225
                color: "transparent"

                Text {
                    id: amount
                    height: 32
                    width: 226
                    color: "#878787"
                    font.family: "Intel One Mono"
                    font.pixelSize: 20
                    font.weight: Font.DemiBold
                    horizontalAlignment: Text.AlignLeft
                    lineHeight: 32
                    lineHeightMode: Text.FixedHeight
                    text: "Amount"
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
                    border.color: (root.isValidating && root.transactionAmount.trim() === "") ? "red" : "transparent"
                    border.width: (root.isValidating && root.transactionAmount.trim() === "") ? 1 : 0

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
                        inputMethodHints: Qt.ImhFormattedNumbersOnly
                        text: root.transactionAmount
                        onTextChanged: {
                            if (activeFocus) {
                                var raw = text.replace(/[^0-9]/g, "")
                                var formatted = raw.replace(/\B(?=(\d{3})+(?!\d))/g, ",")
                                if (text !== formatted) {
                                    var pos = cursorPosition
                                    text = formatted
                                    cursorPosition = pos + (formatted.length - text.length)
                                }
                                root.transactionAmount = formatted
                            }
                        }

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

            // Method Input
            Rectangle {
                id: dropdown_5
                x: 255
                y: 76
                height: 66
                width: 225
                color: "transparent"

                Text {
                    id: methodLabel
                    height: 32
                    width: 226
                    color: "#878787"
                    font.family: "Intel One Mono"
                    font.pixelSize: 20
                    font.weight: Font.DemiBold
                    horizontalAlignment: Text.AlignLeft
                    lineHeight: 32
                    lineHeightMode: Text.FixedHeight
                    text: "Method"
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
                    border.color: (root.isValidating && root.transactionMethod.trim() === "") ? "red" : "transparent"
                    border.width: (root.isValidating && root.transactionMethod.trim() === "") ? 1 : 0

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
                        text: root.transactionMethod
                        onTextChanged: root.transactionMethod = text

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
        }

        // 4. Transaction Date Field
        Rectangle {
            id: dueDate
            y: 341
            height: 74
            width: 500
            color: "transparent"

            Text {
                id: transaction_Date
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
                text: "Transaction Date"
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
                border.color: (root.isValidating && date_Input_Field.selectedDate.trim() === "") ? "red" : "transparent"
                border.width: (root.isValidating && date_Input_Field.selectedDate.trim() === "") ? 1 : 0
            }
        }

        // 5. Footer Action Buttons
        Image {
            id: choice
            y: 440
            source: Qt.resolvedUrl("../../assets/choice_5.png")

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
                buttonText: root.isEditMode ? "Save" : "Add"
                height: 35
                width: 75
                _state: UniversalButton_1.State_1.State_1_selected

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        root.isValidating = true
                        if (root.transactionTitle.trim() === "" || root.transactionAmount.trim() === "" || root.transactionMethod.trim() === "" || root.dateField.selectedDate.trim() === "") {
                            return
                        }
                        root.accepted()
                        root.close()
                    }
                }
            }
        }
    }
}