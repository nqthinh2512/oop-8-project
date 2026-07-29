import QtQuick
import QtQuick.Shapes

Rectangle {
    enum Size { Size_20, Size_24, Size_32, Size_40, Size_48, Size_16}

    id: grid

    property int _size: Grid_2.Size.Size_48

    height: 48
    width: 48

    clip: true
    color: "transparent"

    states: [
        State {
            name: "Size=48"
            when: grid._size === Grid_2.Size.Size_48
    
            PropertyChanges {
                width: 48
    
                target: grid
            }
            PropertyChanges {
                height: 48
    
                target: grid
            }
            PropertyChanges {
                x: 6
    
                target: icon
            }
            PropertyChanges {
                y: 6
    
                target: icon
            }
            PropertyChanges {
                width: 36
    
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
                path: "M 14 0 L 0 0 L 0 14 L 14 14 L 14 0 Z"
                target: icon_ShapePath0_PathSvg0
            }
            PropertyChanges {
                strokeWidth: 4
                target: icon_ShapePath1
            }
            PropertyChanges {
                path: "M 36 0 L 22 0 L 22 14 L 36 14 L 36 0 Z"
                target: icon_ShapePath1_PathSvg0
            }
            PropertyChanges {
                strokeWidth: 4
                target: icon_ShapePath2
            }
            PropertyChanges {
                path: "M 36 22 L 22 22 L 22 36 L 36 36 L 36 22 Z"
                target: icon_ShapePath2_PathSvg0
            }
            PropertyChanges {
                strokeWidth: 4
                target: icon_ShapePath3
            }
            PropertyChanges {
                path: "M 14 22 L 0 22 L 0 36 L 14 36 L 14 22 Z"
                target: icon_ShapePath3_PathSvg0
            }
        },
        State {
            name: "Size=16"
            when: grid._size === Grid_2.Size.Size_16
    
            PropertyChanges {
                width: 16
    
                target: grid
            }
            PropertyChanges {
                height: 16
    
                target: grid
            }
            PropertyChanges {
                x: 2
    
                target: icon
            }
            PropertyChanges {
                y: 2
    
                target: icon
            }
            PropertyChanges {
                width: 12
    
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
                path: "M 4.666666412353516 0 L 0 0 L 0 4.666666412353516 L 4.666666412353516 4.666666412353516 L 4.666666412353516 0 Z"
                target: icon_ShapePath0_PathSvg0
            }
            PropertyChanges {
                strokeWidth: 1.60
                target: icon_ShapePath1
            }
            PropertyChanges {
                path: "M 12 0 L 7.333333587646485 0 L 7.333333587646485 4.666666412353516 L 12 4.666666412353516 L 12 0 Z"
                target: icon_ShapePath1_PathSvg0
            }
            PropertyChanges {
                strokeWidth: 1.60
                target: icon_ShapePath2
            }
            PropertyChanges {
                path: "M 12 7.333333587646485 L 7.333333587646485 7.333333587646485 L 7.333333587646485 12 L 12 12 L 12 7.333333587646485 Z"
                target: icon_ShapePath2_PathSvg0
            }
            PropertyChanges {
                strokeWidth: 1.60
                target: icon_ShapePath3
            }
            PropertyChanges {
                path: "M 4.666666412353516 7.333333587646485 L 0 7.333333587646485 L 0 12 L 4.666666412353516 12 L 4.666666412353516 7.333333587646485 Z"
                target: icon_ShapePath3_PathSvg0
            }
        },
        State {
            name: "Size=20"
            when: grid._size === Grid_2.Size.Size_20
    
            PropertyChanges {
                width: 20
    
                target: grid
            }
            PropertyChanges {
                height: 20
    
                target: grid
            }
            PropertyChanges {
                x: 2.50
    
                target: icon
            }
            PropertyChanges {
                y: 2.50
    
                target: icon
            }
            PropertyChanges {
                width: 15
    
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
                path: "M 5.8333330154418945 0 L 0 0 L 0 5.8333330154418945 L 5.8333330154418945 5.8333330154418945 L 5.8333330154418945 0 Z"
                target: icon_ShapePath0_PathSvg0
            }
            PropertyChanges {
                strokeWidth: 2
                target: icon_ShapePath1
            }
            PropertyChanges {
                path: "M 15 0 L 9.166666984558105 0 L 9.166666984558105 5.8333330154418945 L 15 5.8333330154418945 L 15 0 Z"
                target: icon_ShapePath1_PathSvg0
            }
            PropertyChanges {
                strokeWidth: 2
                target: icon_ShapePath2
            }
            PropertyChanges {
                path: "M 15 9.166666984558105 L 9.166666984558105 9.166666984558105 L 9.166666984558105 15 L 15 15 L 15 9.166666984558105 Z"
                target: icon_ShapePath2_PathSvg0
            }
            PropertyChanges {
                strokeWidth: 2
                target: icon_ShapePath3
            }
            PropertyChanges {
                path: "M 5.8333330154418945 9.166666984558105 L 0 9.166666984558105 L 0 15 L 5.8333330154418945 15 L 5.8333330154418945 9.166666984558105 Z"
                target: icon_ShapePath3_PathSvg0
            }
        },
        State {
            name: "Size=24"
            when: grid._size === Grid_2.Size.Size_24
    
            PropertyChanges {
                width: 24
    
                target: grid
            }
            PropertyChanges {
                height: 24
    
                target: grid
            }
            PropertyChanges {
                x: 3
    
                target: icon
            }
            PropertyChanges {
                y: 3
    
                target: icon
            }
            PropertyChanges {
                width: 18
    
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
                path: "M 7 0 L 0 0 L 0 7 L 7 7 L 7 0 Z"
                target: icon_ShapePath0_PathSvg0
            }
            PropertyChanges {
                strokeWidth: 2.50
                target: icon_ShapePath1
            }
            PropertyChanges {
                path: "M 18 0 L 11 0 L 11 7 L 18 7 L 18 0 Z"
                target: icon_ShapePath1_PathSvg0
            }
            PropertyChanges {
                strokeWidth: 2.50
                target: icon_ShapePath2
            }
            PropertyChanges {
                path: "M 18 11 L 11 11 L 11 18 L 18 18 L 18 11 Z"
                target: icon_ShapePath2_PathSvg0
            }
            PropertyChanges {
                strokeWidth: 2.50
                target: icon_ShapePath3
            }
            PropertyChanges {
                path: "M 7 11 L 0 11 L 0 18 L 7 18 L 7 11 Z"
                target: icon_ShapePath3_PathSvg0
            }
        },
        State {
            name: "Size=32"
            when: grid._size === Grid_2.Size.Size_32
    
            PropertyChanges {
                width: 32
    
                target: grid
            }
            PropertyChanges {
                height: 32
    
                target: grid
            }
            PropertyChanges {
                x: 4
    
                target: icon
            }
            PropertyChanges {
                y: 4
    
                target: icon
            }
            PropertyChanges {
                width: 24
    
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
                path: "M 9.333333969116211 0 L 0 0 L 0 9.333333969116211 L 9.333333969116211 9.333333969116211 L 9.333333969116211 0 Z"
                target: icon_ShapePath0_PathSvg0
            }
            PropertyChanges {
                strokeWidth: 3
                target: icon_ShapePath1
            }
            PropertyChanges {
                path: "M 24 0 L 14.666666030883789 0 L 14.666666030883789 9.333333969116211 L 24 9.333333969116211 L 24 0 Z"
                target: icon_ShapePath1_PathSvg0
            }
            PropertyChanges {
                strokeWidth: 3
                target: icon_ShapePath2
            }
            PropertyChanges {
                path: "M 24 14.666666030883789 L 14.666666030883789 14.666666030883789 L 14.666666030883789 24 L 24 24 L 24 14.666666030883789 Z"
                target: icon_ShapePath2_PathSvg0
            }
            PropertyChanges {
                strokeWidth: 3
                target: icon_ShapePath3
            }
            PropertyChanges {
                path: "M 9.333333969116211 14.666666030883789 L 0 14.666666030883789 L 0 24 L 9.333333969116211 24 L 9.333333969116211 14.666666030883789 Z"
                target: icon_ShapePath3_PathSvg0
            }
        },
        State {
            name: "Size=40"
            when: grid._size === Grid_2.Size.Size_40
    
            PropertyChanges {
                width: 40
    
                target: grid
            }
            PropertyChanges {
                height: 40
    
                target: grid
            }
            PropertyChanges {
                x: 5
    
                target: icon
            }
            PropertyChanges {
                y: 5
    
                target: icon
            }
            PropertyChanges {
                width: 30
    
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
                path: "M 11.666666030883789 0 L 0 0 L 0 11.666666030883789 L 11.666666030883789 11.666666030883789 L 11.666666030883789 0 Z"
                target: icon_ShapePath0_PathSvg0
            }
            PropertyChanges {
                strokeWidth: 3.50
                target: icon_ShapePath1
            }
            PropertyChanges {
                path: "M 30 0 L 18.33333396911621 0 L 18.33333396911621 11.666666030883789 L 30 11.666666030883789 L 30 0 Z"
                target: icon_ShapePath1_PathSvg0
            }
            PropertyChanges {
                strokeWidth: 3.50
                target: icon_ShapePath2
            }
            PropertyChanges {
                path: "M 30 18.33333396911621 L 18.33333396911621 18.33333396911621 L 18.33333396911621 30 L 30 30 L 30 18.33333396911621 Z"
                target: icon_ShapePath2_PathSvg0
            }
            PropertyChanges {
                strokeWidth: 3.50
                target: icon_ShapePath3
            }
            PropertyChanges {
                path: "M 11.666666030883789 18.33333396911621 L 0 18.33333396911621 L 0 30 L 11.666666030883789 30 L 11.666666030883789 18.33333396911621 Z"
                target: icon_ShapePath3_PathSvg0
            }
        }
    ]

    Shape {
        id: icon

        x: 6
        y: 6

        height: 36
        width: 36

        ShapePath {
            id: icon_ShapePath0

            fillColor: "#00000000"
            fillRule: ShapePath.WindingFill
            strokeColor: "#1e1e1e"
            strokeWidth: 4

            PathSvg {
                id: icon_ShapePath0_PathSvg0

                path: "M 14 0 L 0 0 L 0 14 L 14 14 L 14 0 Z"
            }
        }
        ShapePath {
            id: icon_ShapePath1

            fillColor: "#00000000"
            fillRule: ShapePath.WindingFill
            strokeColor: "#1e1e1e"
            strokeWidth: 4

            PathSvg {
                id: icon_ShapePath1_PathSvg0

                path: "M 36 0 L 22 0 L 22 14 L 36 14 L 36 0 Z"
            }
        }
        ShapePath {
            id: icon_ShapePath2

            fillColor: "#00000000"
            fillRule: ShapePath.WindingFill
            strokeColor: "#1e1e1e"
            strokeWidth: 4

            PathSvg {
                id: icon_ShapePath2_PathSvg0

                path: "M 36 22 L 22 22 L 22 36 L 36 36 L 36 22 Z"
            }
        }
        ShapePath {
            id: icon_ShapePath3

            fillColor: "#00000000"
            fillRule: ShapePath.WindingFill
            strokeColor: "#1e1e1e"
            strokeWidth: 4

            PathSvg {
                id: icon_ShapePath3_PathSvg0

                path: "M 14 22 L 0 22 L 0 36 L 14 36 L 14 22 Z"
            }
        }
    }
}