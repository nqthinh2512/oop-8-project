import QtQuick
import QtQuick.Shapes

Rectangle {
    enum State_1 { State_1_Default, State_1_hover, State_1_selected, State_1_hover_selected}

    id: dropdownItem

    property alias placeholder_1FontPixelSize: placeholder_1.font.pixelSize
    property alias placeholder_1Height: placeholder_1.height
    property alias placeholder_1Width: placeholder_1.width
    property alias placeholder_1X: placeholder_1.x
    property alias placeholder_1Y: placeholder_1.y
    property alias placeholder_1Text: placeholder_1.text

    property int _state: DropdownItem.State_1.State_1_Default

    height: 38.81
    width: 239.73

    clip: true
    color: "#ffffff"

    states: [
        State {
            name: "state=Default"
            when: dropdownItem._state === DropdownItem.State_1.State_1_Default

            PropertyChanges {
                color: "#ffffff"
                target: dropdownItem
            }
            PropertyChanges {
                color: "#222222"
                target: placeholder_1
            }
            PropertyChanges {
                target: check
                visible: false
            }
        },
        State {
            name: "state=hover"
            when: dropdownItem._state === DropdownItem.State_1.State_1_hover

            PropertyChanges {
                color: "#d9d9d9"
                target: dropdownItem
            }
            PropertyChanges {
                color: "#222222"
                target: placeholder_1
            }
            PropertyChanges {
                target: check
                visible: false
            }
        },
        State {
            name: "state=selected"
            when: dropdownItem._state === DropdownItem.State_1.State_1_selected

            PropertyChanges {
                color: "#ffffff"
                target: dropdownItem
            }
            PropertyChanges {
                color: "#0225d4"
                target: placeholder_1
            }
            PropertyChanges {
                target: check
                visible: true
            }
        },
        State {
            name: "state=hover-selected"
            when: dropdownItem._state === DropdownItem.State_1.State_1_hover_selected

            PropertyChanges {
                color: "#d9d9d9"
                target: dropdownItem
            }
            PropertyChanges {
                color: "#0225d4"
                target: placeholder_1
            }
            PropertyChanges {
                target: check
                visible: true
            }
        }
    ]

    Text {
        id: placeholder_1

        x: 14
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width - (check.visible ? 44 : 24)
        height: 20

        color: "#222222"
        font.family: "Inter"
        font.pixelSize: 14
        font.weight: Font.Normal
        horizontalAlignment: Text.AlignLeft
        text: "Placeholder 1"
        textFormat: Text.PlainText
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    Rectangle {
        id: check

        anchors.right: parent.right
        anchors.rightMargin: 12
        anchors.verticalCenter: parent.verticalCenter

        height: 18.27
        width: 18.27

        clip: true
        color: "transparent"

        Shape {
            id: icon

            x: 3.04
            y: 4.57

            height: 8.37
            width: 12.18

            ShapePath {
                id: icon_ShapePath0

                fillColor: "#00000000"
                fillRule: ShapePath.WindingFill
                strokeColor: "#0225d4"
                strokeWidth: 2.85

                PathSvg {
                    id: icon_ShapePath0_PathSvg0

                    path: "M 12.176762580871582 0 L 3.8052383065223694 8.3715238571167 L 0 4.566285740245473"
                }
            }
        }
    }
}