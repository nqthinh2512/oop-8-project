import QtQuick
import QtQuick.Shapes

Rectangle {
    id: home

    height: 20
    width: 20

    clip: true
    color: "transparent"

    Shape {
        id: icon

        x: 2.50
        y: 1.67

        height: 16.67
        width: 15

        ShapePath {
            id: icon_ShapePath0

            fillColor: "#00000000"
            fillRule: ShapePath.WindingFill
            strokeColor: "#1e1e1e"
            strokeWidth: 2

            PathSvg {
                id: icon_ShapePath0_PathSvg0

                path: "M 0 5.8333330154418945 L 7.5 0 L 15 5.8333330154418945 L 15 15 C 15 15.442027479410172 14.824404299259186 15.865950047969818 14.51184368133545 16.178510665893555 C 14.199283063411713 16.49107128381729 13.775360494852066 16.66666603088379 13.333333015441895 16.66666603088379 L 1.6666666269302368 16.66666603088379 C 1.2246391475200653 16.66666603088379 0.8007158935070038 16.49107128381729 0.4881552755832672 16.178510665893555 C 0.17559465765953064 15.865950047969818 3.70074332718459e-16 15.442027479410172 0 15 L 0 5.8333330154418945 Z"
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

                path: "M 5 16.66666603088379 L 5 8.333333015441895 L 10 8.333333015441895 L 10 16.66666603088379"
            }
        }
    }
}