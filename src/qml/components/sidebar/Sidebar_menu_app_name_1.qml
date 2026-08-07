import QtQuick
import QtQuick.Layouts
import src

Item {
    id: sidebar_menu_app_name

    implicitHeight: 60
    implicitWidth: 260

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 24
        spacing: 14

        // Blue circle logo
        Rectangle {
            id: appLogoCircle
            Layout.preferredWidth: 36
            Layout.preferredHeight: 36
            radius: 18
            color: AppTheme.primary // Modern blue or dark mode equivalent
        }

        // Crisp vector text
        Text {
            id: appNameText
            text: "FManagement"
            font.family: "Inter"
            font.pixelSize: 26
            font.weight: Font.ExtraBold
            font.letterSpacing: -0.5
            color: AppTheme.textMain // Dark modern slate or dark mode equivalent
            Layout.fillWidth: true
            verticalAlignment: Text.AlignVCenter
        }
    }
}
