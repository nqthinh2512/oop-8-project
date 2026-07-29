import QtQuick
import QtQuick.Shapes

Rectangle {
    id: chevron_down

    height: 16
    width: 16

    clip: true
    color: "transparent"

    Shape {
        id: icon

        x: 4
        y: 6

        height: 4
        width: 8

        ShapePath {
            id: icon_ShapePath0

            fillColor: "#00000000"
            fillRule: ShapePath.WindingFill
            strokeColor: "#1e1e1e"
            strokeWidth: 1.60

            PathSvg {
                id: icon_ShapePath0_PathSvg0

                path: "M 0 0 L 4 4 L 8 0"
            }
        }
    }
}