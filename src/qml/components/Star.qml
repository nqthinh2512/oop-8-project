import QtQuick
import QtQuick.Shapes

Rectangle {
    id: star

    property alias icon_ShapePath0StrokeColor: icon_ShapePath0.strokeColor

    height: 16
    width: 16

    clip: true
    color: "transparent"
    visible: true

    Shape {
        id: icon

        x: 1.33
        y: 1.33

        height: 12.68
        width: 13.33

        ShapePath {
            id: icon_ShapePath0

            fillColor: "#00000000"
            fillRule: ShapePath.WindingFill
            strokeColor: "#1e1e1e"
            strokeWidth: 1.60

            PathSvg {
                id: icon_ShapePath0_PathSvg0

                path: "M 6.666666507720947 0 L 8.726666384601593 4.173333358764649 L 13.333333015441895 4.846666717529297 L 10.000000143051153 8.093333435058595 L 10.786667024421702 12.680000305175781 L 6.666666507720947 10.513333129882813 L 2.546666753959658 12.680000305175781 L 3.3333332538604736 8.093333435058595 L 0 4.846666717529297 L 4.606666630840302 4.173333358764649 L 6.666666507720947 0 Z"
            }
        }
    }
}