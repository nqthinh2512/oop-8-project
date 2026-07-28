import QtQuick
import QtQuick.Shapes

Rectangle {
    enum State_1 { State_1_default, State_1_hover}

    id: edit

    property alias iconHeight: icon.height
    property alias iconWidth: icon.width
    property alias icon_ShapePath0StrokeWidth: icon_ShapePath0.strokeWidth
    property alias icon_ShapePath0_PathSvg0Path: icon_ShapePath0_PathSvg0.path
    property alias icon_ShapePath1StrokeWidth: icon_ShapePath1.strokeWidth
    property alias icon_ShapePath1_PathSvg0Path: icon_ShapePath1_PathSvg0.path

    property int _state: Edit_2.State_1.State_1_default

    height: 15
    width: 15

    color: "transparent"
    radius: 0

    states: [
        State {
            name: "state=default"
            when: edit._state === Edit_2.State_1.State_1_default

            PropertyChanges {
                color: "transparent"
                target: edit
            }
            PropertyChanges {
                radius: 0
                target: edit
            }
            PropertyChanges {
                strokeColor: "#1e1e1e"
                target: icon_ShapePath0
            }
            PropertyChanges {
                strokeColor: "#1e1e1e"
                target: icon_ShapePath1
            }
        },
        State {
            name: "state=hover"
            when: edit._state === Edit_2.State_1.State_1_hover

            PropertyChanges {
                color: "#4052abff"
                target: edit
            }
            PropertyChanges {
                radius: 2
                target: edit
            }
            PropertyChanges {
                strokeColor: "#52abff"
                target: icon_ShapePath0
            }
            PropertyChanges {
                strokeColor: "#52abff"
                target: icon_ShapePath1
            }
        }
    ]

    Shape {
        id: icon

        height: 15
        width: 15

        ShapePath {
            id: icon_ShapePath0

            fillColor: "#00000000"
            fillRule: ShapePath.WindingFill
            strokeColor: "#1e1e1e"
            strokeWidth: 1.50

            PathSvg {
                id: icon_ShapePath0_PathSvg0

                path: "M 6.709301136267229 1.5813973719939785 L 1.490955808059384 1.5813973719939785 C 1.0955297276367388 1.5813973719939791 0.7162992205480196 1.738479701258379 0.43669077490621006 2.0180881469001886 C 0.15708232926440047 2.2976965925419983 3.3105869336122675e-16 2.676927099630717 0 3.0723531800533626 L 0 13.509044191940616 C 3.3105869336122675e-16 13.90447027236326 0.15708232926440047 14.283700423980417 0.43669077490621006 14.563308869622226 C 0.7162992205480196 14.842917315264035 1.0955297276367388 15 1.490955808059384 15 L 11.927646464475073 15 C 12.323072544897718 15 12.702302696514872 14.842917315264035 12.981911142156681 14.563308869622226 C 13.26151958779849 14.283700423980417 13.418602272534457 13.90447027236326 13.418602272534457 13.509044191940616 L 13.418602272534457 8.290698863732771"
            }
        }
        ShapePath {
            id: icon_ShapePath1

            fillColor: "#00000000"
            fillRule: ShapePath.WindingFill
            strokeColor: "#1e1e1e"
            strokeWidth: 1.50

            PathSvg {
                id: icon_ShapePath1_PathSvg0

                path: "M 12.300385416489918 0.4631806048173317 C 12.596954965698416 0.16661105560883416 12.999189592963257 -4.419230326883863e-9 13.418602272534457 0 C 13.838014952105658 4.419231320059944e-9 14.240249579370499 0.16661105560883416 14.536819128578996 0.4631806048173317 C 14.833388677787493 0.7597501540258292 14.999999995580769 1.1619846924227777 15 1.5813973719939785 C 15.000000004419231 2.000810051565179 14.833388677787493 2.403044678830019 14.536819128578996 2.6996142280385165 L 7.454779040296921 9.781654671792156 L 4.472867424178152 10.527132575821849 L 5.218345328207844 7.54522095970308 L 12.300385416489918 0.4631806048173317 Z"
            }
        }
    }
}