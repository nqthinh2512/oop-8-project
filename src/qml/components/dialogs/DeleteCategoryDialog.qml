import QtQuick
import ".."

Item {
    id: root
    anchors.fill: parent
    visible: false
    z: 999

    signal accepted(int targetCategoryId)
    signal deactivateRequested()
    signal rejected()

    property int deletingCategoryId: -1
    property var targetCategoryIds: [0]
    property alias migrationDropdown: dropdown_1

    function openWithCategory(catId, catName) {
        if (catName.length >= 50) catName = catName.slice(0,49) + ".."
        deletingCategoryId = catId
        label.text = "Choose category to move items from \"" + catName + "\" to:"

        var names = ["Uncategorized (Default)"]
        var ids = [0]
        var targetParentId = 0

        // Fetch candidate categories from controller belonging to the SAME main parent category group
        if (typeof categoriesController !== "undefined" && categoriesController.categoriesList) {
            var list = categoriesController.categoriesList
            for (var j = 0; j < list.length; j++) {
                if (list[j].id === catId) {
                    targetParentId = list[j].parentId
                    break
                }
            }

            for (var i = 0; i < list.length; i++) {
                var cat = list[i]
                if (cat.id !== catId && (targetParentId === 0 || cat.parentId === targetParentId)) {
                    names.push(cat.name)
                    ids.push(cat.id)
                }
            }
        }

        targetCategoryIds = ids
        dropdown_1.model = names
        dropdown_1.selectedText = names[0]
        dropdown_1.selectedIndex = 0
        visible = true
    }

    function open() { visible = true }
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
        id: deleteCategoryDialog
        anchors.centerIn: parent

        height: 260
        width: 520

        color: "#ffffff"
        radius: 15
        clip: false

        // Absorb clicks inside the card so they don't reach the dimmed overlay
        MouseArea { anchors.fill: parent }

        // 1. Header Title
        Image {
            id: title
            source: Qt.resolvedUrl("../../assets/title_10.png")

            Text {
                id: title_1
                x: 20
                y: 9
                height: 32
                width: 480
                color: "#191919"
                font.family: "Intel One Mono"
                font.pixelSize: 24
                font.weight: Font.DemiBold
                horizontalAlignment: Text.AlignLeft
                lineHeight: 32
                lineHeightMode: Text.FixedHeight
                text: "Deleting Category"
                textFormat: Text.PlainText
                verticalAlignment: Text.AlignTop
                wrapMode: Text.Wrap
            }
        }

        // 2. Category Migration Dropdown Field
        Rectangle {
            id: dropdown
            y: 75
            height: 98
            width: 520
            color: "transparent"

            Text {
                id: label
                x: 20
                height: 64
                width: 480
                color: "#878787"
                font.family: "Intel One Mono"
                font.pixelSize: 16
                font.weight: Font.DemiBold
                horizontalAlignment: Text.AlignLeft
                lineHeight: 24
                lineHeightMode: Text.FixedHeight
                text: "Choose the category you wish to move items to:"
                textFormat: Text.PlainText
                verticalAlignment: Text.AlignTop
                wrapMode: Text.Wrap
            }

            Dropdown_1 {
                id: dropdown_1
                x: 20
                y: 56
                height: 36
                width: 480
                model: ["Uncategorized (Default)"]
                selectedText: "Uncategorized (Default)"
                selectedIndex: 0
                z: 10
            }
        }

        // 3. Footer Action Buttons
        Image {
            id: choice
            y: 205
            source: Qt.resolvedUrl("../../assets/choice_1.png")

            // Deactivate Instead Button
            UniversalButton_1 {
                id: deactivateButton
                x: 185
                y: 9
                height: 35
                width: 140
                buttonText: "Deactivate Only"
                _state: UniversalButton_1.State_1.State_1_default

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        root.deactivateRequested()
                        root.close()
                    }
                }
            }

            // Cancel Button
            UniversalButton_1 {
                id: cancelButton
                x: 100
                y: 9
                height: 35
                width: 75
                buttonText: "Cancel"
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

            // Move & Delete Button
            UniversalButton_1 {
                id: saveButton
                x: 335
                y: 9
                height: 35
                width: 165
                buttonText: "Move & Delete"
                _state: UniversalButton_1.State_1.State_1_selected
                color: "#f85154"

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        var targetId = 0
                        if (dropdown_1.selectedIndex >= 0 && dropdown_1.selectedIndex < targetCategoryIds.length) {
                            targetId = targetCategoryIds[dropdown_1.selectedIndex]
                        }
                        root.accepted(targetId)
                        root.close()
                    }
                }
            }
        }
    }
}