import QtQuick
import QtQuick.Controls
import QtQuick.Controls.impl
import src
import QtQuick.Layouts

Item {
    enum Type { Type_income, Type_expense, Type_bill }

    id: root

    // Automatically match the parent container's width
    implicitWidth: parent ? parent.width : 400
    implicitHeight: 52
    Layout.fillWidth: true

    // Exposed Data Properties
    property int type_1: Overview_item_1.Type.Type_income
    property string itemTitle: "Name"
    property string categoryText: "Category"
    property string amountText: "$0.00"
    property string dateText: "Date"
    property bool showUnderline: true
    property bool showIcon: false
    property url iconSource: ""

    // Visual Configuration map based on item type
    readonly property var typeConfig: {
        if (type_1 === Overview_item_1.Type.Type_income) {
            return {
                amountColor: AppTheme.success,
                dateColor: "#9ca3af",
                dateWeight: Font.Normal
            }
        } else if (type_1 === Overview_item_1.Type.Type_expense) {
            return {
                amountColor: AppTheme.danger,
                dateColor: "#9ca3af",
                dateWeight: Font.Normal
            }
        }
        return {
            amountColor: AppTheme.textMain,
            dateColor: "#8c7653",
            dateWeight: Font.DemiBold
        }
    }

    // -------------------------------------------------------------------------
    // MAIN ITEM CONTENT
    // -------------------------------------------------------------------------
    RowLayout {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: underline.top
        spacing: 12

        Rectangle {
            anchors.fill: parent

            color: hoverHandler.hovered ? AppTheme.bgHover : AppTheme.bgCard
            Behavior on color {
                ColorAnimation { duration: 150 }
            }

            HoverHandler {
                id: hoverHandler
                // cursorShape: Qt.PointingHandCursor
            }

            z: -1
        }

        // Optional Icon
        ColorImage {
            color: AppTheme.textMain
            visible: root.showIcon && root.iconSource.toString() !== ""
            source: root.iconSource
            Layout.preferredWidth: 36
            Layout.preferredHeight: 36
            fillMode: Image.PreserveAspectFit
            Layout.alignment: Qt.AlignVCenter
        }

        // Left Details (Title & Category)
        ColumnLayout {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter
            spacing: 2

            Text {
                font.family: "Inter"
                font.pixelSize: 15
                font.weight: Font.Bold
                color: AppTheme.textMain
                text: root.itemTitle
                elide: Text.ElideRight
                Layout.fillWidth: true
            }

            Text {
                font.family: "Inter"
                font.pixelSize: 12
                font.weight: Font.Normal
                color: "#9ca3af"
                text: root.categoryText
                elide: Text.ElideRight
                Layout.fillWidth: true
            }
        }

        // Right Price & Date
        ColumnLayout {
            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
            spacing: 2

            Text {
                font.family: "Inter"
                font.pixelSize: 15
                font.weight: Font.Bold
                color: root.typeConfig.amountColor
                horizontalAlignment: Text.AlignRight
                text: root.amountText
                Layout.alignment: Qt.AlignRight
            }

            Text {
                font.family: "Inter"
                font.pixelSize: 12
                font.weight: root.typeConfig.dateWeight
                color: root.typeConfig.dateColor
                horizontalAlignment: Text.AlignRight
                text: root.dateText
                Layout.alignment: Qt.AlignRight
            }
        }
    }

    // Underline Separator
    Rectangle {
        id: underline
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: 1
        color: "#f3f4f6"
        visible: root.showUnderline
    }
}
