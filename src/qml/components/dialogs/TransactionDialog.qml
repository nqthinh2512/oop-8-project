import QtQuick
import QtQuick.Controls
import QtQuick.Controls.impl
import src
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
    
    property var allBills: []
    
    // Hub Architecture Properties
    property int linkedBillId: -1
    property int linkedSavingId: -1

    function setDateStr(dateStr) {
        var parts = dateStr.split("/");
        if (parts.length === 3) {
            date_Input_Field.setDate(parseInt(parts[0]), parseInt(parts[1]), parseInt(parts[2]));
        }
    }

    function setCategoryName(catName) {
        var allCats = categoriesController.categoriesList;
        var targetParent = root.transactionTypeIndex + 1; // 1 for Income, 2 for Expense
        var list = allCats.filter(function(c) { return c.parentId === targetParent; });
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
        } else {
            dropdown_3.selectedIndex = -1;
            dropdown_3.selectedText = "Select Category";
            transactionCategoryId = 0;
        }
    }

    function setFieldsForEdit(title, amount, method) {
        transactionTitle = title;
        transactionAmount = amount;
        transactionMethod = method;
        if (typeof textField !== "undefined" && textField) textField.text = title;
        if (typeof supporting_text !== "undefined" && supporting_text) supporting_text.text = amount;
        
        if (typeof dropdown_method !== "undefined" && dropdown_method) {
            dropdown_method.selectedText = method;
            var methods = ["Cash", "Bank Transfer", "Credit Card", "Bill Payment", "Saving Payment", "Budget", "Other"];
            dropdown_method.selectedIndex = methods.indexOf(method);
        }
    }

    function open() {
        if (typeof billsController !== "undefined" && billsController) {
            allBills = billsController.getAllBills();
        }
        visible = true 
    }
    function close() { visible = false }

    function reset() {
        isEditMode = false;
        transactionId = -1;
        transactionTitle = "";
        transactionAmount = "";
        transactionMethod = "";
        transactionTypeIndex = -1;
        transactionTypeText = "Select Type";
        isValidating = false;
        if (dateField) dateField.clear();
        
        transactionCategoryId = 0;
        dropdown_3.selectedIndex = -1;
        dropdown_3.selectedText = "Select Category";
        
        linkedBillId = -1;
        linkedSavingId = -1;
        if (typeof dropdown_bill !== "undefined" && dropdown_bill) {
            dropdown_bill.selectedIndex = -1;
            dropdown_bill.selectedText = "Select Bill to Pay";
        }
        if (typeof dropdown_saving !== "undefined" && dropdown_saving) {
            dropdown_saving.selectedIndex = -1;
            dropdown_saving.selectedText = "Select Saving to Add";
        }

        if (typeof textField !== "undefined" && textField) textField.text = "";
        if (typeof supporting_text !== "undefined" && supporting_text) supporting_text.text = "";
        if (typeof dropdown_method !== "undefined" && dropdown_method) {
            dropdown_method.selectedIndex = -1;
            dropdown_method.selectedText = "Select Method";
        }
    }

    // Dimmed background overlay
    Rectangle {
        anchors.fill: parent
        color: "#CC000000" // 80% opacity for darker background

        MouseArea {
            anchors.fill: parent
            onClicked: {
                root.reset()
                root.close()
            }
        }
    }

    // Centered Dialog Card
    Rectangle {
        id: transactionDialog
        anchors.centerIn: parent

        height: 580
        width: 500

        color: AppTheme.bgCard
        radius: 15
        clip: true

        // Absorb clicks inside the card so they don't reach the dimmed overlay
        MouseArea { anchors.fill: parent }

        // 1. Title Header
        ColorImage {
        color: AppTheme.textMain
            id: title
            source: Qt.resolvedUrl("../../assets/title_14.png")

            Text {
                id: title_1
                x: 20
                y: 9
                height: 32
                width: 461
                color: AppTheme.textMain
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
                color: AppTheme.textSub
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
                color: AppTheme.bgInput
                radius: 8
                border.color: (root.isValidating && root.transactionTitle.trim() === "") ? AppTheme.danger : AppTheme.border
                border.width: 1

                TextInput {
                    id: textField
                    anchors.fill: parent
                    anchors.leftMargin: 15
                    anchors.rightMargin: 15
                    verticalAlignment: Text.AlignVCenter
                    color: AppTheme.textMain
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
                z: 2

                Text {
                    id: type
                    height: 32
                    width: 226
                    color: AppTheme.textSub
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
                    model: ["Income", "Expense"]
                    selectedText: root.isEditMode ? transactionTypeText : "Select Type"
                    selectedIndex: root.isEditMode ? transactionTypeIndex : -1
                    onSelected: function(index, value) {
                        if (!root.isEditMode) {
                            root.transactionCategoryId = 0
                            dropdown_3.selectedIndex = -1
                            dropdown_3.selectedText = "Select Category"
                        }
                    }
                }
            }

            // Categories Dropdown
            Rectangle {
                id: dropdown_2
                x: 255
                height: 66
                width: 225
                color: "transparent"
                z: 2

                Text {
                    id: categories
                    height: 32
                    width: 226
                    color: AppTheme.textSub
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
                    
                    enabled: root.transactionTypeIndex !== -1
                    opacity: enabled ? 1.0 : 0.5
                    
                    property var allCats: categoriesController.categoriesList
                    property var catList: {
                        if (root.transactionTypeIndex === -1) return [];
                        var targetParent = root.transactionTypeIndex + 1; // 1 for Income, 2 for Expense
                        return allCats.filter(function(c) { return c.parentId === targetParent; })
                    }
                    model: catList.map(function(c) { return c.name; })
                    
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
                    color: AppTheme.textSub
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
                    color: AppTheme.bgInput
                    radius: 8
                    
                    property bool isAmountInvalid: {
                        if (!root.isValidating) return false;
                        if (root.transactionAmount.trim() === "") return true;
                        var val = parseFloat(root.transactionAmount.replace(/,/g, "")) || 0;
                        return val === 0 || val % 1000 !== 0;
                    }
                    border.color: isAmountInvalid ? AppTheme.danger : AppTheme.border
                    border.width: 1

                    TextInput {
                        id: supporting_text
                        anchors.fill: parent
                        anchors.leftMargin: 15
                        anchors.rightMargin: 15
                        verticalAlignment: Text.AlignVCenter
                        color: AppTheme.textMain
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
                
                Text {
                    anchors.top: inputBox_1.bottom
                    anchors.topMargin: 2
                    anchors.right: inputBox_1.right
                    text: "Must be multiple of 1,000"
                    color: AppTheme.danger
                    font.pixelSize: 10
                    visible: inputBox_1.isAmountInvalid && root.transactionAmount.trim() !== ""
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
                    color: AppTheme.textSub
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

                Dropdown_1 {
                    id: dropdown_method
                    y: 32
                    height: 34
                    width: 225
                    model: ["Cash", "Bank Transfer", "Credit Card", "Bill Payment", "Saving Payment", "Budget", "Other"]
                    selectedText: root.transactionMethod === "" ? "Select Method" : root.transactionMethod
                    onSelected: function(index, value) {
                        root.transactionMethod = value;
                    }
                }
            }
        }

        // 3.5 Link To Row (Hub Architecture)
        Rectangle {
            id: linkRowContainer
            y: 330
            height: 74
            width: 500
            color: "transparent"
            visible: root.transactionTypeIndex !== -1 && !root.isEditMode // Only show on Add, to keep it simple, or allow edit? Let's allow edit if we want full hub, but keep it simple for now. Actually, if we allow edit, it's very complex. Let's just allow linking on creation for now, or allow edit but with caution. Let's show it always.
            
            // Link to Bill (Expense only)
            Rectangle {
                x: 20
                height: 66
                width: 225
                color: "transparent"
                visible: root.transactionTypeIndex === 1 // Expense
                z: 1

                Text {
                    height: 32
                    width: 226
                    color: AppTheme.textSub
                    font.family: "Intel One Mono"
                    font.pixelSize: 20
                    font.weight: Font.DemiBold
                    text: "Link to Bill"
                    verticalAlignment: Text.AlignTop
                }

                Dropdown_1 {
                    id: dropdown_bill
                    y: 32
                    height: 34
                    width: 225
                    
                    property var unpaidBills: {
                        if (!root.allBills) return [];
                        return root.allBills.filter(function(b) { return !b.paid; })
                    }
                    model: ["None"].concat(unpaidBills.map(function(b) { return b.name; }))
                    selectedText: "Select Bill to Pay"
                    
                    onSelected: function(index, value) {
                        if (index === 0) {
                            root.linkedBillId = -1;
                        } else if (index > 0 && index <= unpaidBills.length) {
                            root.linkedBillId = unpaidBills[index-1].id;
                            // Auto-fill amount and title
                            root.transactionAmount = unpaidBills[index-1].amount.toString();
                            root.transactionTitle = unpaidBills[index-1].name;
                            root.transactionCategoryId = unpaidBills[index-1].categoryId;
                            root.setCategoryName(categoriesController.getCategoryName(unpaidBills[index-1].categoryId));
                        }
                    }
                }
            }
            
            // Link to Saving
            Rectangle {
                x: 255
                height: 66
                width: 225
                color: "transparent"
                visible: root.transactionTypeIndex !== -1
                z: 1

                Text {
                    height: 32
                    width: 226
                    color: AppTheme.textSub
                    font.family: "Intel One Mono"
                    font.pixelSize: 20
                    font.weight: Font.DemiBold
                    text: "Link to Saving"
                    verticalAlignment: Text.AlignTop
                }

                Dropdown_1 {
                    id: dropdown_saving
                    y: 32
                    height: 34
                    width: 225
                    
                    property var allSavings: savingsController.savingsList
                    property var activeSavings: {
                        if (!allSavings) return [];
                        return allSavings;
                    }
                    model: ["None"].concat(activeSavings.map(function(s) { return s.name; }))
                    selectedText: "Select Saving to Add"
                    
                    onSelected: function(index, value) {
                        if (index === 0) {
                            root.linkedSavingId = -1;
                        } else if (index > 0 && index <= activeSavings.length) {
                            root.linkedSavingId = activeSavings[index-1].id;
                            root.transactionTitle = (root.transactionTypeIndex === 1 ? "Deposit to " : "Withdraw from ") + activeSavings[index-1].name;
                        }
                    }
                }
            }
        }

        // 4. Transaction Date Field
        Rectangle {
            id: dueDate
            y: 421
            height: 74
            width: 500
            color: "transparent"

            Text {
                id: transaction_Date
                x: 20
                height: 32
                width: 461
                color: AppTheme.textSub
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
                showValidationError: (root.isValidating && date_Input_Field.selectedDate.trim() === "")
            }
        }

        // 5. Footer Action Buttons
        ColorImage {
        color: AppTheme.textMain
            id: choice
            y: 520
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
                        root.reset()
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
                        
                        var amtVal = parseFloat(root.transactionAmount.replace(/,/g, "")) || 0;
                        
                        if (root.transactionTitle.trim() === "" || 
                            root.transactionAmount.trim() === "" || 
                            amtVal === 0 || 
                            amtVal % 1000 !== 0 ||
                            root.transactionMethod.trim() === "" || 
                            root.dateField.selectedDate.trim() === "" || 
                            root.transactionCategoryId === 0 || 
                            root.transactionTypeIndex === -1) {
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
