import QtQuick

Rectangle {
    id: form_Log_In

    property alias button_GroupButtonButton_1X: button_Group.buttonButton_1X
    property alias button_GroupButton_1ButtonBorderColor: button_Group.button_1ButtonBorderColor
    property alias button_GroupButton_1Button_1Color: button_Group.button_1Button_1Color
    property alias button_GroupButton_1Button_1FontLetterSpacing: button_Group.button_1Button_1FontLetterSpacing
    property alias button_GroupButton_1Button_1FontPixelSize: button_Group.button_1Button_1FontPixelSize
    property alias button_GroupButton_1Button_1FontWeight: button_Group.button_1Button_1FontWeight
    property alias button_GroupButton_1Button_1Height: button_Group.button_1Button_1Height
    property alias button_GroupButton_1Button_1LineHeight: button_Group.button_1Button_1LineHeight
    property alias button_GroupButton_1Button_1Width: button_Group.button_1Button_1Width
    property alias button_GroupButton_1Button_1X: button_Group.button_1Button_1X
    property alias button_GroupButton_1Color: button_Group.button_1Color
    property alias button_GroupButton_1Height: button_Group.button_1Height
    property alias button_GroupButton_1StarIcon_ShapePath0StrokeColor: button_Group.button_1StarIcon_ShapePath0StrokeColor
    property alias button_GroupButton_1Width: button_Group.button_1Width
    property alias button_GroupButton_1_variant: button_Group.button_1_variant
    property alias button_GroupButton_1_xIcon_ShapePath0StrokeColor: button_Group.button_1_xIcon_ShapePath0StrokeColor
    property alias button_GroupHeight: button_Group.height
    property alias button_GroupWidth: button_Group.width
    property alias button_GroupX: button_Group.x
    property alias button_GroupY: button_Group.y
    property alias input_FieldHeight: input_Field.height
    property alias input_FieldInputHeight: input_Field.inputHeight
    property alias input_FieldInputWidth: input_Field.inputWidth
    property alias input_FieldInputY: input_Field.inputY
    property alias input_FieldLabelFontLetterSpacing: input_Field.labelFontLetterSpacing
    property alias input_FieldLabelFontPixelSize: input_Field.labelFontPixelSize
    property alias input_FieldLabelFontWeight: input_Field.labelFontWeight
    property alias input_FieldLabelHeight: input_Field.labelHeight
    property alias input_FieldLabelLineHeight: input_Field.labelLineHeight
    property alias input_FieldLabelWidth: input_Field.labelWidth
    property alias input_FieldValue: input_Field.value
    property alias input_FieldValueColor: input_Field.valueColor
    property alias input_FieldValueFontFamily: input_Field.valueFontFamily
    property alias input_FieldValueFontPixelSize: input_Field.valueFontPixelSize
    property alias input_FieldValueHeight: input_Field.valueHeight
    property alias input_FieldValueLineHeight: input_Field.valueLineHeight
    property alias input_FieldValueWidth: input_Field.valueWidth
    property alias input_FieldWidth: input_Field.width
    property alias input_FieldX: input_Field.x
    property alias input_FieldY: input_Field.y
    property alias input_Field_1Error: input_Field_1.error
    property alias input_Field_1ErrorColor: input_Field_1.errorColor
    property alias input_Field_1ErrorWidth: input_Field_1.errorWidth
    property alias input_Field_1ErrorY: input_Field_1.errorY
    property alias input_Field_1Has_Error: input_Field_1.has_Error
    property alias input_Field_1Height: input_Field_1.height
    property alias input_Field_1InputHeight: input_Field_1.inputHeight
    property alias input_Field_1InputWidth: input_Field_1.inputWidth
    property alias input_Field_1InputY: input_Field_1.inputY
    property alias input_Field_1LabelFontLetterSpacing: input_Field_1.labelFontLetterSpacing
    property alias input_Field_1LabelFontPixelSize: input_Field_1.labelFontPixelSize
    property alias input_Field_1LabelFontWeight: input_Field_1.labelFontWeight
    property alias input_Field_1LabelHeight: input_Field_1.labelHeight
    property alias input_Field_1LabelLineHeight: input_Field_1.labelLineHeight
    property alias input_Field_1LabelWidth: input_Field_1.labelWidth
    property alias input_Field_1Value: input_Field_1.value
    property alias input_Field_1ValueColor: input_Field_1.valueColor
    property alias input_Field_1ValueFontFamily: input_Field_1.valueFontFamily
    property alias input_Field_1ValueFontPixelSize: input_Field_1.valueFontPixelSize
    property alias input_Field_1ValueHeight: input_Field_1.valueHeight
    property alias input_Field_1ValueLineHeight: input_Field_1.valueLineHeight
    property alias input_Field_1ValueVisible: input_Field_1.valueVisible
    property alias input_Field_1ValueWidth: input_Field_1.valueWidth
    property alias input_Field_1Width: input_Field_1.width
    property alias input_Field_1X: input_Field_1.x
    property alias input_Field_1Y: input_Field_1.y
    property alias text_LinkHeight: text_Link.height
    property alias text_LinkText_Link_1FontFamily: text_Link.text_Link_1FontFamily
    property alias text_LinkText_Link_1FontPixelSize: text_Link.text_Link_1FontPixelSize
    property alias text_LinkText_Link_1FontUnderline: text_Link.text_Link_1FontUnderline
    property alias text_LinkText_Link_1Height: text_Link.text_Link_1Height
    property alias text_LinkText_Link_1LineHeight: text_Link.text_Link_1LineHeight
    property alias text_LinkText_Link_1Width: text_Link.text_Link_1Width
    property alias text_LinkWidth: text_Link.width
    property alias text_LinkX: text_Link.x
    property alias text_LinkY: text_Link.y

    height: 322
    width: 320

    border.color: "#d9d9d9"
    border.width: 1
    color: "#ffffff"
    radius: 8

    Input_Field {
        id: input_Field

        x: 24
        y: 24

        width: 272

        _state: Input_Field.State_1.State_1_Default
        description: "Description"
        error: "Error"
        has_Description: false
        has_Error: false
        has_Label: true
        inputWidth: 272
        label: "Email"
        labelWidth: 273
        value: "Value"
        valueWidth: 241
        value_Type_1: Input_Field.Value_Type.Value_Type_Placeholder
    }
    Input_Field {
        id: input_Field_1

        x: 24
        y: 118

        width: 272

        _state: Input_Field.State_1.State_1_Default
        description: "Description"
        error: "Error"
        has_Description: false
        has_Error: false
        has_Label: true
        inputWidth: 272
        label: "Password"
        labelWidth: 273
        value: "Value"
        valueWidth: 241
        value_Type_1: Input_Field.Value_Type.Value_Type_Placeholder
    }
    Button_Group {
        id: button_Group

        x: 24
        y: 212

        width: 272

        align_1: Button_Group.Align.Align_Justify
        button_1Button_1Width: 53
        button_1Button_1X: 110
        button_1Label: "Sign In"
        button_1Width: 272
        button_End: true
        button_Start: false
    }
    Text_Link {
        id: text_Link

        x: 24
        y: 276

        width: 272

        _text: "Forgot password?"
        text_Link_1Width: 137
    }
}