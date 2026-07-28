import QtQuick
import QtQuick.Layouts
import QtQuick.Shapes

Rectangle {
    enum State_1 { State_1_default, State_1_hover }

    id: dropdown

    // Exposed API Properties
    property int _state: Dropdown_1.State_1.State_1_default
    property string selectedText: "All Main Categories"
    property alias dropdownBorderWidth: dropdown.border.width

    // Signals
    signal clicked()

    implicitWidth: 200
    implicitHeight: 38
    width: implicitWidth
    height: implicitHeight

    color: "#ffffff"
    radius: 8
    border.color: dropdown._state === Dropdown_1.State_1.State_1_hover ? "#3b82f6" : "#d1d5db"
    border.width: 1
    clip: true

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 14
        anchors.rightMargin: 14
        spacing: 8

        Text {
            id: categories
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter

            font.family: "Inter"
            font.pixelSize: 14
            font.weight: Font.Medium
            color: dropdown._state === Dropdown_1.State_1.State_1_hover ? "#2563eb" : "#4b5563"
            text: dropdown.selectedText
            elide: Text.ElideRight
        }

        // Chevron Down Icon
        Item {
            Layout.preferredWidth: 12
            Layout.preferredHeight: 8
            Layout.alignment: Qt.AlignVCenter

            Shape {
                anchors.centerIn: parent
                width: 10
                height: 6

                ShapePath {
                    fillColor: "#00000000"
                    strokeColor: dropdown._state === Dropdown_1.State_1.State_1_hover ? "#2563eb" : "#64748b"
                    strokeWidth: 1.8

                    PathSvg {
                        path: "M 0 0 L 5 5 L 10 0"
                    }
                }
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onEntered: dropdown._state = Dropdown_1.State_1.State_1_hover
        onExited: dropdown._state = Dropdown_1.State_1.State_1_default
        onClicked: dropdown.clicked()
    }
}