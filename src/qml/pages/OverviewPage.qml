import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: overviewPage

    color: "#f8fafc"
    clip: true

    // Navigate to a page by sidebar index
    function navigateTo(pageIndex) {
        if (typeof sidebarMenu !== "undefined") {
            sidebarMenu.selectedIndex = pageIndex
        }
    }

    ScrollView {
        id: scrollView
        anchors.fill: parent
        contentWidth: availableWidth
        clip: true

        ColumnLayout {
            width: scrollView.width - 48
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 24
            spacing: 28

            // =================================================================
            // PAGE HEADER TITLE & DIVIDER
            // =================================================================
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 16

                Text {
                    text: "Overview"
                    font.family: "Inter"
                    font.pixelSize: 32
                    font.weight: Font.Bold
                    color: "#0f172a"
                }

                Rectangle {
                    Layout.fillWidth: true
                    height: 1
                    color: "#e2e8f0"
                }
            }

            // =================================================================
            // 1. TOP CONTENT: KPI SUMMARY CARDS (Total Balance, Income, Expense)
            // =================================================================
            RowLayout {
                id: top_content
                Layout.fillWidth: true
                spacing: 20

                OverviewKpiCard {
                    Layout.fillWidth: true
                    Layout.preferredWidth: 0
                    cardTitle: "Net Balance"
                    showViewAll: false
                    amountText: overviewController.netBalanceFormatted
                    dateText: "Current Month"
                    showTrend: false
                    accentLineColor: "#6366f1"
                }

                OverviewKpiCard {
                    Layout.fillWidth: true
                    Layout.preferredWidth: 0
                    cardTitle: "Total Income"
                    showViewAll: true
                    amountText: overviewController.totalIncomeFormatted
                    dateText: "Current Month"
                    showTrend: true
                    trendText: "Active"
                    isTrendUp: true
                    accentLineColor: "#10b981"
                    onViewAllClicked: overviewPage.navigateTo(1)
                }

                OverviewKpiCard {
                    Layout.fillWidth: true
                    Layout.preferredWidth: 0
                    cardTitle: "Total Expense"
                    showViewAll: true
                    amountText: overviewController.totalExpenseFormatted
                    dateText: "Current Month"
                    showTrend: true
                    trendText: "Active"
                    isTrendUp: false
                    accentLineColor: "#ef4444"
                    onViewAllClicked: overviewPage.navigateTo(1)
                }
            }

            // =================================================================
            // 2. MIDDLE CONTENT: UPCOMING BILLS & STATISTICS CHART
            // =================================================================
            RowLayout {
                id: middle_content
                Layout.fillWidth: true
                spacing: 20

                // A. Upcoming Bills Card (~35% width)
                ColumnLayout {
                    Layout.preferredWidth: 380
                    Layout.fillHeight: true
                    spacing: 10

                    RowLayout {
                        Layout.fillWidth: true

                        Text {
                            font.family: "Inter"
                            font.pixelSize: 20
                            font.weight: Font.DemiBold
                            color: "#64748b"
                            text: "Upcoming Bill"
                            Layout.fillWidth: true
                        }

                        View_all_1 {
                            onClicked: overviewPage.navigateTo(2)
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.preferredHeight: 380
                        color: "#ffffff"
                        radius: 12
                        border.color: "#f1f5f9"
                        border.width: 1

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: 45
                            spacing: 8

                            Repeater {
                                model: overviewController.upcomingBills

                                Overview_item_1 {
                                    type_1: Overview_item_1.Type.Type_bill
                                    itemTitle: modelData.name
                                    categoryText: modelData.categoryName
                                    amountText: modelData.amountFormatted
                                    dateText: modelData.dueDateFormatted
                                    showUnderline: index < (overviewController.upcomingBills.length - 1)
                                }
                            }

                            Item {
                                Layout.fillHeight: true
                            }
                        }
                    }
                }

                // B. Statistics Chart Card (~65% width)
                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    spacing: 10

                    RowLayout {
                        Layout.fillWidth: true

                        Text {
                            font.family: "Inter"
                            font.pixelSize: 20
                            font.weight: Font.DemiBold
                            color: "#64748b"
                            text: "Statistics"
                            Layout.fillWidth: true
                        }

                        View_all_1 {
                            onClicked: overviewPage.navigateTo(6)
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.preferredHeight: 380
                        color: "#ffffff"
                        radius: 12
                        border.color: "#f1f5f9"
                        border.width: 1

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: 20
                            spacing: 16

                            ColumnLayout {
                                spacing: 4
                                Text {
                                    font.family: "Inter"
                                    font.pixelSize: 18
                                    font.weight: Font.Bold
                                    color: "#0f172a"
                                    text: "Income vs Expense"
                                }
                                Text {
                                    font.family: "Inter"
                                    font.pixelSize: 13
                                    color: "#94a3b8"
                                    text: "Last Month"
                                }
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                height: 1
                                color: "#f1f5f9"
                            }

                            // Chart Canvas Placeholder
                            Rectangle {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                color: "#fafafa"
                                radius: 8

                                Canvas {
                                    anchors.fill: parent
                                    anchors.margins: 12
                                    onPaint: {
                                        var ctx = getContext("2d");
                                        ctx.reset();

                                        var padL = 42;
                                        var padB = 24;
                                        var padT = 15;
                                        var padR = 12;

                                        var chartW = width - padL - padR;
                                        var chartH = height - padT - padB;

                                        // Y-Axis Value Labels & Gridlines
                                        ctx.font = "11px 'Inter', sans-serif";
                                        ctx.fillStyle = "#94a3b8";
                                        ctx.textAlign = "right";
                                        ctx.textBaseline = "middle";
                                        ctx.strokeStyle = "#f1f5f9";
                                        ctx.lineWidth = 1;

                                        var yTicks = ["20M", "15M", "10M", "5M", "0"];
                                        for (var i = 0; i < yTicks.length; i++) {
                                            var ratio = i / (yTicks.length - 1);
                                            var y = padT + ratio * chartH;

                                            // Value Label on Left
                                            ctx.fillText(yTicks[i], padL - 8, y);

                                            // Grid Line
                                            ctx.beginPath();
                                            ctx.moveTo(padL, y);
                                            ctx.lineTo(width - padR, y);
                                            ctx.stroke();
                                        }

                                        // X-Axis Month Labels & Bars
                                        var months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun"];
                                        var incomeRatios = [0.65, 0.50, 0.80, 0.55, 0.85, 0.70];
                                        var expenseRatios = [0.40, 0.55, 0.45, 0.60, 0.35, 0.50];

                                        var count = months.length;
                                        var groupWidth = chartW / count;
                                        var barWidth = Math.min(22, groupWidth * 0.32);

                                        ctx.textAlign = "center";
                                        ctx.textBaseline = "top";

                                        for (var b = 0; b < count; b++) {
                                            var groupCenterX = padL + groupWidth * b + groupWidth / 2;
                                            var xInc = groupCenterX - barWidth - 1;
                                            var xExp = groupCenterX + 1;

                                            var hInc = incomeRatios[b] * chartH;
                                            var hExp = expenseRatios[b] * chartH;

                                            var yInc = padT + chartH - hInc;
                                            var yExp = padT + chartH - hExp;

                                            // Income bar (green)
                                            ctx.fillStyle = "#10b981";
                                            ctx.fillRect(xInc, yInc, barWidth, hInc);

                                            // Expense bar (red)
                                            ctx.fillStyle = "#ef4444";
                                            ctx.fillRect(xExp, yExp, barWidth, hExp);

                                            // Month Label underneath
                                            ctx.fillStyle = "#94a3b8";
                                            ctx.fillText(months[b], groupCenterX, padT + chartH + 6);
                                        }
                                    }
                                    onWidthChanged: requestPaint()
                                    onHeightChanged: requestPaint()
                                }
                            }

                            RowLayout {
                                Layout.fillWidth: true
                                spacing: 16

                                Indicator_1 {
                                    labelText: "Income"
                                    dotColor: "#34c759"
                                }

                                Indicator_1 {
                                    labelText: "Expense"
                                    dotColor: "#ff383c"
                                }
                            }
                        }
                    }
                }
            }

            // =================================================================
            // 3. BOTTOM CONTENT: RECENT TRANSACTIONS, SAVINGS, AND BUDGETS
            // =================================================================
            RowLayout {
                id: bottom_content
                Layout.fillWidth: true
                spacing: 20

                // A. Recent Transactions
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 10

                    RowLayout {
                        Layout.fillWidth: true

                        Text {
                            font.family: "Inter"
                            font.pixelSize: 20
                            font.weight: Font.DemiBold
                            color: "#64748b"
                            text: "Recent Transaction"
                            Layout.fillWidth: true
                        }

                        View_all_1 {
                            onClicked: overviewPage.navigateTo(1)
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        implicitHeight: txColumn.implicitHeight + 40
                        Layout.preferredHeight: implicitHeight
                        color: "#ffffff"
                        radius: 12
                        border.color: "#f1f5f9"
                        border.width: 1

                        ColumnLayout {
                            id: txColumn
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.top: parent.top
                            anchors.margins: 20
                            spacing: 6

                            Repeater {
                                model: overviewController.recentTransactions

                                Overview_item_1 {
                                    type_1: modelData.isIncome ? Overview_item_1.Type.Type_income : Overview_item_1.Type.Type_expense
                                    itemTitle: modelData.note && modelData.note !== "" ? modelData.note : modelData.categoryName
                                    categoryText: modelData.categoryName
                                    amountText: modelData.amountFormatted
                                    dateText: modelData.dateFormatted
                                    showUnderline: index < (overviewController.recentTransactions.length - 1)
                                }
                            }
                        }
                    }
                }

                // B. Savings Card
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 10

                    RowLayout {
                        Layout.fillWidth: true

                        Text {
                            font.family: "Inter"
                            font.pixelSize: 20
                            font.weight: Font.DemiBold
                            color: "#64748b"
                            text: "Savings"
                            Layout.fillWidth: true
                        }

                        View_all_1 {
                            onClicked: overviewPage.navigateTo(4)
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 240
                        color: "#ffffff"
                        radius: 12
                        border.color: "#f1f5f9"
                        border.width: 1

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: 20
                            spacing: 16

                            RowLayout {
                                Layout.fillWidth: true

                                Text {
                                    font.family: "Inter"
                                    font.pixelSize: 22
                                    font.weight: Font.ExtraBold
                                    color: "#0f172a"
                                    text: overviewController.topSaving.name || "No Savings"
                                    Layout.fillWidth: true
                                }

                                Edit_1 {
                                    Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                                    _vector_ShapePath0StrokeColor: "#64748b"
                                    _vector_1_ShapePath0StrokeColor: "#64748b"
                                }
                            }

                            RowLayout {
                                Layout.fillWidth: true
                                spacing: 16

                                ColumnLayout {
                                    spacing: 8

                                    ColumnLayout {
                                        spacing: 2
                                        Text { text: "Saved money"; color: "#94a3b8"; font.pixelSize: 12; font.family: "Inter" }
                                        Text { text: overviewController.topSaving.currentFormatted || "0 VND"; color: "#0f172a"; font.pixelSize: 18; font.weight: Font.Bold; font.family: "Inter" }
                                    }

                                    ColumnLayout {
                                        spacing: 2
                                        Text { text: "Goal"; color: "#94a3b8"; font.pixelSize: 12; font.family: "Inter" }
                                        Text { text: overviewController.topSaving.targetFormatted || "0 VND"; color: "#0f172a"; font.pixelSize: 16; font.weight: Font.DemiBold; font.family: "Inter" }
                                    }
                                }

                                Item { Layout.fillWidth: true }

                                GaugeMeter {
                                    currentValue: overviewController.topSaving.current || 0
                                    maxValue: overviewController.topSaving.target || 1
                                    progressColor: "#0284c7"
                                    currentLabel: Math.round((overviewController.topSaving.progress || 0)) + "%"
                                    minLabel: "0%"
                                    maxLabel: "100%"
                                    Layout.preferredWidth: 140
                                    Layout.preferredHeight: 90
                                }
                            }
                        }
                    }
                }

                // C. Budgets Card
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 10

                    RowLayout {
                        Layout.fillWidth: true

                        Text {
                            font.family: "Inter"
                            font.pixelSize: 20
                            font.weight: Font.DemiBold
                            color: "#64748b"
                            text: "Budgets"
                            Layout.fillWidth: true
                        }

                        View_all_1 {
                            onClicked: overviewPage.navigateTo(3)
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 240
                        color: "#ffffff"
                        radius: 12
                        border.color: "#f1f5f9"
                        border.width: 1

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: 20
                            spacing: 16

                            RowLayout {
                                Layout.fillWidth: true

                                Text {
                                    font.family: "Inter"
                                    font.pixelSize: 22
                                    font.weight: Font.ExtraBold
                                    color: "#0f172a"
                                    text: overviewController.topBudget.name || "No Budgets"
                                    Layout.fillWidth: true
                                }

                                Edit_1 {
                                    Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                                    _vector_ShapePath0StrokeColor: "#64748b"
                                    _vector_1_ShapePath0StrokeColor: "#64748b"
                                }
                            }

                            RowLayout {
                                Layout.fillWidth: true
                                spacing: 16

                                ColumnLayout {
                                    spacing: 8

                                    ColumnLayout {
                                        spacing: 2
                                        Text { text: "Spent money"; color: "#94a3b8"; font.pixelSize: 12; font.family: "Inter" }
                                        Text { text: overviewController.topBudget.spentFormatted || "0 VND"; color: "#0f172a"; font.pixelSize: 18; font.weight: Font.Bold; font.family: "Inter" }
                                    }

                                    ColumnLayout {
                                        spacing: 2
                                        Text { text: "Limit"; color: "#94a3b8"; font.pixelSize: 12; font.family: "Inter" }
                                        Text { text: overviewController.topBudget.limitFormatted || "0 VND"; color: "#0f172a"; font.pixelSize: 16; font.weight: Font.DemiBold; font.family: "Inter" }
                                    }
                                }

                                Item { Layout.fillWidth: true }

                                GaugeMeter {
                                    currentValue: overviewController.topBudget.spent || 0
                                    maxValue: overviewController.topBudget.limit || 1
                                    progressColor: "#f97316"
                                    currentLabel: Math.round((overviewController.topBudget.progress || 0)) + "%"
                                    minLabel: "0%"
                                    maxLabel: "100%"
                                    Layout.preferredWidth: 140
                                    Layout.preferredHeight: 90
                                }
                            }
                        }
                    }
                }
            }

            // Bottom Spacing Buffer
            Item {
                Layout.preferredWidth: 1
                Layout.preferredHeight: 32
            }
        }
    }
}
