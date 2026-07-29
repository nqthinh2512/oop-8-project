import QtQuick
import QtQuick.Shapes

Rectangle {
    id: chevron_right

    property alias _vector_ShapePath0StrokeColor: _vector_ShapePath0.strokeColor
    property alias _vector_ShapePath0StrokeWidth: _vector_ShapePath0.strokeWidth

    height: 16
    width: 16

    clip: true
    color: "transparent"

    Shape {
        id: _vector

        x: 6
        y: 4

        height: 8
        width: 4

        ShapePath {
            id: _vector_ShapePath0

            fillColor: "#00000000"
            fillRule: ShapePath.WindingFill
            strokeColor: "#696969"
            strokeWidth: 1

            PathSvg {
                id: _vector_ShapePath0_PathSvg0

                path: "M 0 8 L 4 4 L 0 0"
            }
        }
    }
}