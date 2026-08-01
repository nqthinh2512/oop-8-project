import QtQuick
import QtQuick.Controls

Rectangle {
    id: date_Input_Field

    height: 42
    width: 460

    color: "#e9e9e9"
    radius: 8

    property string selectedDate: ""
    signal dateSelected(string dateStr)

    // Helper to format date numbers to 2 digits
    function pad(n) { return n < 10 ? "0" + n : "" + n }

    // Set date programmatically or from calendar picker
    function setDate(d, m, y) {
        dayInput.text = pad(d)
        monthInput.text = pad(m)
        yearInput.text = y.toString()
        selectedDate = dayInput.text + "/" + monthInput.text + "/" + yearInput.text
        dateSelected(selectedDate)
    }

    function clear() {
        dayInput.text = ""
        monthInput.text = ""
        yearInput.text = ""
        selectedDate = ""
    }

    function updateDateFromInputs() {
        if (dayInput.text !== "" && monthInput.text !== "" && yearInput.text !== "") {
            selectedDate = pad(parseInt(dayInput.text || 0)) + "/" + pad(parseInt(monthInput.text || 0)) + "/" + yearInput.text;
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
            color: "#1e1e1e"
            font.family: "Roboto"
            font.pixelSize: 16
            font.weight: Font.Medium
            maximumLength: 2
            inputMethodHints: Qt.ImhDigitsOnly
            selectByMouse: true

            Text {
                text: "DD"
                color: "#8049454f"
                font: parent.font
                visible: !parent.text && !parent.activeFocus
                anchors.fill: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            onTextChanged: {
                if (text.length === 2) monthInput.forceActiveFocus()
                updateDateFromInputs()
            }
        }

        Text {
            text: "/"
            color: "#878787"
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
            color: "#1e1e1e"
            font.family: "Roboto"
            font.pixelSize: 16
            font.weight: Font.Medium
            maximumLength: 2
            inputMethodHints: Qt.ImhDigitsOnly
            selectByMouse: true

            Text {
                text: "MM"
                color: "#8049454f"
                font: parent.font
                visible: !parent.text && !parent.activeFocus
                anchors.fill: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            onTextChanged: {
                if (text.length === 2) yearInput.forceActiveFocus()
                updateDateFromInputs()
            }
        }

        Text {
            text: "/"
            color: "#878787"
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
            color: "#1e1e1e"
            font.family: "Roboto"
            font.pixelSize: 16
            font.weight: Font.Medium
            maximumLength: 4
            inputMethodHints: Qt.ImhDigitsOnly
            selectByMouse: true

            Text {
                text: "YYYY"
                color: "#8049454f"
                font: parent.font
                visible: !parent.text && !parent.activeFocus
                anchors.fill: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            onTextChanged: updateDateFromInputs()
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
            color: "#ffffff"
            radius: 12
            border.color: "#cbd5e1"
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
                    color: "#1e293b"
                    verticalAlignment: Text.AlignVCenter
                }

                Rectangle {
                    width: 28; height: 28; radius: 6; color: "#f1f5f9"
                    Text { text: "◀"; anchors.centerIn: parent; font.pixelSize: 10; color: "#475569" }
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: prevMonth()
                    }
                }

                Rectangle {
                    width: 28; height: 28; radius: 6; color: "#f1f5f9"
                    Text { text: "▶"; anchors.centerIn: parent; font.pixelSize: 10; color: "#475569" }
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
                        color: "#94a3b8"
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
                        color: (index + 1 === currentDay) ? "#3b82f6" : (dayMouse.containsMouse ? "#eff6ff" : "transparent")

                        Text {
                            text: (index + 1).toString()
                            anchors.centerIn: parent
                            font.pixelSize: 12
                            font.weight: (index + 1 === currentDay) ? Font.Bold : Font.Normal
                            color: (index + 1 === currentDay) ? "#ffffff" : "#334155"
                        }

                        MouseArea {
                            id: dayMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                setDate(index + 1, currentMonthIndex + 1, currentYear)
                                datePickerPopup.close()
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