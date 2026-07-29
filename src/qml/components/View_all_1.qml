import QtQuick
import QtQuick.Layouts

Item {
    id: root

    implicitWidth: contentRow.implicitWidth
    implicitHeight: contentRow.implicitHeight
    width: implicitWidth
    height: implicitHeight

    property string buttonText: "View All"
    property color textColor: "#878787"
    property color hoverColor: "#5186f8"

    signal clicked()

    RowLayout {
        id: contentRow
        anchors.verticalCenter: parent.verticalCenter
        spacing: 4

        Text {
            font.family: "Inter"
            font.pixelSize: 13
            font.weight: Font.Medium
            color: mouseArea.containsMouse ? root.hoverColor : root.textColor
            text: root.buttonText
            verticalAlignment: Text.AlignVCenter
        }

        Chevron_right_2 {
            id: chevron
            Layout.alignment: Qt.AlignVCenter
            _vector_ShapePath0StrokeColor: mouseArea.containsMouse ? root.hoverColor : root.textColor
            _vector_ShapePath0StrokeWidth: 1.50
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }
}