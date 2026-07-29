import QtQuick
import QtQuick.Shapes

Rectangle {
    enum Size { Size_32, Size_16, Size_40, Size_24, Size_48, Size_20}

    id: activity

    property int _size: Activity_1.Size.Size_48

    height: 48
    width: 48

    clip: true
    color: "transparent"

    states: [
        State {
            name: "Size=48"
            when: activity._size === Activity_1.Size.Size_48
    
            PropertyChanges {
                width: 48
    
                target: activity
            }
            PropertyChanges {
                height: 48
    
                target: activity
            }
            PropertyChanges {
                x: 4
    
                target: icon
            }
            PropertyChanges {
                y: 6
    
                target: icon
            }
            PropertyChanges {
                width: 40
    
                target: icon
            }
            PropertyChanges {
                height: 36
    
                target: icon
            }
            PropertyChanges {
                strokeWidth: 4
                target: icon_ShapePath0
            }
            PropertyChanges {
                path: "M 40 18 L 32 18 L 26 36 L 14 0 L 8 18 L 0 18"
                target: icon_ShapePath0_PathSvg0
            }
        },
        State {
            name: "Size=16"
            when: activity._size === Activity_1.Size.Size_16
    
            PropertyChanges {
                width: 16
    
                target: activity
            }
            PropertyChanges {
                height: 16
    
                target: activity
            }
            PropertyChanges {
                x: 1.33
    
                target: icon
            }
            PropertyChanges {
                y: 2
    
                target: icon
            }
            PropertyChanges {
                width: 13.33
    
                target: icon
            }
            PropertyChanges {
                height: 12
    
                target: icon
            }
            PropertyChanges {
                strokeWidth: 1.60
                target: icon_ShapePath0
            }
            PropertyChanges {
                path: "M 13.333333015441895 6 L 10.666666564941409 6 L 8.666666536331178 12 L 4.666666479110717 0 L 2.666666641235352 6 L 0 6"
                target: icon_ShapePath0_PathSvg0
            }
        },
        State {
            name: "Size=20"
            when: activity._size === Activity_1.Size.Size_20
    
            PropertyChanges {
                width: 20
    
                target: activity
            }
            PropertyChanges {
                height: 20
    
                target: activity
            }
            PropertyChanges {
                x: 1.67
    
                target: icon
            }
            PropertyChanges {
                y: 2.50
    
                target: icon
            }
            PropertyChanges {
                width: 16.67
    
                target: icon
            }
            PropertyChanges {
                height: 15
    
                target: icon
            }
            PropertyChanges {
                strokeWidth: 2
                target: icon_ShapePath0
            }
            PropertyChanges {
                path: "M 16.66666603088379 7.5 L 13.333333015441895 7.5 L 10.833333015441895 15 L 5.8333330154418945 0 L 3.3333332538604736 7.5 L 0 7.5"
                target: icon_ShapePath0_PathSvg0
            }
        },
        State {
            name: "Size=24"
            when: activity._size === Activity_1.Size.Size_24
    
            PropertyChanges {
                width: 24
    
                target: activity
            }
            PropertyChanges {
                height: 24
    
                target: activity
            }
            PropertyChanges {
                x: 2
    
                target: icon
            }
            PropertyChanges {
                y: 3
    
                target: icon
            }
            PropertyChanges {
                width: 20
    
                target: icon
            }
            PropertyChanges {
                height: 18
    
                target: icon
            }
            PropertyChanges {
                strokeWidth: 2.50
                target: icon_ShapePath0
            }
            PropertyChanges {
                path: "M 20 9 L 16 9 L 13 18 L 7 0 L 4 9 L 0 9"
                target: icon_ShapePath0_PathSvg0
            }
        },
        State {
            name: "Size=32"
            when: activity._size === Activity_1.Size.Size_32
    
            PropertyChanges {
                width: 32
    
                target: activity
            }
            PropertyChanges {
                height: 32
    
                target: activity
            }
            PropertyChanges {
                x: 2.67
    
                target: icon
            }
            PropertyChanges {
                y: 4
    
                target: icon
            }
            PropertyChanges {
                width: 26.67
    
                target: icon
            }
            PropertyChanges {
                height: 24
    
                target: icon
            }
            PropertyChanges {
                strokeWidth: 3
                target: icon_ShapePath0
            }
            PropertyChanges {
                path: "M 26.666667938232422 12 L 21.33333396911621 12 L 17.33333396911621 24 L 9.333333969116211 0 L 5.333333492279053 12 L 0 12"
                target: icon_ShapePath0_PathSvg0
            }
        },
        State {
            name: "Size=40"
            when: activity._size === Activity_1.Size.Size_40
    
            PropertyChanges {
                width: 40
    
                target: activity
            }
            PropertyChanges {
                height: 40
    
                target: activity
            }
            PropertyChanges {
                x: 3.33
    
                target: icon
            }
            PropertyChanges {
                y: 5
    
                target: icon
            }
            PropertyChanges {
                width: 33.33
    
                target: icon
            }
            PropertyChanges {
                height: 30
    
                target: icon
            }
            PropertyChanges {
                strokeWidth: 3.50
                target: icon_ShapePath0
            }
            PropertyChanges {
                path: "M 33.33333206176758 15 L 26.66666603088379 15 L 21.66666603088379 30 L 11.666666030883789 0 L 6.666666507720947 15 L 0 15"
                target: icon_ShapePath0_PathSvg0
            }
        }
    ]

    Shape {
        id: icon

        x: 4
        y: 6

        height: 36
        width: 40

        ShapePath {
            id: icon_ShapePath0

            fillColor: "#00000000"
            fillRule: ShapePath.WindingFill
            strokeColor: "#1e1e1e"
            strokeWidth: 4

            PathSvg {
                id: icon_ShapePath0_PathSvg0

                path: "M 40 18 L 32 18 L 26 36 L 14 0 L 8 18 L 0 18"
            }
        }
    }
}