import QtQuick
import QtQuick.Layouts

Item {
    id: root

    property string labelText: "Income"
    property color dotColor: "#34c759"
    property color textColor: "#191919"
    property int pixelSize: 14

    implicitWidth: layout.implicitWidth
    implicitHeight: layout.implicitHeight
    width: implicitWidth
    height: implicitHeight

    RowLayout {
        id: layout
        spacing: 8
        anchors.verticalCenter: parent.verticalCenter

        Rectangle {
            id: dot
            width: 10
            height: 10
            radius: 5
            color: root.dotColor
            Layout.alignment: Qt.AlignVCenter
        }

        Text {
            id: labelTextItem
            text: root.labelText
            color: root.textColor
            font.family: "Inter"
            font.pixelSize: root.pixelSize
            font.weight: Font.DemiBold
            verticalAlignment: Text.AlignVCenter
            Layout.alignment: Qt.AlignVCenter
        }
    }
}