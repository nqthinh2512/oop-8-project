import QtQuick

Rectangle {
    id: frame_133543

    height: 108
    width: 1360

    color: "transparent"

    Text {
        id: profile_settings

        height: 108
        width: 276

        color: "#000000"
        font.family: "Inter"
        font.pixelSize: 20
        font.weight: Font.Bold
        horizontalAlignment: Text.AlignHCenter
        text: "Profile & settings"
        textFormat: Text.PlainText
        verticalAlignment: Text.AlignVCenter
        wrapMode: Text.Wrap
    }
    UniversalButton_1 {
        id: universalButton

        x: 1127
        y: 31.50

        height: 45
        width: 149

        _state: UniversalButton_1.State_1.State_1_selected
    }
}