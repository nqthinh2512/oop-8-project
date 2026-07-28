import QtQuick
import QtQuick.Layouts

Item {
    id: sidebar_menu_app_name

    implicitHeight: 60
    Layout.fillWidth: true

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 8
        spacing: 12

        Image {
            id: ellipse_1
            source: Qt.resolvedUrl("../../assets/ellipse_1.png")
            fillMode: Image.PreserveAspectFit
            Layout.alignment: Qt.AlignVCenter
        }

        Image {
            id: fManagement
            source: Qt.resolvedUrl("../../assets/fManagement.png")
            fillMode: Image.PreserveAspectFit
            Layout.alignment: Qt.AlignVCenter
            Layout.fillWidth: true
        }
    }
}