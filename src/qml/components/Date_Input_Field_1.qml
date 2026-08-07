import QtQuick
import src
import QtQuick.Controls

Rectangle {
    id: date_Input_Field

    height: 42
    width: 460

    color: AppTheme.bgInput
    radius: 8

    property bool allowFutureDates: false
    property bool showValidationError: false
    property bool isInstantlyInvalid: {
        if (dayInput.text === "" || monthInput.text === "" || yearInput.text.length < 4) return false;
        return selectedDate === "";
    }

    border.color: (showValidationError || isInstantlyInvalid) ? "red" : "transparent"
    border.width: (showValidationError || isInstantlyInvalid) ? 1 : 0

    property string text: ""
    property string selectedDate: ""
    signal dateSelected(string dateStr)

    property bool _internalChange: false

    onTextChanged: {
        if (_internalChange) return
        _internalChange = true
        if (!text) {
            dayInput.text = ""
            monthInput.text = ""
            yearInput.text = ""
            selectedDate = ""
        } else {
            var parts = text.split("/")
            if (parts.length === 3) {
                dayInput.text = parts[0]
                monthInput.text = parts[1]
                yearInput.text = parts[2]
            }
        }
        _internalChange = false
        updateDateFromInputs()
    }

    function updateTextFromInputs() {
        if (_internalChange) return
        _internalChange = true
        var d = dayInput.text.trim()
        var m = monthInput.text.trim()
        var y = yearInput.text.trim()

        var formatted = d + "/" + m + "/" + y
        text = formatted
        _internalChange = false
        
        updateDateFromInputs()
    }

    // Helper to format date numbers to 2 digits
    function pad(n) {
        var val = parseInt(n) || 0
        return val < 10 ? "0" + val : "" + val
    }

    // Set date programmatically or from calendar picker
    function setDate(d, m, y) {
        _internalChange = true
        dayInput.text = pad(d)
        monthInput.text = pad(m)
        yearInput.text = y.toString()
        var formatted = dayInput.text + "/" + monthInput.text + "/" + yearInput.text
        selectedDate = formatted
        text = formatted
        _internalChange = false
        dateSelected(selectedDate)
    }

    function clear() {
        var d = new Date()
        setDate(d.getDate(), d.getMonth() + 1, d.getFullYear())
    }

    function updateDateFromInputs() {
        if (dayInput.text !== "" && monthInput.text !== "" && yearInput.text !== "") {
            var d = parseInt(dayInput.text || 0)
            var m = parseInt(monthInput.text || 0)
            var y = parseInt(yearInput.text || 0)
            var dateObj = new Date(y, m - 1, d)
            var today = new Date()
            today.setHours(23, 59, 59, 999)
            
            var isYearValid = y >= 2000;
            var isDateObjValid = (dateObj.getDate() === d && dateObj.getMonth() === m - 1);
            var isFutureValid = allowFutureDates ? true : (dateObj <= today);

            if (isYearValid && isDateObjValid && isFutureValid) {
                selectedDate = pad(d) + "/" + pad(m) + "/" + y;
            } else {
                selectedDate = ""; // Invalid
            }
        } else {
            selectedDate = "";
        }
    }

    // --- Interactive Date Input Segmented Fields (DD / MM / YYYY) ---
    Row {
        id: dateRow
        x: 15
        anchors.verticalCenter: parent.verticalCenter
        spacing: 6

        // Day (DD) Segment
        TextInput {
            id: dayInput
            width: 28
            height: 24
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            color: AppTheme.textMain
            font.family: "Roboto"
            font.pixelSize: 16
            font.weight: Font.Medium
            maximumLength: 2
            inputMethodHints: Qt.ImhDigitsOnly
            selectByMouse: true

            Text {
                text: "DD"
                color: AppTheme.textMuted
                font: parent.font
                visible: !parent.text && !parent.activeFocus
                anchors.fill: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            onTextChanged: {
                if (text.length === 2) monthInput.forceActiveFocus()
                date_Input_Field.updateTextFromInputs()
            }
        }

        Text {
            text: "/"
            color: AppTheme.textMuted
            font.family: "Roboto"
            font.pixelSize: 16
            anchors.verticalCenter: parent.verticalCenter
        }

        // Month (MM) Segment
        TextInput {
            id: monthInput
            width: 28
            height: 24
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            color: AppTheme.textMain
            font.family: "Roboto"
            font.pixelSize: 16
            font.weight: Font.Medium
            maximumLength: 2
            inputMethodHints: Qt.ImhDigitsOnly
            selectByMouse: true

            Text {
                text: "MM"
                color: AppTheme.textMuted
                font: parent.font
                visible: !parent.text && !parent.activeFocus
                anchors.fill: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            onTextChanged: {
                if (text.length === 2) yearInput.forceActiveFocus()
                date_Input_Field.updateTextFromInputs()
            }
        }

        Text {
            text: "/"
            color: AppTheme.textMuted
            font.family: "Roboto"
            font.pixelSize: 16
            anchors.verticalCenter: parent.verticalCenter
        }

        // Year (YYYY) Segment
        TextInput {
            id: yearInput
            width: 50
            height: 24
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            color: AppTheme.textMain
            font.family: "Roboto"
            font.pixelSize: 16
            font.weight: Font.Medium
            maximumLength: 4
            inputMethodHints: Qt.ImhDigitsOnly
            selectByMouse: true

            Text {
                text: "YYYY"
                color: AppTheme.textMuted
                font: parent.font
                visible: !parent.text && !parent.activeFocus
                anchors.fill: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            onTextChanged: {
                date_Input_Field.updateTextFromInputs()
            }
        }
    }

    // --- Rightmost Calendar Picker Button 📅 ---
    Item {
        id: calendarBtn
        anchors.right: parent.right
        anchors.rightMargin: 12
        anchors.verticalCenter: parent.verticalCenter
        width: 24
        height: 24

        Text {
            text: "📅"
            font.pixelSize: 18
            anchors.centerIn: parent
        }

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: datePickerPopup.open()
        }
    }

    // --- Popup Calendar Picker Window ---
    Popup {
        id: datePickerPopup
        x: date_Input_Field.width - width
        y: date_Input_Field.height + 4
        width: 260
        height: 270
        padding: 10
        modal: true
        focus: true

        background: Rectangle {
            color: AppTheme.bgCard
            radius: 12
            border.color: AppTheme.divider
            border.width: 1
        }

        Column {
            anchors.fill: parent
            spacing: 8

            // Header: Month & Year Navigation
            Row {
                width: parent.width
                spacing: 4

                Text {
                    width: 170
                    text: currentMonthName + " " + currentYear
                    font.family: "Inter"
                    font.pixelSize: 14
                    font.weight: Font.Bold
                    color: AppTheme.textMain
                    verticalAlignment: Text.AlignVCenter
                }

                Rectangle {
                    width: 28; height: 28; radius: 6; color: AppTheme.bgHover
                    Text { text: "◀"; anchors.centerIn: parent; font.pixelSize: 10; color: AppTheme.textMain }
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: prevMonth()
                    }
                }

                Rectangle {
                    width: 28; height: 28; radius: 6; color: AppTheme.bgHover
                    Text { text: "▶"; anchors.centerIn: parent; font.pixelSize: 10; color: AppTheme.textMain }
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: nextMonth()
                    }
                }
            }

            // Days of Week Header Row
            Grid {
                columns: 7
                spacing: 4
                Repeater {
                    model: ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"]
                    Text {
                        width: 30; height: 20
                        text: modelData
                        font.pixelSize: 11
                        font.weight: Font.Bold
                        color: AppTheme.textMuted
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }
            }

            // Interactive Days Grid (1..31)
            Grid {
                columns: 7
                spacing: 4

                Repeater {
                    model: daysInMonth

                    Rectangle {
                        width: 30; height: 30; radius: 15
                        property var itemDate: new Date(currentYear, currentMonthIndex, index + 1)
                        property var today: new Date()
                        property bool isValidDate: {
                            today.setHours(23, 59, 59, 999);
                            return itemDate.getFullYear() >= 2000 && (allowFutureDates ? true : itemDate <= today);
                        }

                        property bool isToday: {
                            var t = new Date();
                            return (index + 1 === currentDay) && (currentMonthIndex === t.getMonth()) && (currentYear === t.getFullYear());
                        }

                        color: isToday ? AppTheme.primary : (dayMouse.containsMouse && isValidDate ? AppTheme.bgHover : "transparent")
                        opacity: isValidDate ? 1.0 : 0.3

                        Text {
                            text: (index + 1).toString()
                            anchors.centerIn: parent
                            font.pixelSize: 12
                            font.weight: isToday ? Font.Bold : Font.Normal
                            color: isToday ? "#ffffff" : AppTheme.textMain
                        }

                        MouseArea {
                            id: dayMouse
                            anchors.fill: parent
                            hoverEnabled: isValidDate
                            cursorShape: isValidDate ? Qt.PointingHandCursor : Qt.ForbiddenCursor
                            onClicked: {
                                if (isValidDate) {
                                    setDate(index + 1, currentMonthIndex + 1, currentYear)
                                    datePickerPopup.close()
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    // --- Internal Date Picker State Logic ---
    property var monthNames: ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    property int currentMonthIndex: new Date().getMonth()
    property int currentYear: new Date().getFullYear()
    property int currentDay: new Date().getDate()
    property string currentMonthName: monthNames[currentMonthIndex]
    property int daysInMonth: new Date(currentYear, currentMonthIndex + 1, 0).getDate()

    function prevMonth() {
        if (currentMonthIndex === 0) {
            currentMonthIndex = 11
            currentYear--
        } else {
            currentMonthIndex--
        }
    }

    function nextMonth() {
        if (currentMonthIndex === 11) {
            currentMonthIndex = 0
            currentYear++
        } else {
            currentMonthIndex++
        }
    }
}
