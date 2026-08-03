import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Dialogs

import "../components"

Rectangle {
    id: reportsPage

    color: "#f8fafc"
    clip: true

    FileDialog {
        id: exportFileDialog
        title: "Export Reports Data to CSV"
        fileMode: FileDialog.SaveFile
        nameFilters: ["CSV Files (*.csv)", "All Files (*)"]
        defaultSuffix: "csv"
        currentFile: "reports_export.csv"
        onAccepted: {
            reportsController.exportToCSV(selectedFile.toString())
        }
    }

    onVisibleChanged: {
        if (visible) {
            reportsController.refresh()
        }
    }

    ScrollView {
        id: scrollView
        anchors.fill: parent
        clip: true

        Item {
            width: scrollView.availableWidth
            implicitHeight: mainLayout.implicitHeight + 48

            ColumnLayout {
                id: mainLayout
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.margins: 24
                spacing: 24

                // =================================================================
                // 1. PAGE TITLE & DIVIDER LINE
                // =================================================================
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 16

                    RowLayout {
                        Layout.fillWidth: true

                        Text {
                            text: "Reports"
                            font.family: "Inter"
                            font.pixelSize: 32
                            font.weight: Font.Bold
                            color: "#0f172a"
                        }

                        Item { Layout.fillWidth: true }

                        UniversalButton_1 {
                            buttonText: "Export CSV"
                            onClicked: exportFileDialog.open()
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        height: 1
                        color: "#e2e8f0"
                    }
                }

                // =================================================================
                // 2. ROW 1: 4 TOP KPI CARDS (Proportionally Equal)
                // =================================================================
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 20

                    ReportBox1_1 {
                        titleText: "MONTHLY INCOME"
                        amountText: reportsController.monthlyIncomeFormatted
                        labelText: "Current Month"
                        subtitleText: "Total Earned"
                        subtitleColor: "#10b981"
                        Layout.fillWidth: true
                        Layout.preferredWidth: 1
                    }

                    ReportBox1_1 {
                        titleText: "MONTHLY EXPENSES"
                        amountText: reportsController.monthlyExpenseFormatted
                        labelText: "Current Month"
                        subtitleText: "Total Spent"
                        subtitleColor: "#ef4444"
                        Layout.fillWidth: true
                        Layout.preferredWidth: 1
                    }

                    ReportBox1_1 {
                        titleText: "NET WORTH"
                        amountText: reportsController.netWorthFormatted
                        labelText: "Total Balance"
                        subtitleText: "Cumulative"
                        subtitleColor: "#6366f1"
                        Layout.fillWidth: true
                        Layout.preferredWidth: 1
                    }

                    ReportBox1_1 {
                        titleText: "SAVINGS RATE"
                        amountText: reportsController.savingsRateFormatted
                        labelText: "Of Monthly Income"
                        subtitleText: "Net Savings %"
                        subtitleColor: "#0284c7"
                        Layout.fillWidth: true
                        Layout.preferredWidth: 1
                    }
                }

                // =================================================================
                // 3. ROW 2: 3 SNAPSHOT CARDS (Bills, Budgets, Savings)
                // =================================================================
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 20

                    ReportBox2_1 {
                        titleText: "Bills"
                        row1Label: "Total Due"
                        row1Amount: reportsController.billsSnapshot.dueFormatted || "0 VND"
                        row2Label: "Overdue"
                        row2Amount: reportsController.billsSnapshot.overdueFormatted || "0 VND"
                        row3Label: "Paid"
                        row3Amount: reportsController.billsSnapshot.paidFormatted || "0 VND"
                        Layout.fillWidth: true
                        Layout.preferredWidth: 1
                    }

                    ReportBox2_1 {
                        titleText: "Budgets"
                        row1Label: "Total Spent"
                        row1Amount: reportsController.budgetsSnapshot.spentFormatted || "0 VND"
                        row2Label: "Total Limit"
                        row2Amount: reportsController.budgetsSnapshot.limitFormatted || "0 VND"
                        row3Label: "Remaining"
                        row3Amount: reportsController.budgetsSnapshot.remainingFormatted || "0 VND"
                        Layout.fillWidth: true
                        Layout.preferredWidth: 1
                    }

                    ReportBox2_1 {
                        titleText: "Savings"
                        row1Label: "Total Saved"
                        row1Amount: reportsController.savingsSnapshot.savedFormatted || "0 VND"
                        row2Label: "Total Target"
                        row2Amount: reportsController.savingsSnapshot.targetFormatted || "0 VND"
                        row3Label: "Remaining"
                        row3Amount: reportsController.savingsSnapshot.remainingFormatted || "0 VND"
                        Layout.fillWidth: true
                        Layout.preferredWidth: 1
                    }
                }

                // =================================================================
                // 4. ROW 3: 2 MAIN CHARTS (Income vs Expense | Net Worth)
                // =================================================================
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 20

                    // Left Chart: Income vs Expense
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredWidth: 1
                        implicitHeight: 340
                        color: "#ffffff"
                        border.color: "#e2e8f0"
                        border.width: 1
                        radius: 12
                        clip: true

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: 20
                            spacing: 12

                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 2

                                Text {
                                    text: "Income vs Expense"
                                    font.family: "Inter"
                                    font.pixelSize: 18
                                    font.weight: Font.Bold
                                    color: "#0f172a"
                                }

                                Text {
                                    text: "Last 6 Months"
                                    font.family: "Inter"
                                    font.pixelSize: 13
                                    color: "#64748b"
                                }
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                height: 1
                                color: "#e2e8f0"
                            }

                            // Bar Chart Canvas
                            Rectangle {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                color: "#f8fafc"
                                radius: 8
                                border.color: "#f1f5f9"

                                Canvas {
                                    id: rptBarCanvas
                                    anchors.fill: parent
                                    anchors.margins: 12

                                    Connections {
                                        target: reportsController
                                        function onReportChanged() {
                                            rptBarCanvas.requestPaint()
                                        }
                                    }
                                    onPaint: {
                                        var ctx = getContext("2d");
                                        ctx.reset();

                                        var padL = 42, padB = 24, padT = 15, padR = 12;
                                        var chartW = width - padL - padR;
                                        var chartH = height - padT - padB;

                                        // Y-Axis Value Labels & Gridlines
                                        ctx.font = "11px 'Inter', sans-serif";
                                        ctx.fillStyle = "#94a3b8";
                                        ctx.textAlign = "right";
                                        ctx.textBaseline = "middle";
                                        ctx.strokeStyle = "#f1f5f9";
                                        ctx.lineWidth = 1;

                                        var chartData = reportsController.monthlyChartData;
                                        var yTicks = (chartData && chartData.yTicks) ? chartData.yTicks : ["20M", "15M", "10M", "5M", "0"];
                                        for (var i = 0; i < yTicks.length; i++) {
                                            var ratio = i / (yTicks.length - 1);
                                            var y = padT + ratio * chartH;
                                            ctx.fillText(yTicks[i], padL - 8, y);

                                            ctx.beginPath();
                                            ctx.moveTo(padL, y);
                                            ctx.lineTo(width - padR, y);
                                            ctx.stroke();
                                        }

                                        // Bars & X-Axis Labels
                                        var months = (chartData && chartData.months) ? chartData.months : ["Jan", "Feb", "Mar", "Apr", "May", "Jun"];
                                        var incomeRatios = (chartData && chartData.incomeRatios) ? chartData.incomeRatios : [0, 0, 0, 0, 0, 0];
                                        var expenseRatios = (chartData && chartData.expenseRatios) ? chartData.expenseRatios : [0, 0, 0, 0, 0, 0];

                                        var count = months.length;
                                        var groupWidth = chartW / count;
                                        var barWidth = Math.min(20, groupWidth * 0.30);

                                        ctx.textAlign = "center";
                                        ctx.textBaseline = "top";

                                        for (var b = 0; b < count; b++) {
                                            var groupCenterX = padL + groupWidth * b + groupWidth / 2;
                                            var xInc = groupCenterX - barWidth - 1;
                                            var xExp = groupCenterX + 1;

                                            var hInc = incomeRatios[b] * chartH;
                                            var hExp = expenseRatios[b] * chartH;

                                            ctx.fillStyle = "#10b981";
                                            ctx.fillRect(xInc, padT + chartH - hInc, barWidth, hInc);

                                            ctx.fillStyle = "#ef4444";
                                            ctx.fillRect(xExp, padT + chartH - hExp, barWidth, hExp);

                                            ctx.fillStyle = "#94a3b8";
                                            ctx.fillText(months[b], groupCenterX, padT + chartH + 6);
                                        }
                                    }
                                    onWidthChanged: requestPaint()
                                    onHeightChanged: requestPaint()
                                }
                            }

                            // Bottom Legend
                            RowLayout {
                                Layout.fillWidth: true
                                spacing: 16

                                Indicator_1 {
                                    labelText: "Income"
                                    dotColor: "#10b981"
                                }

                                Indicator_1 {
                                    labelText: "Expense"
                                    dotColor: "#ef4444"
                                }
                            }
                        }
                    }

                    // Right Chart: Net Worth
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredWidth: 1
                        implicitHeight: 340
                        color: "#ffffff"
                        border.color: "#e2e8f0"
                        border.width: 1
                        radius: 12
                        clip: true

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: 20
                            spacing: 12

                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 2

                                Text {
                                    text: "Net Worth Growth"
                                    font.family: "Inter"
                                    font.pixelSize: 18
                                    font.weight: Font.Bold
                                    color: "#0f172a"
                                }

                                Text {
                                    text: "Cumulative Net Assets"
                                    font.family: "Inter"
                                    font.pixelSize: 13
                                    color: "#64748b"
                                }
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                height: 1
                                color: "#e2e8f0"
                            }

                            // Area Chart Canvas
                            Rectangle {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                color: "#f8fafc"
                                radius: 8
                                border.color: "#f1f5f9"

                                Canvas {
                                    id: rptNwCanvas
                                    anchors.fill: parent
                                    anchors.margins: 12

                                    Connections {
                                        target: reportsController
                                        function onReportChanged() {
                                            rptNwCanvas.requestPaint()
                                        }
                                    }
                                    onPaint: {
                                        var ctx = getContext("2d");
                                        ctx.reset();

                                        var padL = 42, padB = 24, padT = 15, padR = 12;
                                        var chartW = width - padL - padR;
                                        var chartH = height - padT - padB;

                                        // Y-Axis Value Labels & Gridlines
                                        ctx.font = "11px 'Inter', sans-serif";
                                        ctx.fillStyle = "#94a3b8";
                                        ctx.textAlign = "right";
                                        ctx.textBaseline = "middle";
                                        ctx.strokeStyle = "#f1f5f9";
                                        ctx.lineWidth = 1;

                                        var chartData = reportsController.netWorthChartData;
                                        var yTicks = (chartData && chartData.yTicks) ? chartData.yTicks : ["30M", "22.5M", "15M", "7.5M", "0"];
                                        for (var i = 0; i < yTicks.length; i++) {
                                            var ratio = i / (yTicks.length - 1);
                                            var y = padT + ratio * chartH;
                                            ctx.fillText(yTicks[i], padL - 8, y);

                                            ctx.beginPath();
                                            ctx.moveTo(padL, y);
                                            ctx.lineTo(width - padR, y);
                                            ctx.stroke();
                                        }

                                        // Net Worth Curve Points
                                        var months = (chartData && chartData.months) ? chartData.months : ["Jan", "Feb", "Mar", "Apr", "May", "Jun"];
                                        var nwRatios = (chartData && chartData.nwRatios) ? chartData.nwRatios : [0, 0, 0, 0, 0, 0];
                                        var count = months.length;
                                        var step = chartW / (count - 1);

                                        // Draw Area Gradient Fill
                                        ctx.beginPath();
                                        ctx.moveTo(padL, padT + chartH);
                                        for (var p = 0; p < count; p++) {
                                            var px = padL + p * step;
                                            var py = padT + chartH - (nwRatios[p] * chartH);
                                            ctx.lineTo(px, py);
                                        }
                                        ctx.lineTo(padL + (count - 1) * step, padT + chartH);
                                        ctx.closePath();

                                        var grad = ctx.createLinearGradient(0, padT, 0, padT + chartH);
                                        grad.addColorStop(0, "rgba(99, 102, 241, 0.35)");
                                        grad.addColorStop(1, "rgba(99, 102, 241, 0.0)");
                                        ctx.fillStyle = grad;
                                        ctx.fill();

                                        // Draw Line
                                        ctx.beginPath();
                                        ctx.strokeStyle = "#6366f1";
                                        ctx.lineWidth = 2.5;
                                        for (var l = 0; l < count; l++) {
                                            var lx = padL + l * step;
                                            var ly = padT + chartH - (nwRatios[l] * chartH);
                                            if (l === 0) ctx.moveTo(lx, ly);
                                            else ctx.lineTo(lx, ly);
                                        }
                                        ctx.stroke();

                                        // Draw Month Labels & Dots
                                        ctx.textAlign = "center";
                                        ctx.textBaseline = "top";
                                        for (var d = 0; d < count; d++) {
                                            var dx = padL + d * step;
                                            var dy = padT + chartH - (nwRatios[d] * chartH);

                                            ctx.fillStyle = "#6366f1";
                                            ctx.beginPath();
                                            ctx.arc(dx, dy, 4, 0, 2 * Math.PI);
                                            ctx.fill();

                                            ctx.fillStyle = "#94a3b8";
                                            ctx.fillText(months[d], dx, padT + chartH + 6);
                                        }
                                    }
                                    onWidthChanged: requestPaint()
                                    onHeightChanged: requestPaint()
                                }
                            }
                        }
                    }
                }

                // =================================================================
                // 5. ROW 4: 2 CATEGORY BREAKDOWN CARDS (Top 5 + Unlisted Donut Charts)
                // =================================================================
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 20

                    // Left: Expense by Category (Top 5 + Unlisted)
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredWidth: 1
                        implicitHeight: 340
                        color: "#ffffff"
                        border.color: "#e2e8f0"
                        border.width: 1
                        radius: 12
                        clip: true

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: 20
                            spacing: 12

                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 2

                                Text {
                                    text: "Expense by Category"
                                    font.family: "Inter"
                                    font.pixelSize: 18
                                    font.weight: Font.Bold
                                    color: "#0f172a"
                                }

                                Text {
                                    text: "Top 5 Categories & Unlisted"
                                    font.family: "Inter"
                                    font.pixelSize: 13
                                    color: "#64748b"
                                }
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                height: 1
                                color: "#e2e8f0"
                            }

                            RowLayout {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                spacing: 24

                                // Donut Chart Canvas
                                Rectangle {
                                    Layout.fillWidth: true
                                    Layout.preferredWidth: 1
                                    Layout.fillHeight: true
                                    color: "#f8fafc"
                                    radius: 8
                                    border.color: "#f1f5f9"

                                    Canvas {
                                        id: expenseCanvas
                                        anchors.fill: parent
                                        anchors.margins: 12
                                        property var chartData: reportsController.categoryExpenseReport

                                        Connections {
                                            target: reportsController
                                            function onReportChanged() {
                                                expenseCanvas.requestPaint()
                                            }
                                        }

                                        onPaint: {
                                            var ctx = getContext("2d");
                                            ctx.reset();

                                            var centerX = width / 2;
                                            var centerY = height / 2;
                                            var outerRadius = Math.min(centerX, centerY) - 8;
                                            var innerRadius = outerRadius * 0.55;

                                            if (!chartData || chartData.length === 0) {
                                                ctx.fillStyle = "#e2e8f0";
                                                ctx.beginPath();
                                                ctx.arc(centerX, centerY, outerRadius, 0, 2 * Math.PI);
                                                ctx.arc(centerX, centerY, innerRadius, 2 * Math.PI, 0, true);
                                                ctx.fill();
                                                return;
                                            }

                                            var startAngle = -Math.PI / 2;
                                            for (var i = 0; i < chartData.length; i++) {
                                                var item = chartData[i];
                                                var sliceAngle = (item.percentage / 100.0) * (2 * Math.PI);
                                                var endAngle = startAngle + sliceAngle;

                                                ctx.fillStyle = item.color;
                                                ctx.beginPath();
                                                ctx.arc(centerX, centerY, outerRadius, startAngle, endAngle);
                                                ctx.arc(centerX, centerY, innerRadius, endAngle, startAngle, true);
                                                ctx.closePath();
                                                ctx.fill();

                                                startAngle = endAngle;
                                            }
                                        }
                                        onWidthChanged: requestPaint()
                                        onHeightChanged: requestPaint()
                                    }
                                }

                                // Legend List
                                ColumnLayout {
                                    Layout.fillHeight: true
                                    Layout.alignment: Qt.AlignVCenter
                                    spacing: 8

                                    Repeater {
                                        model: reportsController.categoryExpenseReport

                                        Indicator_1 {
                                            labelText: modelData.name + " (" + Math.round(modelData.percentage) + "%)"
                                            dotColor: modelData.color
                                        }
                                    }
                                }
                            }
                        }
                    }

                    // Right: Income by Category (Top 5 + Unlisted)
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredWidth: 1
                        implicitHeight: 340
                        color: "#ffffff"
                        border.color: "#e2e8f0"
                        border.width: 1
                        radius: 12
                        clip: true

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: 20
                            spacing: 12

                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 2

                                Text {
                                    text: "Income by Category"
                                    font.family: "Inter"
                                    font.pixelSize: 18
                                    font.weight: Font.Bold
                                    color: "#0f172a"
                                }

                                Text {
                                    text: "Top 5 Categories & Unlisted"
                                    font.family: "Inter"
                                    font.pixelSize: 13
                                    color: "#64748b"
                                }
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                height: 1
                                color: "#e2e8f0"
                            }

                            RowLayout {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                spacing: 24

                                // Donut Chart Canvas
                                Rectangle {
                                    Layout.fillWidth: true
                                    Layout.preferredWidth: 1
                                    Layout.fillHeight: true
                                    color: "#f8fafc"
                                    radius: 8
                                    border.color: "#f1f5f9"

                                    Canvas {
                                        id: incomeCanvas
                                        anchors.fill: parent
                                        anchors.margins: 12
                                        property var chartData: reportsController.categoryIncomeReport

                                        Connections {
                                            target: reportsController
                                            function onReportChanged() {
                                                incomeCanvas.requestPaint()
                                            }
                                        }

                                        onPaint: {
                                            var ctx = getContext("2d");
                                            ctx.reset();

                                            var centerX = width / 2;
                                            var centerY = height / 2;
                                            var outerRadius = Math.min(centerX, centerY) - 8;
                                            var innerRadius = outerRadius * 0.55;

                                            if (!chartData || chartData.length === 0) {
                                                ctx.fillStyle = "#e2e8f0";
                                                ctx.beginPath();
                                                ctx.arc(centerX, centerY, outerRadius, 0, 2 * Math.PI);
                                                ctx.arc(centerX, centerY, innerRadius, 2 * Math.PI, 0, true);
                                                ctx.fill();
                                                return;
                                            }

                                            var startAngle = -Math.PI / 2;
                                            for (var i = 0; i < chartData.length; i++) {
                                                var item = chartData[i];
                                                var sliceAngle = (item.percentage / 100.0) * (2 * Math.PI);
                                                var endAngle = startAngle + sliceAngle;

                                                ctx.fillStyle = item.color;
                                                ctx.beginPath();
                                                ctx.arc(centerX, centerY, outerRadius, startAngle, endAngle);
                                                ctx.arc(centerX, centerY, innerRadius, endAngle, startAngle, true);
                                                ctx.closePath();
                                                ctx.fill();

                                                startAngle = endAngle;
                                            }
                                        }
                                        onWidthChanged: requestPaint()
                                        onHeightChanged: requestPaint()
                                    }
                                }

                                // Legend List
                                ColumnLayout {
                                    Layout.fillHeight: true
                                    Layout.alignment: Qt.AlignVCenter
                                    spacing: 8

                                    Repeater {
                                        model: reportsController.categoryIncomeReport

                                        Indicator_1 {
                                            labelText: modelData.name + " (" + Math.round(modelData.percentage) + "%)"
                                            dotColor: modelData.color
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}