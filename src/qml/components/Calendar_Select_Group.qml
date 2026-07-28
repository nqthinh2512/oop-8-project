import QtQuick

Rectangle {
    id: calendar_Select_Group

    property alias calendar_Month_FieldChevron_downX: calendar_Month_Field.chevron_downX
    property alias calendar_Month_FieldSelectWidth: calendar_Month_Field.selectWidth
    property alias calendar_Month_FieldSeptemberWidth: calendar_Month_Field.septemberWidth
    property alias calendar_Month_FieldWidth: calendar_Month_Field.width
    property alias calendar_Year_FieldChevron_downX: calendar_Year_Field.chevron_downX
    property alias calendar_Year_FieldElementWidth: calendar_Year_Field.elementWidth
    property alias calendar_Year_FieldSelectWidth: calendar_Year_Field.selectWidth
    property alias calendar_Year_FieldWidth: calendar_Year_Field.width
    property alias calendar_Year_FieldX: calendar_Year_Field.x

    height: 28
    width: 184

    color: "transparent"

    Calendar_Month_Field {
        id: calendar_Month_Field

        width: 88

        chevron_downX: 66
        optionsSource: Qt.resolvedUrl("../assets/options_4.png")
        selectWidth: 88
        septemberWidth: 53
        value: "Sep"
    }
    Calendar_Year_Field {
        id: calendar_Year_Field

        x: 96

        width: 88

        chevron_downX: 66
        elementWidth: 53
        selectWidth: 88
    }
}