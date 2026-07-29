import QtQuick
import QtQuick.Shapes

Rectangle {
    id: clock

    property alias iconHeight: icon.height
    property alias iconWidth: icon.width
    property alias iconX: icon.x
    property alias iconY: icon.y
    property alias icon_ShapePath0StrokeWidth: icon_ShapePath0.strokeWidth
    property alias icon_ShapePath0_PathSvg0Path: icon_ShapePath0_PathSvg0.path
    property alias icon_ShapePath1StrokeWidth: icon_ShapePath1.strokeWidth
    property alias icon_ShapePath1_PathSvg0Path: icon_ShapePath1_PathSvg0.path

    height: 20
    width: 20

    clip: true
    color: "transparent"

    Shape {
        id: icon

        x: 1.67
        y: 1.67

        height: 16.67
        width: 16.67

        ShapePath {
            id: icon_ShapePath0

            fillColor: "#00000000"
            fillRule: ShapePath.WindingFill
            strokeColor: "#1e1e1e"
            strokeWidth: 2

            PathSvg {
                id: icon_ShapePath0_PathSvg0

                path: "M 8.333333015441895 16.66666603088379 C 12.93570613861084 16.66666603088379 16.66666603088379 12.93570613861084 16.66666603088379 8.333333015441895 C 16.66666603088379 3.730959892272949 12.93570613861084 0 8.333333015441895 0 C 3.730959892272949 0 0 3.730959892272949 0 8.333333015441895 C 0 12.93570613861084 3.730959892272949 16.66666603088379 8.333333015441895 16.66666603088379 Z"
            }
        }
        ShapePath {
            id: icon_ShapePath1

            fillColor: "#00000000"
            fillRule: ShapePath.WindingFill
            strokeColor: "#1e1e1e"
            strokeWidth: 2

            PathSvg {
                id: icon_ShapePath1_PathSvg0

                path: "M 8.333333015441895 3.3333330154418945 L 8.333333015441895 8.333333015441895 L 11.666666030883789 10"
            }
        }
    }
}