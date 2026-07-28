import QtQuick

Image {
    enum Item_1 { Item_1_Overview, Item_1_Transactions, Item_1_Bills, Item_1_Budgets, Item_1_Savings, Item_1_Categories, Item_1_Reports, Item_1_Settings }
    enum State_1 { State_1_default, State_1_hover, State_1_selected }

    id: sidebar_item

    width: 290
    height: 54

    property int _item: 0
    property bool isSelected: false

    // Signal emitted when user clicks this item
    signal clicked()

    readonly property var itemNames: ["Overview", "Transactions", "Bills", "Budgets", "Savings", "Categories", "Reports", "Settings"]

    // Automatically determine state based on selection or hover
    readonly property string currentStateName: {
        if (isSelected) return "selected"
        if (mouseArea.containsMouse) return "hover"
        return "default"
    }

    // Dynamic asset path binding - 1:1 crisp pixel rendering
    source: Qt.resolvedUrl(`../../assets/item_${itemNames[_item]}_State_${currentStateName}.png`)
    fillMode: Image.Stretch

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: sidebar_item.clicked()
    }
}