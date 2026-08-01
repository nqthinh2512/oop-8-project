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
    property int billId: -1
    property string billTitle: ""
    property string billAmount: ""
    property int billCategoryId: 0
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
        var list = allCats.filter(function(c) { return c.parentId === 3; });
        for (var i = 0; i < list.length; i++) {
            if (list[i].name === catName) {
                dropdown_2.selectedIndex = i;
                dropdown_2.selectedText = catName;
                billCategoryId = list[i].id;
                return;
            }
        }
        if (list.length > 0) {
            dropdown_2.selectedIndex = 0;
            dropdown_2.selectedText = list[0].name;
            billCategoryId = list[0].id;
        }
    }

    function open() { visible = true }
    function close() { visible = false }

    function reset() {
        isEditMode = false;
        billId = -1;
        billTitle = "";
        billAmount = "";
        isValidating = false;
        dateField.clear();
        
        var allCats = categoriesController.categoriesList;
        var list = allCats.filter(function(c) { return c.parentId === 3; });
        if (list.length > 0) {
            dropdown_2.selectedIndex = 0;
            dropdown_2.selectedText = list[0].name;
            billCategoryId = list[0].id;
        } else {
            billCategoryId = 0;
            dropdown_2.selectedText = "Select Category";
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
        id: billDialog
        anchors.centerIn: parent

        height: 417
        width: 500

        color: "#ffffff"
        radius: 15
        clip: true

        // Absorb clicks inside the card so they don't reach the dimmed overlay
        MouseArea { anchors.fill: parent }

        Image {
            id: title
            source: Qt.resolvedUrl("../../assets/title_13.png")

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
                text: root.isEditMode ? "Edit Bill" : "Add Bill"
                textFormat: Text.PlainText
                verticalAlignment: Text.AlignTop
                wrapMode: Text.Wrap
            }
        }

        // 2. Bill Title Input
        Rectangle {
            id: titleInput
            y: 75
            height: 74
            width: 500
            color: "transparent"

            Text {
                id: bill_Title
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
                text: "Bill Title"
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
                border.color: (root.isValidating && root.billTitle.trim() === "") ? "red" : "transparent"
                border.width: (root.isValidating && root.billTitle.trim() === "") ? 1 : 0

                TextInput {
                    id: titleField
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
                    text: root.billTitle
                    onTextChanged: root.billTitle = text

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

        // 3. Amount & Categories Row
        Rectangle {
            id: rowContainer
            y: 174
            height: 66
            width: 500
            color: "transparent"

            // Amount Input
            Rectangle {
                id: dropdown
                x: 20
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
                    border.color: (root.isValidating && root.billAmount.trim() === "") ? "red" : "transparent"
                    border.width: (root.isValidating && root.billAmount.trim() === "") ? 1 : 0

                    TextInput {
                        id: amountField
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
                        text: root.billAmount
                        onTextChanged: {
                            if (activeFocus) {
                                var raw = text.replace(/[^0-9]/g, "")
                                var formatted = raw.replace(/\B(?=(\d{3})+(?!\d))/g, ",")
                                if (text !== formatted) {
                                    var pos = cursorPosition
                                    text = formatted
                                    cursorPosition = pos + (formatted.length - text.length)
                                }
                                root.billAmount = formatted
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

            // Categories Dropdown
            Rectangle {
                id: dropdown_1
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
                    id: dropdown_2
                    y: 32
                    height: 34
                    width: 225
                    _state: Dropdown_1.State_1.State_1_default
                    clip: true
                    
                    property var allCats: categoriesController.categoriesList
                    property var catList: allCats.filter(function(c) { return c.parentId === 3; })
                    model: catList.map(function(c) { return c.name; })
                    selectedText: catList.length > 0 ? catList[0].name : "Select Category"
                    
                    onSelected: function(index, value) {
                        if (index >= 0 && index < catList.length) {
                            root.billCategoryId = catList[index].id
                        }
                    }
                }
            }
        }

        // 4. Due Date Field
        Rectangle {
            id: dueDate
            y: 265
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
            y: 364
            source: Qt.resolvedUrl("../../assets/choice_4.png")

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
                buttonText: "Add"
                height: 35
                width: 75
                _state: UniversalButton_1.State_1.State_1_selected

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        root.isValidating = true
                        if (root.billTitle.trim() === "" || root.billAmount.trim() === "" || root.dateField.selectedDate.trim() === "") {
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