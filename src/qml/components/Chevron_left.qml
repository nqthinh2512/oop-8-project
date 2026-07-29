import QtQuick
import QtQuick.Shapes

Rectangle {
    id: chevron_left

    height: 20
    width: 20

    clip: true
    color: "transparent"

    Shape {
        id: icon

        x: 7.50
        y: 5

        height: 10
        width: 5

        ShapePath {
            id: icon_ShapePath0

            fillColor: "#00000000"
            fillRule: ShapePath.WindingFill
            strokeColor: "#1e1e1e"
            strokeWidth: 2

            PathSvg {
                id: icon_ShapePath0_PathSvg0

                path: "M 5 10 L 0 5 L 5 0"
            }
        }
    }
}