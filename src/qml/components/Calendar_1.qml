import QtQuick

Rectangle {
    id: calendar

    height: 308
    width: 318

    border.color: "#d9d9d9"
    border.width: 1
    color: "#ffffff"
    radius: 16

    Rectangle {
        id: block

        x: 16
        y: 16

        height: 36
        width: 286

        color: "transparent"

        Icon_Button {
            id: icon_Button

            height: 36
            width: 36

            _size: Icon_Button.Size.Size_Small
            _state: Icon_Button.State_1.State_1_Default
            _variant: Icon_Button.Variant.Variant_Subtle
            clip: true
        }
        Calendar_Select_Group {
            id: calendar_Select_Group

            x: 52
            y: 4

            width: 182

            calendar_Month_FieldChevron_downX: 65
            calendar_Month_FieldSelectWidth: 87
            calendar_Month_FieldSeptemberWidth: 52
            calendar_Month_FieldWidth: 87
            calendar_Year_FieldChevron_downX: 65
            calendar_Year_FieldElementWidth: 52
            calendar_Year_FieldSelectWidth: 87
            calendar_Year_FieldWidth: 87
            calendar_Year_FieldX: 95
        }
        Icon_Button {
            id: icon_Button_1

            x: 250

            height: 36
            width: 36

            _size: Icon_Button.Size.Size_Small
            _state: Icon_Button.State_1.State_1_Default
            _variant: Icon_Button.Variant.Variant_Subtle
            clip: true
        }
    }
    Rectangle {
        id: table

        x: 16
        y: 52

        height: 240
        width: 286

        color: "transparent"

        Rectangle {
            id: thead

            y: 16

            height: 20
            width: 286

            color: "transparent"

            Rectangle {
                id: td

                height: 20
                width: 40

                color: "transparent"

                Text {
                    id: day_picker

                    x: 12.50

                    height: 20
                    width: 16

                    color: "#757575"
                    font.family: "Geist"
                    font.pixelSize: 12
                    font.weight: Font.Normal
                    horizontalAlignment: Text.AlignHCenter
                    lineHeight: 20
                    lineHeightMode: Text.FixedHeight
                    text: "Su"
                    textFormat: Text.PlainText
                    verticalAlignment: Text.AlignVCenter
                }
            }
            Rectangle {
                id: td_1

                x: 41

                height: 20
                width: 40

                color: "transparent"

                Text {
                    id: day_picker_1

                    x: 11

                    height: 20
                    width: 19

                    color: "#757575"
                    font.family: "Geist"
                    font.pixelSize: 12
                    font.weight: Font.Normal
                    horizontalAlignment: Text.AlignHCenter
                    lineHeight: 20
                    lineHeightMode: Text.FixedHeight
                    text: "Mo"
                    textFormat: Text.PlainText
                    verticalAlignment: Text.AlignVCenter
                }
            }
            Rectangle {
                id: td_2

                x: 82

                height: 20
                width: 40

                color: "transparent"

                Text {
                    id: day_picker_2

                    x: 13.50

                    height: 20
                    width: 14

                    color: "#757575"
                    font.family: "Geist"
                    font.pixelSize: 12
                    font.weight: Font.Normal
                    horizontalAlignment: Text.AlignHCenter
                    lineHeight: 20
                    lineHeightMode: Text.FixedHeight
                    text: "Tu"
                    textFormat: Text.PlainText
                    verticalAlignment: Text.AlignVCenter
                }
            }
            Rectangle {
                id: td_3

                x: 123

                height: 20
                width: 40

                color: "transparent"

                Text {
                    id: day_picker_3

                    x: 11

                    height: 20
                    width: 19

                    color: "#757575"
                    font.family: "Geist"
                    font.pixelSize: 12
                    font.weight: Font.Normal
                    horizontalAlignment: Text.AlignHCenter
                    lineHeight: 20
                    lineHeightMode: Text.FixedHeight
                    text: "We"
                    textFormat: Text.PlainText
                    verticalAlignment: Text.AlignVCenter
                }
            }
            Rectangle {
                id: td_4

                x: 164

                height: 20
                width: 40

                color: "transparent"

                Text {
                    id: day_picker_4

                    x: 13

                    height: 20
                    width: 15

                    color: "#757575"
                    font.family: "Geist"
                    font.pixelSize: 12
                    font.weight: Font.Normal
                    horizontalAlignment: Text.AlignHCenter
                    lineHeight: 20
                    lineHeightMode: Text.FixedHeight
                    text: "Th"
                    textFormat: Text.PlainText
                    verticalAlignment: Text.AlignVCenter
                }
            }
            Rectangle {
                id: td_5

                x: 205

                height: 20
                width: 40

                color: "transparent"

                Text {
                    id: day_picker_5

                    x: 14

                    height: 20
                    width: 13

                    color: "#757575"
                    font.family: "Geist"
                    font.pixelSize: 12
                    font.weight: Font.Normal
                    horizontalAlignment: Text.AlignHCenter
                    lineHeight: 20
                    lineHeightMode: Text.FixedHeight
                    text: "Fr"
                    textFormat: Text.PlainText
                    verticalAlignment: Text.AlignVCenter
                }
            }
            Rectangle {
                id: td_6

                x: 246

                height: 20
                width: 40

                color: "transparent"

                Text {
                    id: day_picker_6

                    x: 12.50

                    height: 20
                    width: 16

                    color: "#757575"
                    font.family: "Geist"
                    font.pixelSize: 12
                    font.weight: Font.Normal
                    horizontalAlignment: Text.AlignHCenter
                    lineHeight: 20
                    lineHeightMode: Text.FixedHeight
                    text: "Sa"
                    textFormat: Text.PlainText
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }
        Rectangle {
            id: tbody

            y: 36

            height: 204
            width: 286

            color: "transparent"

            Rectangle {
                id: row

                height: 40
                width: 286

                color: "transparent"

                Calendar_Button {
                    id: calendar_Button

                    _state: Calendar_Button.State_1.State_1_Hidden
                    number: "1"
                }
                Calendar_Button {
                    id: calendar_Button_1

                    x: 41

                    _state: Calendar_Button.State_1.State_1_Default
                    day_pickerTextFormat: Text.AutoText
                    day_pickerVisible: true
                    number: "1"
                }
                Calendar_Button {
                    id: calendar_Button_2

                    x: 82

                    _state: Calendar_Button.State_1.State_1_Default
                    day_pickerTextFormat: Text.AutoText
                    day_pickerVisible: true
                    day_pickerWidth: 11
                    day_pickerX: 15
                    number: "2"
                }
                Calendar_Button {
                    id: calendar_Button_3

                    x: 123

                    _state: Calendar_Button.State_1.State_1_Default
                    day_pickerTextFormat: Text.AutoText
                    day_pickerVisible: true
                    day_pickerWidth: 12
                    day_pickerX: 14.50
                    number: "3"
                }
                Calendar_Button {
                    id: calendar_Button_4

                    x: 164

                    _state: Calendar_Button.State_1.State_1_Default
                    day_pickerTextFormat: Text.AutoText
                    day_pickerVisible: true
                    day_pickerWidth: 12
                    day_pickerX: 14.50
                    number: "4"
                }
                Calendar_Button {
                    id: calendar_Button_5

                    x: 205

                    _state: Calendar_Button.State_1.State_1_Default
                    day_pickerTextFormat: Text.AutoText
                    day_pickerVisible: true
                    day_pickerWidth: 11
                    day_pickerX: 15
                    number: "5"
                }
                Calendar_Button {
                    id: calendar_Button_6

                    x: 246

                    _state: Calendar_Button.State_1.State_1_Default
                    day_pickerTextFormat: Text.AutoText
                    day_pickerVisible: true
                    day_pickerWidth: 11
                    day_pickerX: 15
                    number: "6"
                }
            }
            Rectangle {
                id: row_1

                y: 41

                height: 40
                width: 286

                color: "transparent"

                Calendar_Button {
                    id: calendar_Button_7

                    _state: Calendar_Button.State_1.State_1_Default
                    day_pickerTextFormat: Text.AutoText
                    day_pickerVisible: true
                    day_pickerWidth: 11
                    day_pickerX: 15
                    number: "7"
                }
                Calendar_Button {
                    id: calendar_Button_8

                    x: 41

                    _state: Calendar_Button.State_1.State_1_Default
                    day_pickerTextFormat: Text.AutoText
                    day_pickerVisible: true
                    day_pickerWidth: 11
                    day_pickerX: 15
                    number: "8"
                }
                Calendar_Button {
                    id: calendar_Button_9

                    x: 82

                    _state: Calendar_Button.State_1.State_1_Active
                    day_pickerWidth: 11
                    day_pickerX: 15
                    number: "9"
                }
                Calendar_Button {
                    id: calendar_Button_10

                    x: 123

                    _state: Calendar_Button.State_1.State_1_Range
                    day_pickerWidth: 19
                    day_pickerX: 11
                    number: "10"
                }
                Calendar_Button {
                    id: calendar_Button_11

                    x: 164

                    _state: Calendar_Button.State_1.State_1_Range
                    day_pickerWidth: 16
                    day_pickerX: 12.50
                    number: "11"
                }
                Calendar_Button {
                    id: calendar_Button_12

                    x: 205

                    _state: Calendar_Button.State_1.State_1_Range
                    day_pickerWidth: 19
                    day_pickerX: 11
                    number: "12"
                }
                Calendar_Button {
                    id: calendar_Button_13

                    x: 246

                    _state: Calendar_Button.State_1.State_1_Active
                    day_pickerWidth: 19
                    day_pickerX: 11
                    number: "13"
                }
            }
            Rectangle {
                id: row_2

                y: 82

                height: 40
                width: 286

                color: "transparent"

                Calendar_Button {
                    id: calendar_Button_14

                    _state: Calendar_Button.State_1.State_1_Default
                    day_pickerTextFormat: Text.AutoText
                    day_pickerVisible: true
                    day_pickerWidth: 19
                    day_pickerX: 11
                    number: "14"
                }
                Calendar_Button {
                    id: calendar_Button_15

                    x: 41

                    _state: Calendar_Button.State_1.State_1_Default
                    day_pickerTextFormat: Text.AutoText
                    day_pickerVisible: true
                    day_pickerWidth: 19
                    day_pickerX: 11
                    number: "15"
                }
                Calendar_Button {
                    id: calendar_Button_16

                    x: 82

                    _state: Calendar_Button.State_1.State_1_Default
                    day_pickerTextFormat: Text.AutoText
                    day_pickerVisible: true
                    day_pickerWidth: 19
                    day_pickerX: 11
                    number: "16"
                }
                Calendar_Button {
                    id: calendar_Button_17

                    x: 123

                    _state: Calendar_Button.State_1.State_1_Default
                    day_pickerTextFormat: Text.AutoText
                    day_pickerVisible: true
                    day_pickerWidth: 18
                    day_pickerX: 11.50
                    number: "17"
                }
                Calendar_Button {
                    id: calendar_Button_18

                    x: 164

                    _state: Calendar_Button.State_1.State_1_Default
                    day_pickerTextFormat: Text.AutoText
                    day_pickerVisible: true
                    day_pickerWidth: 19
                    day_pickerX: 11
                    number: "18"
                }
                Calendar_Button {
                    id: calendar_Button_19

                    x: 205

                    _state: Calendar_Button.State_1.State_1_Default
                    day_pickerTextFormat: Text.AutoText
                    day_pickerVisible: true
                    day_pickerWidth: 19
                    day_pickerX: 11
                    number: "19"
                }
                Calendar_Button {
                    id: calendar_Button_20

                    x: 246

                    _state: Calendar_Button.State_1.State_1_Default
                    day_pickerTextFormat: Text.AutoText
                    day_pickerVisible: true
                    day_pickerWidth: 21
                    day_pickerX: 10
                    number: "20"
                }
            }
            Rectangle {
                id: row_3

                y: 123

                height: 40
                width: 286

                color: "transparent"

                Calendar_Button {
                    id: calendar_Button_21

                    _state: Calendar_Button.State_1.State_1_Default
                    day_pickerTextFormat: Text.AutoText
                    day_pickerVisible: true
                    day_pickerWidth: 19
                    day_pickerX: 11
                    number: "21"
                }
                Calendar_Button {
                    id: calendar_Button_22

                    x: 41

                    _state: Calendar_Button.State_1.State_1_Default
                    day_pickerTextFormat: Text.AutoText
                    day_pickerVisible: true
                    day_pickerWidth: 21
                    day_pickerX: 10
                    number: "22"
                }
                Calendar_Button {
                    id: calendar_Button_23

                    x: 82

                    _state: Calendar_Button.State_1.State_1_Default
                    day_pickerTextFormat: Text.AutoText
                    day_pickerVisible: true
                    day_pickerWidth: 21
                    day_pickerX: 10
                    number: "23"
                }
                Calendar_Button {
                    id: calendar_Button_24

                    x: 123

                    _state: Calendar_Button.State_1.State_1_Default
                    day_pickerTextFormat: Text.AutoText
                    day_pickerVisible: true
                    day_pickerWidth: 21
                    day_pickerX: 10
                    number: "24"
                }
                Calendar_Button {
                    id: calendar_Button_25

                    x: 164

                    _state: Calendar_Button.State_1.State_1_Default
                    day_pickerTextFormat: Text.AutoText
                    day_pickerVisible: true
                    day_pickerWidth: 21
                    day_pickerX: 10
                    number: "25"
                }
                Calendar_Button {
                    id: calendar_Button_26

                    x: 205

                    _state: Calendar_Button.State_1.State_1_Default
                    day_pickerTextFormat: Text.AutoText
                    day_pickerVisible: true
                    day_pickerWidth: 21
                    day_pickerX: 10
                    number: "26"
                }
                Calendar_Button {
                    id: calendar_Button_27

                    x: 246

                    _state: Calendar_Button.State_1.State_1_Default
                    day_pickerTextFormat: Text.AutoText
                    day_pickerVisible: true
                    day_pickerWidth: 20
                    day_pickerX: 10.50
                    number: "27"
                }
            }
            Rectangle {
                id: row_4

                y: 164

                height: 40
                width: 286

                color: "transparent"

                Calendar_Button {
                    id: calendar_Button_28

                    _state: Calendar_Button.State_1.State_1_Default
                    day_pickerTextFormat: Text.AutoText
                    day_pickerVisible: true
                    day_pickerWidth: 21
                    day_pickerX: 10
                    number: "28"
                }
                Calendar_Button {
                    id: calendar_Button_29

                    x: 41

                    _state: Calendar_Button.State_1.State_1_Default
                    day_pickerTextFormat: Text.AutoText
                    day_pickerVisible: true
                    day_pickerWidth: 21
                    day_pickerX: 10
                    number: "29"
                }
                Calendar_Button {
                    id: calendar_Button_30

                    x: 82

                    _state: Calendar_Button.State_1.State_1_Default
                    day_pickerTextFormat: Text.AutoText
                    day_pickerVisible: true
                    day_pickerWidth: 22
                    day_pickerX: 9.50
                    number: "30"
                }
                Calendar_Button {
                    id: calendar_Button_31

                    x: 123

                    _state: Calendar_Button.State_1.State_1_Disabled
                    number: "1"
                }
                Calendar_Button {
                    id: calendar_Button_32

                    x: 164

                    _state: Calendar_Button.State_1.State_1_Disabled
                    day_pickerWidth: 11
                    day_pickerX: 15
                    number: "2"
                }
                Calendar_Button {
                    id: calendar_Button_33

                    x: 205

                    _state: Calendar_Button.State_1.State_1_Disabled
                    day_pickerWidth: 12
                    day_pickerX: 14.50
                    number: "3"
                }
                Calendar_Button {
                    id: calendar_Button_34

                    x: 246

                    _state: Calendar_Button.State_1.State_1_Disabled
                    day_pickerWidth: 12
                    day_pickerX: 14.50
                    number: "4"
                }
            }
        }
    }
}