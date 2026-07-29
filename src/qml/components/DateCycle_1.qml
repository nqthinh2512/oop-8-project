import QtQuick
import QtQuick.Layouts

Item {
    enum Period { Period_weekly, Period_monthly, Period_yearly }

    id: root

    property int period_1: DateCycle_1.Period.Period_yearly
    property string startDate: "31/12/2012"
    property string endDate: "31/12/2013"

    implicitHeight: 44
    Layout.fillWidth: true

    readonly property string periodText: {
        if (root.period_1 === DateCycle_1.Period.Period_weekly) return "Weekly";
        if (root.period_1 === DateCycle_1.Period.Period_monthly) return "Monthly";
        return "Yearly";
    }

    RowLayout {
        anchors.fill: parent
        anchors.verticalCenter: parent.verticalCenter
        spacing: 12

        // Start & End Dates Column
        ColumnLayout {
            spacing: 2
            Layout.alignment: Qt.AlignVCenter

            Text {
                font.family: "Intel One Mono"
                font.pixelSize: 12
                color: "#64748b"
                text: "Start: " + root.startDate
            }

            Text {
                font.family: "Intel One Mono"
                font.pixelSize: 12
                color: "#64748b"
                text: "End: " + root.endDate
            }
        }

        Item { Layout.fillWidth: true }

        // Cycle Pill Badge (e.g., 🕒 Yearly)
        Rectangle {
            implicitWidth: cycleRow.implicitWidth + 14
            implicitHeight: 22
            radius: 11
            color: "#e0f2fe"
            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter

            RowLayout {
                id: cycleRow
                anchors.centerIn: parent
                spacing: 4

                Text {
                    text: "🕒"
                    font.pixelSize: 10
                    color: "#0284c7"
                }

                Text {
                    font.family: "Inter"
                    font.pixelSize: 11
                    font.weight: Font.Bold
                    color: "#0284c7"
                    text: root.periodText
                }
            }
        }
    }
}