import QtQuick
import QtQuick.Shapes

Rectangle {
    id: date_Input_Field

    height: 42
    width: 312

    color: "#e9e9e9"
    radius: 8

    Rectangle {
        id: dmy

        x: 20
        y: 6

        height: 30
        width: 143

        color: "transparent"

        Rectangle {
            id: day

            height: 30
            width: 23

            color: "transparent"
            radius: 8

            Text {
                id: textField

                y: 7

                height: 16
                width: 24

                color: "#1e1e1e"
                font.family: "Inter"
                font.pixelSize: 16
                font.weight: Font.Normal
                horizontalAlignment: Text.AlignLeft
                lineHeight: 16
                lineHeightMode: Text.FixedHeight
                text: "DD"
                textFormat: Text.PlainText
                verticalAlignment: Text.AlignTop
            }
        }
        Text {
            id: element

            x: 31
            y: 5

            height: 20
            width: 9

            color: "#1e1e1e"
            font.family: "Inter"
            font.pixelSize: 20
            font.weight: Font.Normal
            horizontalAlignment: Text.AlignLeft
            lineHeight: 20
            lineHeightMode: Text.FixedHeight
            text: "/"
            textFormat: Text.PlainText
            verticalAlignment: Text.AlignTop
        }
        Rectangle {
            id: month

            x: 47

            height: 30
            width: 29

            color: "transparent"
            radius: 8

            Text {
                id: textField_1

                y: 7

                height: 16
                width: 30

                color: "#1e1e1e"
                font.family: "Inter"
                font.pixelSize: 16
                font.weight: Font.Normal
                horizontalAlignment: Text.AlignLeft
                lineHeight: 16
                lineHeightMode: Text.FixedHeight
                text: "MM"
                textFormat: Text.PlainText
                verticalAlignment: Text.AlignTop
            }
        }
        Text {
            id: element_1

            x: 84
            y: 5

            height: 20
            width: 9

            color: "#1e1e1e"
            font.family: "Inter"
            font.pixelSize: 20
            font.weight: Font.Normal
            horizontalAlignment: Text.AlignLeft
            lineHeight: 20
            lineHeightMode: Text.FixedHeight
            text: "/"
            textFormat: Text.PlainText
            verticalAlignment: Text.AlignTop
        }
        Rectangle {
            id: year

            x: 100

            height: 30
            width: 43

            color: "transparent"
            radius: 8

            Text {
                id: textField_2

                y: 7

                height: 16
                width: 44

                color: "#1e1e1e"
                font.family: "Inter"
                font.pixelSize: 16
                font.weight: Font.Normal
                horizontalAlignment: Text.AlignLeft
                lineHeight: 16
                lineHeightMode: Text.FixedHeight
                text: "YYYY"
                textFormat: Text.PlainText
                verticalAlignment: Text.AlignTop
            }
        }
    }
    Rectangle {
        id: datePicker

        x: 274
        y: 12

        height: 18
        width: 18

        clip: true
        color: "transparent"

        Shape {
            id: icon

            x: 2.25
            y: 1.50

            height: 15
            width: 13.50

            ShapePath {
                id: icon_ShapePath0

                fillColor: "#00000000"
                fillRule: ShapePath.WindingFill
                strokeColor: "#1e1e1e"
                strokeWidth: 1.60

                PathSvg {
                    id: icon_ShapePath0_PathSvg0

                    path: "M 11.999999713897706 1.500000116825106 L 1.4999999642372133 1.500000116825106 C 0.6715728342533113 1.500000116825106 0 2.171573019394341 0 3.000000233650212 L 0 13.500001373291068 C 0 14.32842896305624 0.6715728342533113 15.000000953674316 1.4999999642372133 15.000000953674316 L 11.999999713897706 15.000000953674316 C 12.82842721939087 15.000000953674316 13.5 14.32842896305624 13.5 13.500001373291068 L 13.5 3.000000233650212 C 13.5 2.171573019394341 12.82842721939087 1.500000116825106 11.999999713897706 1.500000116825106 Z"
                }
            }
        }
    }
}