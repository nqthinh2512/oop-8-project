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
    property int targetModuleIndex: 0 // 0: None, 1: Budgets, 2: Savings
    property int linkedBillId: -1
    property int linkedSavingId: -1
    property int linkedBudgetId: -1

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
        targetModuleIndex = 0;
        linkedSavingId = -1;
        linkedBudgetId = -1;
        if (typeof dropdown_target_module !== "undefined" && dropdown_target_module) {
            dropdown_target_module.selectedIndex = 0;
            dropdown_target_module.selectedText = "None";
        }
        if (typeof dropdown_target_item !== "undefined" && dropdown_target_item) {
            dropdown_target_item.selectedIndex = -1;
            dropdown_target_item.selectedText = "Select Target";
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

        // 3.5 Link Target Page Row (Hub Architecture)
        Rectangle {
            id: linkRowContainer
            y: 330
            height: 74
            width: 500
            color: "transparent"
            visible: root.transactionTypeIndex !== -1 && !root.isEditMode
            z: 3

            // 1st Dropdown: Target Page
            Rectangle {
                id: targetPageBox
                x: 20
                height: 66
                width: 225
                color: "transparent"
                z: 4

                Text {
                    height: 32
                    width: 226
                    color: AppTheme.textSub
                    font.family: "Intel One Mono"
                    font.pixelSize: 20
                    font.weight: Font.DemiBold
                    text: "Target Page"
                    verticalAlignment: Text.AlignTop
                }

                Dropdown_1 {
                    id: dropdown_target_module
                    y: 32
                    height: 34
                    width: 225
                    model: ["None", "Budgets", "Savings"]
                    selectedText: root.targetModuleIndex === 1 ? "Budgets" : root.targetModuleIndex === 2 ? "Savings" : "None"
                    selectedIndex: root.targetModuleIndex
                    
                    onSelected: function(index, value) {
                        root.targetModuleIndex = index;
                        root.linkedBudgetId = -1;
                        root.linkedSavingId = -1;
                        if (typeof dropdown_target_item !== "undefined" && dropdown_target_item) {
                            dropdown_target_item.selectedIndex = -1;
                            dropdown_target_item.selectedText = (index === 1) ? "Select Budget" : (index === 2) ? "Select Saving Goal" : "Select Target";
                        }
                    }
                }
            }

            // 2nd Dropdown: Target Item (Appears when Budgets or Savings is selected)
            Rectangle {
                id: targetItemBox
                x: 255
                height: 66
                width: 225
                color: "transparent"
                visible: root.targetModuleIndex > 0
                z: 4

                Text {
                    height: 32
                    width: 226
                    color: AppTheme.textSub
                    font.family: "Intel One Mono"
                    font.pixelSize: 20
                    font.weight: Font.DemiBold
                    text: root.targetModuleIndex === 1 ? "Select Budget" : "Select Saving Goal"
                    verticalAlignment: Text.AlignTop
                }

                Dropdown_1 {
                    id: dropdown_target_item
                    y: 32
                    height: 34
                    width: 225
                    
                    property var bList: (typeof budgetsController !== "undefined" && budgetsController && budgetsController.budgetsList) ? budgetsController.budgetsList : []
                    property var sList: (typeof savingsController !== "undefined" && savingsController && savingsController.savingsList) ? savingsController.savingsList : []
                    
                    model: {
                        if (root.targetModuleIndex === 1) {
                            return bList.map(function(b) { return b.name; });
                        } else if (root.targetModuleIndex === 2) {
                            return sList.map(function(s) { return s.name; });
                        }
                        return [];
                    }
                    
                    selectedText: {
                        if (root.targetModuleIndex === 1) return "Select Budget";
                        if (root.targetModuleIndex === 2) return "Select Saving Goal";
                        return "Select Target";
                    }
                    
                    onSelected: function(index, value) {
                        if (root.targetModuleIndex === 1) {
                            if (index >= 0 && index < bList.length) {
                                root.linkedBudgetId = bList[index].id;
                                if (!root.transactionTitle) {
                                    root.transactionTitle = "Expense for " + bList[index].name;
                                    if (typeof textField !== "undefined" && textField) textField.text = root.transactionTitle;
                                }
                            }
                        } else if (root.targetModuleIndex === 2) {
                            if (index >= 0 && index < sList.length) {
                                root.linkedSavingId = sList[index].id;
                                if (!root.transactionTitle) {
                                    root.transactionTitle = (root.transactionTypeIndex === 0 ? "Deposit to " : "Withdraw from ") + sList[index].name;
                                    if (typeof textField !== "undefined" && textField) textField.text = root.transactionTitle;
                                }
                            }
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
