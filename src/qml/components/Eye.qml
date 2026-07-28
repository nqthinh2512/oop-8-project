import QtQuick
import QtQuick.Shapes

Rectangle {
    enum Size { Size_20, Size_24, Size_32, Size_40, Size_48, Size_16}

    id: eye

    property int _size: Eye.Size.Size_48

    height: 48
    width: 48

    clip: true
    color: "transparent"

    states: [
        State {
            name: "Size=48"
            when: eye._size === Eye.Size.Size_48
    
            PropertyChanges {
                width: 48
    
                target: eye
            }
            PropertyChanges {
                height: 48
    
                target: eye
            }
            PropertyChanges {
                x: 2
    
                target: icon
            }
            PropertyChanges {
                y: 8
    
                target: icon
            }
            PropertyChanges {
                width: 44
    
                target: icon
            }
            PropertyChanges {
                height: 32
    
                target: icon
            }
            PropertyChanges {
                strokeWidth: 4
                target: icon_ShapePath0
            }
            PropertyChanges {
                path: "M 0 16 C 0 16 8 0 22 0 C 36 0 44 16 44 16 C 44 16 36 32 22 32 C 8 32 0 16 0 16 Z"
                target: icon_ShapePath0_PathSvg0
            }
            PropertyChanges {
                strokeWidth: 4
                target: icon_ShapePath1
            }
            PropertyChanges {
                path: "M 22 22 C 25.313708305358887 22 28 19.313708305358887 28 16 C 28 12.686291456222534 25.313708305358887 10 22 10 C 18.686291456222534 10 16 12.686291456222534 16 16 C 16 19.313708305358887 18.686291456222534 22 22 22 Z"
                target: icon_ShapePath1_PathSvg0
            }
        },
        State {
            name: "Size=16"
            when: eye._size === Eye.Size.Size_16
    
            PropertyChanges {
                width: 16
    
                target: eye
            }
            PropertyChanges {
                height: 16
    
                target: eye
            }
            PropertyChanges {
                x: 0.67
    
                target: icon
            }
            PropertyChanges {
                y: 2.67
    
                target: icon
            }
            PropertyChanges {
                width: 14.67
    
                target: icon
            }
            PropertyChanges {
                height: 10.67
    
                target: icon
            }
            PropertyChanges {
                strokeWidth: 1.60
                target: icon_ShapePath0
            }
            PropertyChanges {
                path: "M 0 5.3333330154418945 C 0 5.3333330154418945 2.666666481711646 0 7.3333330154418945 0 C 11.999999549172143 0 14.666666030883789 5.3333330154418945 14.666666030883789 5.3333330154418945 C 14.666666030883789 5.3333330154418945 11.999999549172143 10.666666030883789 7.3333330154418945 10.666666030883789 C 2.666666481711646 10.666666030883789 0 5.3333330154418945 0 5.3333330154418945 Z"
                target: icon_ShapePath0_PathSvg0
            }
            PropertyChanges {
                strokeWidth: 1.60
                target: icon_ShapePath1
            }
            PropertyChanges {
                path: "M 7.3333330154418945 7.333332562446606 C 8.437902479290603 7.333332562446606 9.333333067460497 6.437902411059041 9.333333067460497 5.3333330154418945 C 9.333333067460497 4.228763524457319 8.437902479290603 3.33333308696747 7.3333330154418945 3.33333308696747 C 6.228763456225752 3.33333308696747 5.3333333448930285 4.228763524457319 5.3333333448930285 5.3333330154418945 C 5.3333333448930285 6.437902411059041 6.228763456225752 7.333332562446606 7.3333330154418945 7.333332562446606 Z"
                target: icon_ShapePath1_PathSvg0
            }
        },
        State {
            name: "Size=20"
            when: eye._size === Eye.Size.Size_20
    
            PropertyChanges {
                width: 20
    
                target: eye
            }
            PropertyChanges {
                height: 20
    
                target: eye
            }
            PropertyChanges {
                x: 0.83
    
                target: icon
            }
            PropertyChanges {
                y: 3.33
    
                target: icon
            }
            PropertyChanges {
                width: 18.33
    
                target: icon
            }
            PropertyChanges {
                height: 13.33
    
                target: icon
            }
            PropertyChanges {
                strokeWidth: 2
                target: icon_ShapePath0
            }
            PropertyChanges {
                path: "M 0 6.666666507720947 C 0 6.666666507720947 3.3333330154418945 0 9.166666030883789 0 C 14.999999046325684 0 18.333332061767578 6.666666507720947 18.333332061767578 6.666666507720947 C 18.333332061767578 6.666666507720947 14.999999046325684 13.333333015441895 9.166666030883789 13.333333015441895 C 3.3333330154418945 13.333333015441895 0 6.666666507720947 0 6.666666507720947 Z"
                target: icon_ShapePath0_PathSvg0
            }
            PropertyChanges {
                strokeWidth: 2
                target: icon_ShapePath1
            }
            PropertyChanges {
                path: "M 9.166666030883789 9.166666030883789 C 10.547377824783325 9.166666030883789 11.666666030883789 8.047378301620483 11.666666030883789 6.666666507720947 C 11.666666030883789 5.285954594612122 10.547377824783325 4.166666507720947 9.166666030883789 4.166666507720947 C 7.785954117774963 4.166666507720947 6.666666507720947 5.285954594612122 6.666666507720947 6.666666507720947 C 6.666666507720947 8.047378301620483 7.785954117774963 9.166666030883789 9.166666030883789 9.166666030883789 Z"
                target: icon_ShapePath1_PathSvg0
            }
        },
        State {
            name: "Size=24"
            when: eye._size === Eye.Size.Size_24
    
            PropertyChanges {
                width: 24
    
                target: eye
            }
            PropertyChanges {
                height: 24
    
                target: eye
            }
            PropertyChanges {
                x: 1
    
                target: icon
            }
            PropertyChanges {
                y: 4
    
                target: icon
            }
            PropertyChanges {
                width: 22
    
                target: icon
            }
            PropertyChanges {
                height: 16
    
                target: icon
            }
            PropertyChanges {
                strokeWidth: 2.50
                target: icon_ShapePath0
            }
            PropertyChanges {
                path: "M 0 8 C 0 8 4 0 11 0 C 18 0 22 8 22 8 C 22 8 18 16 11 16 C 4 16 0 8 0 8 Z"
                target: icon_ShapePath0_PathSvg0
            }
            PropertyChanges {
                strokeWidth: 2.50
                target: icon_ShapePath1
            }
            PropertyChanges {
                path: "M 11 11 C 12.656854152679443 11 14 9.656854152679443 14 8 C 14 6.343145728111267 12.656854152679443 5 11 5 C 9.343145728111267 5 8 6.343145728111267 8 8 C 8 9.656854152679443 9.343145728111267 11 11 11 Z"
                target: icon_ShapePath1_PathSvg0
            }
        },
        State {
            name: "Size=32"
            when: eye._size === Eye.Size.Size_32
    
            PropertyChanges {
                width: 32
    
                target: eye
            }
            PropertyChanges {
                height: 32
    
                target: eye
            }
            PropertyChanges {
                x: 1.33
    
                target: icon
            }
            PropertyChanges {
                y: 5.33
    
                target: icon
            }
            PropertyChanges {
                width: 29.33
    
                target: icon
            }
            PropertyChanges {
                height: 21.33
    
                target: icon
            }
            PropertyChanges {
                strokeWidth: 3
                target: icon_ShapePath0
            }
            PropertyChanges {
                path: "M 0 10.666666984558105 C 0 10.666666984558105 5.3333330154418945 0 14.666666984558105 0 C 24.000000953674316 0 29.33333396911621 10.666666984558105 29.33333396911621 10.666666984558105 C 29.33333396911621 10.666666984558105 24.000000953674316 21.33333396911621 14.666666984558105 21.33333396911621 C 5.3333330154418945 21.33333396911621 0 10.666666984558105 0 10.666666984558105 Z"
                target: icon_ShapePath0_PathSvg0
            }
            PropertyChanges {
                strokeWidth: 3
                target: icon_ShapePath1
            }
            PropertyChanges {
                path: "M 14.666666984558105 14.666666984558105 C 16.87580633163452 14.666666984558105 18.666667938232422 12.875806331634521 18.666667938232422 10.666666984558105 C 18.666667938232422 8.457528114318848 16.87580633163452 6.6666669845581055 14.666666984558105 6.6666669845581055 C 12.457528114318848 6.6666669845581055 10.666666984558105 8.457528114318848 10.666666984558105 10.666666984558105 C 10.666666984558105 12.875806331634521 12.457528114318848 14.666666984558105 14.666666984558105 14.666666984558105 Z"
                target: icon_ShapePath1_PathSvg0
            }
        },
        State {
            name: "Size=40"
            when: eye._size === Eye.Size.Size_40
    
            PropertyChanges {
                width: 40
    
                target: eye
            }
            PropertyChanges {
                height: 40
    
                target: eye
            }
            PropertyChanges {
                x: 1.67
    
                target: icon
            }
            PropertyChanges {
                y: 6.67
    
                target: icon
            }
            PropertyChanges {
                width: 36.67
    
                target: icon
            }
            PropertyChanges {
                height: 26.67
    
                target: icon
            }
            PropertyChanges {
                strokeWidth: 3.50
                target: icon_ShapePath0
            }
            PropertyChanges {
                path: "M 0 13.333333015441895 C 0 13.333333015441895 6.666666030883789 0 18.333332061767578 0 C 29.999998092651367 0 36.666664123535156 13.333333015441895 36.666664123535156 13.333333015441895 C 36.666664123535156 13.333333015441895 29.999998092651367 26.66666603088379 18.333332061767578 26.66666603088379 C 6.666666030883789 26.66666603088379 0 13.333333015441895 0 13.333333015441895 Z"
                target: icon_ShapePath0_PathSvg0
            }
            PropertyChanges {
                strokeWidth: 3.50
                target: icon_ShapePath1
            }
            PropertyChanges {
                path: "M 18.333332061767578 18.333332061767578 C 21.09475564956665 18.333332061767578 23.333332061767578 16.094756603240967 23.333332061767578 13.333333015441895 C 23.333332061767578 10.571909189224243 21.09475564956665 8.333333015441895 18.333332061767578 8.333333015441895 C 15.571908235549927 8.333333015441895 13.333333015441895 10.571909189224243 13.333333015441895 13.333333015441895 C 13.333333015441895 16.094756603240967 15.571908235549927 18.333332061767578 18.333332061767578 18.333332061767578 Z"
                target: icon_ShapePath1_PathSvg0
            }
        }
    ]

    Shape {
        id: icon

        x: 2
        y: 8

        height: 32
        width: 44

        ShapePath {
            id: icon_ShapePath0

            fillColor: "#00000000"
            fillRule: ShapePath.WindingFill
            strokeColor: "#1e1e1e"
            strokeWidth: 4

            PathSvg {
                id: icon_ShapePath0_PathSvg0

                path: "M 0 16 C 0 16 8 0 22 0 C 36 0 44 16 44 16 C 44 16 36 32 22 32 C 8 32 0 16 0 16 Z"
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

                path: "M 22 22 C 25.313708305358887 22 28 19.313708305358887 28 16 C 28 12.686291456222534 25.313708305358887 10 22 10 C 18.686291456222534 10 16 12.686291456222534 16 16 C 16 19.313708305358887 18.686291456222534 22 22 22 Z"
            }
        }
    }
}