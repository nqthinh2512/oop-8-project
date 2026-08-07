import QtQuick
import QtQuick.Controls
import QtQuick.Controls.impl
import src
import QtQuick.Layouts

Item {
    id: sidebar_menu_app_name

    implicitHeight: 30
    implicitWidth: 60

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 8
        spacing: 12

        ColorImage {
        color: AppTheme.textMain
            id: ellipse_1
            source: Qt.resolvedUrl("../../assets/ellipse_1.png")
            fillMode: Image.PreserveAspectFit
            Layout.alignment: Qt.AlignVCenter
        }

        ColorImage {
        color: AppTheme.textMain
            id: fManagement
            source: Qt.resolvedUrl("../../assets/fManagement.png")
            fillMode: Image.PreserveAspectFit
            Layout.alignment: Qt.AlignVCenter
            Layout.fillWidth: true
        }
    }
}
