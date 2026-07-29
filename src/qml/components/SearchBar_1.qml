import QtQuick
import QtQuick.Layouts
import QtQuick.Shapes

Rectangle {
    id: searchBar

    // Exposed API Properties
    property string placeholderText: "Search category name"
    property string text: ""

    // Signals
    signal textEdited(string newText)
    signal accepted()

    implicitWidth: 320
    implicitHeight: 40
    width: implicitWidth
    height: implicitHeight

    clip: true
    color: "#f8fafc"
    border.color: "#e2e8f0"
    border.width: 1
    radius: height / 2

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 16
        anchors.rightMargin: 16
        spacing: 8

        // Input Field
        TextInput {
            id: inputField
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter

            color: "#0f172a"
            font.family: "Inter"
            font.pixelSize: 14
            selectByMouse: true
            text: searchBar.text

            onTextChanged: {
                searchBar.text = text
                searchBar.textEdited(text)
            }
            onAccepted: searchBar.accepted()

            Text {
                anchors.fill: parent
                color: "#94a3b8"
                font: parent.font
                verticalAlignment: Text.AlignVCenter
                text: searchBar.placeholderText
                visible: !inputField.text && !inputField.inputMethodComposing
            }
        }

        // Magnifying Glass Icon on Right
        Item {
            Layout.preferredWidth: 20
            Layout.preferredHeight: 20
            Layout.alignment: Qt.AlignVCenter

            Shape {
                anchors.centerIn: parent
                width: 16
                height: 16

                ShapePath {
                    fillColor: "#00000000"
                    strokeColor: "#64748b"
                    strokeWidth: 2

                    PathSvg {
                        path: "M 7 14 C 10.866 14 14 10.866 14 7 C 14 3.134 10.866 0 7 0 C 3.134 0 0 3.134 0 7 C 0 10.866 3.134 14 7 14 Z M 12 12 L 15 15"
                    }
                }
            }
        }
    }
}