import QtQuick
import QtQuick.Shapes

Rectangle {
    id: _x

    property alias icon_ShapePath0StrokeColor: icon_ShapePath0.strokeColor

    height: 16
    width: 16

    clip: true
    color: "transparent"
    visible: true

    Shape {
        id: icon

        x: 4
        y: 4

        height: 8
        width: 8

        ShapePath {
            id: icon_ShapePath0

            fillColor: "#00000000"
            strokeColor: "#1e1e1e"
            strokeWidth: 1.60

            PathSvg {
                id: icon_ShapePath0_PathSvg0

                path: "M 8 0 L 0 8 M 0 0 L 8 8"
            }
        }
    }
}