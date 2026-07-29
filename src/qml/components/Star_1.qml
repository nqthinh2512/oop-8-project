import QtQuick
import QtQuick.Shapes

Rectangle {
    id: star

    property alias icon_ShapePath0StrokeColor: icon_ShapePath0.strokeColor

    height: 20
    width: 20

    clip: true
    color: "transparent"

    Shape {
        id: icon

        x: 1.67
        y: 1.67

        height: 15.85
        width: 16.67

        ShapePath {
            id: icon_ShapePath0

            fillColor: "#00000000"
            fillRule: ShapePath.WindingFill
            strokeColor: "#1e1e1e"
            strokeWidth: 2

            PathSvg {
                id: icon_ShapePath0_PathSvg0

                path: "M 8.333333015441895 0 L 10.908332824707031 5.2166666984558105 L 16.66666603088379 6.058333396911621 L 12.5 10.116666793823242 L 13.483333587646484 15.850000381469727 L 8.333333015441895 13.141666412353516 L 3.183333396911621 15.850000381469727 L 4.166666507720947 10.116666793823242 L 0 6.058333396911621 L 5.758333206176758 5.2166666984558105 L 8.333333015441895 0 Z"
            }
        }
    }
}