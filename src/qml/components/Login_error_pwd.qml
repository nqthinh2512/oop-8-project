import QtQuick

Rectangle {
    id: login_error_pwd

    height: 1117
    width: 1728

    clip: true
    color: "#f3fbff"

    Form_Log_In {
        id: form_Log_In

        x: 624
        y: 298

        height: 520
        width: 480

        button_GroupButton_1ButtonBorderColor: "#0225d4"
        button_GroupButton_1Button_1FontLetterSpacing: -0.48
        button_GroupButton_1Button_1FontPixelSize: 24
        button_GroupButton_1Button_1FontWeight: Font.DemiBold
        button_GroupButton_1Button_1Height: 29
        button_GroupButton_1Button_1LineHeight: 28.80
        button_GroupButton_1Button_1Width: 77
        button_GroupButton_1Button_1X: 170
        button_GroupButton_1Color: "#0225d4"
        button_GroupButton_1Height: 53
        button_GroupButton_1Width: 416
        button_GroupHeight: 53
        button_GroupWidth: 416
        button_GroupX: 32
        button_GroupY: 337.50
        input_FieldHeight: 89
        input_FieldInputHeight: 52
        input_FieldInputWidth: 416
        input_FieldInputY: 37
        input_FieldLabelFontLetterSpacing: -0.48
        input_FieldLabelFontPixelSize: 24
        input_FieldLabelFontWeight: Font.DemiBold
        input_FieldLabelHeight: 29
        input_FieldLabelLineHeight: 28.80
        input_FieldLabelWidth: 417
        input_FieldValue: "username@st.hcmus.vn"
        input_FieldValueFontFamily: "Roboto"
        input_FieldValueFontPixelSize: 22
        input_FieldValueHeight: 28
        input_FieldValueLineHeight: 28
        input_FieldValueWidth: 385
        input_FieldWidth: 416
        input_FieldX: 32
        input_FieldY: 61.50
        input_Field_1Error: "Your entered username or password incorrectly."
        input_Field_1ErrorColor: "#ec221f"
        input_Field_1ErrorWidth: 364
        input_Field_1ErrorY: 85
        input_Field_1Has_Error: true
        input_Field_1Height: 107
        input_Field_1InputWidth: 416
        input_Field_1InputY: 37
        input_Field_1LabelFontLetterSpacing: -0.48
        input_Field_1LabelFontPixelSize: 24
        input_Field_1LabelFontWeight: Font.DemiBold
        input_Field_1LabelHeight: 29
        input_Field_1LabelLineHeight: 28.80
        input_Field_1LabelWidth: 417
        input_Field_1ValueFontFamily: "Roboto"
        input_Field_1ValueFontPixelSize: 22
        input_Field_1ValueHeight: 28
        input_Field_1ValueLineHeight: 28
        input_Field_1ValueVisible: false
        input_Field_1Width: 416
        input_Field_1X: 32
        input_Field_1Y: 190.50
        text_LinkHeight: 28
        text_LinkText_Link_1FontFamily: "Roboto"
        text_LinkText_Link_1FontPixelSize: 22
        text_LinkText_Link_1FontUnderline: false
        text_LinkText_Link_1Height: 28
        text_LinkText_Link_1LineHeight: 28
        text_LinkText_Link_1Width: 177
        text_LinkWidth: 416
        text_LinkX: 32
        text_LinkY: 430.50
    }
    Rectangle {
        id: pwd

        x: 672
        y: 540

        height: 12
        width: 117

        color: "transparent"

        Image {
            id: ellipse_2

            source: Qt.resolvedUrl("../assets/ellipse_34.png")
        }
        Image {
            id: ellipse_3

            x: 15

            source: Qt.resolvedUrl("../assets/ellipse_35.png")
        }
        Image {
            id: ellipse_5

            x: 30

            source: Qt.resolvedUrl("../assets/ellipse_36.png")
        }
        Image {
            id: ellipse_4

            x: 45

            source: Qt.resolvedUrl("../assets/ellipse_37.png")
        }
        Image {
            id: ellipse_6

            x: 60

            source: Qt.resolvedUrl("../assets/ellipse_38.png")
        }
        Image {
            id: ellipse_7

            x: 75

            source: Qt.resolvedUrl("../assets/ellipse_39.png")
        }
        Image {
            id: ellipse_8

            x: 90

            source: Qt.resolvedUrl("../assets/ellipse_40.png")
        }
        Image {
            id: ellipse_9

            x: 105

            source: Qt.resolvedUrl("../assets/ellipse_41.png")
        }
    }
    Eye_off {
        id: eye_off

        x: 1032
        y: 534

        height: 24
        width: 24

        _size: Eye_off.Size.Size_24
        clip: true
    }
}