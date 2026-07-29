import QtQuick
import QtQuick.Shapes

Rectangle {
    id: edit

    property alias _vectorWidth: _vector.width
    property alias _vectorX: _vector.x
    property alias _vectorY: _vector.y
    property alias _vector_1Height: _vector_1.height
    property alias _vector_1Width: _vector_1.width
    property alias _vector_1X: _vector_1.x
    property alias _vector_1Y: _vector_1.y
    property alias _vector_1_ShapePath0StrokeColor: _vector_1_ShapePath0.strokeColor
    property alias _vector_1_ShapePath0StrokeWidth: _vector_1_ShapePath0.strokeWidth
    property alias _vector_1_ShapePath0_PathSvg0Path: _vector_1_ShapePath0_PathSvg0.path
    property alias _vector_ShapePath0StrokeColor: _vector_ShapePath0.strokeColor
    property alias _vector_ShapePath0StrokeWidth: _vector_ShapePath0.strokeWidth
    property alias _vector_ShapePath0_PathSvg0Path: _vector_ShapePath0_PathSvg0.path

    height: 16
    width: 16

    clip: true
    color: "transparent"

    Shape {
        id: _vector

        x: 8
        y: 13.33

        height: 0
        width: 6

        ShapePath {
            id: _vector_ShapePath0

            fillColor: "#00000000"
            fillRule: ShapePath.WindingFill
            strokeColor: "#ffffff"
            strokeWidth: 1.50

            PathSvg {
                id: _vector_ShapePath0_PathSvg0

                path: "M 0 0 L 6 0"
            }
        }
    }
    Shape {
        id: _vector_1

        x: 2
        y: 1.92

        height: 11.41
        width: 11.41

        ShapePath {
            id: _vector_1_ShapePath0

            fillColor: "#00000000"
            fillRule: ShapePath.WindingFill
            strokeColor: "#ffffff"
            strokeWidth: 1.50

            PathSvg {
                id: _vector_1_ShapePath0_PathSvg0

                path: "M 8.999999498691194 0.41421347536133385 C 9.2652159735513 0.14899700050122738 9.62492670647908 2.9605945674257276e-16 9.999999442990216 0 C 10.185716598115711 0 10.369615314971472 0.03657971118783887 10.541195600182299 0.10765059189397447 C 10.712775885393125 0.17872147260011007 10.868677527296967 0.28289161536906315 10.999999387289238 0.41421347536133385 C 11.131321247281509 0.5455353353536045 11.23549154899617 0.7014369772574478 11.306562429702307 0.873017262468273 C 11.377633310408443 1.0445975476790983 11.414213180541994 1.22849626453486 11.414213180541992 1.4142134196603555 C 11.414213180541994 1.599930574785851 11.377633310408443 1.7838292916416127 11.306562429702307 1.955409576852438 C 11.23549154899617 2.1269898620632635 11.131321247281509 2.2828915039671065 10.999999387289238 2.414213363959377 L 2.6666665181307243 10.747546551009311 L 0 11.414213180541992 L 0.6666666295326811 8.747546662411269 L 8.999999498691194 0.41421347536133385 Z"
            }
        }
    }
}