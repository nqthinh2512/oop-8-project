import QtQuick
import QtQuick.Layouts
import src

Rectangle {
    enum Item_1 { Item_1_Overview, Item_1_Transactions, Item_1_Bills, Item_1_Budgets, Item_1_Savings, Item_1_Categories, Item_1_Reports, Item_1_Settings }
    
    id: sidebar_item
    width: 290
    height: 54
    radius: 12 // Bo tròn hiện đại

    property int _item: 0
    property bool isSelected: false
    signal clicked()

    readonly property var itemNames: ["Overview", "Transactions", "Bills", "Budgets", "Savings", "Categories", "Reports", "Settings"]
    
    // Màu chữ & Icon (Xanh dương khi chọn, Xám nhạt khi không chọn)
    readonly property string contentColor: {
        if (isSelected) return AppTheme.primary
        if (mouseArea.containsMouse) return AppTheme.textMain
        return AppTheme.textSub
    }

    // Option A: Background
    color: {
        if (isSelected) return AppTheme.isDark ? Qt.rgba(0.37, 0.65, 0.98, 0.15) : "#eff6ff"
        if (mouseArea.containsMouse) return AppTheme.isDark ? Qt.rgba(1, 1, 1, 0.06) : "#f8fafc"
        return "transparent"
    }

    Behavior on color { ColorAnimation { duration: 150 } }

    function getIconSvg(name, colorStr) {
        let path = "";
        switch(name) {
            case "Overview": path = "M10 20v-6h4v6h5v-8h3L12 3 2 12h3v8z"; break;
            case "Transactions": path = "M3.5 18.49l6-6.01 4 4L22 6.92l-1.41-1.41-7.09 7.97-4-4L2 16.99z"; break;
            case "Bills": path = "M18 17H6v-2h12v2zm0-4H6v-2h12v2zm0-4H6V7h12v2zM3 22l1.5-1.5L6 22l1.5-1.5L9 22l1.5-1.5L12 22l1.5-1.5L15 22l1.5-1.5L18 22l1.5-1.5L21 22V2l-1.5 1.5L18 2l-1.5 1.5L15 2l-1.5 1.5L12 2l-1.5 1.5L9 2 7.5 3.5 6 2 4.5 3.5 3 2v20z"; break;
            case "Budgets": path = "M11 2v20c-5.07-.5-9-4.79-9-10s3.93-9.5 9-10zm2.03 0v8.99H22c-.47-4.74-4.24-8.52-8.97-8.99zm0 11.01V22c4.74-.47 8.5-4.25 8.97-8.99h-8.97z"; break;
            case "Savings": path = "M11.8 10.9c-2.27-.59-3-1.2-3-2.15 0-1.09 1.01-1.85 2.7-1.85 1.78 0 2.44.85 2.5 2.1h2.21c-.07-1.72-1.12-3.3-3.21-3.81V3h-3v2.16c-1.94.42-3.5 1.68-3.5 3.61 0 2.31 1.91 3.46 4.7 4.13 2.5.6 3 1.48 3 2.41 0 .69-.49 1.79-2.7 1.79-2.06 0-2.87-.92-2.98-2.1h-2.2c.12 2.19 1.76 3.42 3.68 3.83V21h3v-2.15c1.95-.37 3.5-1.5 3.5-3.55 0-2.84-2.43-3.81-4.7-4.4z"; break;
            case "Categories": path = "M4 4h6v6H4V4zm0 10h6v6H4v-6zm10 0h6v6h-6v-6zm0-10h6v6h-6V4z"; break;
            case "Reports": path = "M16 6l2.29 2.29-4.88 4.88-4-4L2 16.59 3.41 18l6-6 4 4 6.3-6.29L22 12V6h-6z"; break;
            case "Settings": path = "M19.14,12.94c0.04-0.3,0.06-0.61,0.06-0.94c0-0.32-0.02-0.64-0.06-0.94l2.03-1.58c0.18-0.14,0.23-0.41,0.12-0.61 l-1.92-3.32c-0.12-0.22-0.37-0.29-0.59-0.22l-2.39,0.96c-0.5-0.38-1.03-0.7-1.62-0.94L14.4,2.81c-0.04-0.24-0.24-0.41-0.48-0.41 h-3.84c-0.24,0-0.43,0.17-0.47,0.41L9.25,5.35C8.66,5.59,8.12,5.92,7.63,6.29L5.24,5.33c-0.22-0.08-0.47,0-0.59,0.22L2.73,8.87 C2.62,9.08,2.66,9.34,2.86,9.48l2.03,1.58C4.84,11.36,4.8,11.69,4.8,12s0.02,0.64,0.06,0.94l-2.03,1.58 c-0.18,0.14-0.23,0.41-0.12,0.61l1.92,3.32c0.12,0.22,0.37,0.29,0.59,0.22l2.39-0.96c0.5,0.38,1.03,0.7,1.62,0.94l0.36,2.54 c0.05,0.24,0.24,0.41,0.48,0.41h3.84c0.24,0,0.43-0.17,0.47-0.41l0.36-2.54c0.59-0.24,1.13-0.56,1.62-0.94l2.39,0.96 c0.22,0.08,0.47,0,0.59-0.22l1.92-3.32c0.12-0.22,0.07-0.49-0.12-0.61L19.14,12.94z M12,15.6c-1.98,0-3.6-1.62-3.6-3.6 s1.62-3.6,3.6-3.6s3.6,1.62,3.6,3.6S13.98,15.6,12,15.6z"; break;
        }
        return `data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="24" height="24"><path fill="${colorStr.replace('#','%23')}" d="${path}"/></svg>`;
    }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 24
        spacing: 16

        Image {
            id: iconImage
            Layout.preferredWidth: 24
            Layout.preferredHeight: 24
            source: getIconSvg(itemNames[_item], contentColor)
            fillMode: Image.PreserveAspectFit
        }

        Text {
            text: itemNames[_item]
            color: contentColor
            font.family: "Inter"
            font.pixelSize: 16
            font.weight: isSelected ? Font.DemiBold : Font.Medium
            Layout.fillWidth: true
            verticalAlignment: Text.AlignVCenter
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: sidebar_item.clicked()
    }
}