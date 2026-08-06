import QtQuick
import QtQuick.Controls
import QtQuick.Controls.impl
import QtQuick.Effects
import src

Item {
    enum Item_1 { Item_1_Overview, Item_1_Transactions, Item_1_Bills, Item_1_Budgets, Item_1_Savings, Item_1_Categories, Item_1_Reports, Item_1_Settings }
    
    id: sidebar_item
    width: 290
    height: 54

    property int _item: 0
    property bool isSelected: false
    signal clicked()

    readonly property var itemNames: ["Overview", "Transactions", "Bills", "Budgets", "Savings", "Categories", "Reports", "Settings"]

    readonly property string currentStateName: {
        if (isSelected && !AppTheme.isDark) return "selected"
        if (mouseArea.containsMouse && !AppTheme.isDark) return "hover"
        return "default"
    }

    Rectangle {
        anchors.fill: parent
        anchors.leftMargin: 20
        anchors.rightMargin: 20
        radius: 8
        color: {
            if (isSelected && AppTheme.isDark) return AppTheme.bgHover
            if (mouseArea.containsMouse && AppTheme.isDark) return Qt.rgba(1, 1, 1, 0.06)
            return "transparent"
        }
    }

    Image {
        id: srcImg
        anchors.fill: parent
        source: Qt.resolvedUrl("../../assets/item_" + itemNames[_item] + "_State_" + currentStateName + ".png")
        fillMode: Image.Stretch
        visible: !AppTheme.isDark
    }

    MultiEffect {
        anchors.fill: srcImg
        source: srcImg
        visible: AppTheme.isDark
        colorization: 1.0
        colorizationColor: isSelected ? AppTheme.primary : (mouseArea.containsMouse ? AppTheme.textMain : AppTheme.textSub)
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: sidebar_item.clicked()
    }
}