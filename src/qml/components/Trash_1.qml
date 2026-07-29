import QtQuick
import QtQuick.Shapes

Rectangle {
    enum State_1 { State_1_default, State_1_hover}

    id: trash

    property alias iconHeight: icon.height
    property alias iconWidth: icon.width
    property alias icon_ShapePath0StrokeWidth: icon_ShapePath0.strokeWidth
    property alias icon_ShapePath0_PathSvg0Path: icon_ShapePath0_PathSvg0.path
    property alias icon_ShapePath1StrokeWidth: icon_ShapePath1.strokeWidth
    property alias icon_ShapePath1_PathSvg0Path: icon_ShapePath1_PathSvg0.path

    property int _state: Trash_1.State_1.State_1_default

    height: 15
    width: 15

    color: "transparent"
    radius: 0

    states: [
        State {
            name: "state=default"
            when: trash._state === Trash_1.State_1.State_1_default
    
            PropertyChanges {
                color: "transparent"
                target: trash
            }
            PropertyChanges {
                radius: 0
                target: trash
            }
            PropertyChanges {
                strokeColor: "#1e1e1e"
                target: icon_ShapePath0
            }
            PropertyChanges {
                strokeColor: "#1e1e1e"
                target: icon_ShapePath1
            }
        },
        State {
            name: "state=hover"
            when: trash._state === Trash_1.State_1.State_1_hover
    
            PropertyChanges {
                color: "#40ff5255"
                target: trash
            }
            PropertyChanges {
                radius: 2
                target: trash
            }
            PropertyChanges {
                strokeColor: "#ff5255"
                target: icon_ShapePath0
            }
            PropertyChanges {
                strokeColor: "#ff5255"
                target: icon_ShapePath1
            }
        }
    ]

    Shape {
        id: icon

        height: 15
        width: 15

        ShapePath {
            id: icon_ShapePath0

            fillColor: "#00000000"
            fillRule: ShapePath.WindingFill
            strokeColor: "#1e1e1e"
            strokeWidth: 1.50

            PathSvg {
                id: icon_ShapePath0_PathSvg0

                path: "M 0 3 L 1.6666666666666667 3 L 15 3"
            }
        }
        ShapePath {
            id: icon_ShapePath1

            fillColor: "#00000000"
            fillRule: ShapePath.WindingFill
            strokeColor: "#1e1e1e"
            strokeWidth: 1.50

            PathSvg {
                id: icon_ShapePath1_PathSvg0

                path: "M 13.333333333333334 3 L 13.333333333333334 13.5 C 13.333333333333334 13.897824749350548 13.157738273342451 14.279355324804783 12.84517765045166 14.560659885406494 C 12.53261702756087 14.841964446008205 12.108694165945055 15 11.666666666666668 15 L 3.3333333333333335 15 C 2.891305834054947 15 2.467382575074832 14.841964446008205 2.1548219521840415 14.560659885406494 C 1.842261329293251 14.279355324804783 1.6666666666666674 13.897824749350548 1.6666666666666667 13.5 L 1.6666666666666667 3 M 4.166666666666667 3 L 4.166666666666667 1.5 C 4.166666666666667 1.1021752506494522 4.34226172665755 0.7206443175673485 4.65482234954834 0.4393397569656372 C 4.96738297243913 0.15803519636392593 5.391305834054948 3.3306690738754696e-16 5.833333333333334 0 L 9.166666666666668 0 C 9.608694165945055 3.3306690738754696e-16 10.03261702756087 0.15803519636392593 10.34517765045166 0.4393397569656372 C 10.657738273342451 0.7206443175673485 10.833333333333334 1.1021752506494522 10.833333333333334 1.5 L 10.833333333333334 3"
            }
        }
    }
}