import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: overviewPage

    color: "#f8fafc"
    clip: true

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
                    cardTitle: "Total balance"
                    showViewAll: false
                    amountText: "$10,234"
                    dateText: "July, 2026"
                    showTrend: false
                    accentLineColor: "#6366f1"
                }

                OverviewKpiCard {
                    Layout.fillWidth: true
                    cardTitle: "Income"
                    showViewAll: true
                    amountText: "$20,000"
                    dateText: "May, 2026"
                    showTrend: true
                    trendText: "8%"
                    isTrendUp: true
                    accentLineColor: "#10b981"
                    onViewAllClicked: console.log("Income View All Clicked")
                }

                OverviewKpiCard {
                    Layout.fillWidth: true
                    cardTitle: "Expense"
                    showViewAll: true
                    amountText: "$200,000"
                    dateText: "May, 2026"
                    showTrend: true
                    trendText: "5%"
                    isTrendUp: false
                    accentLineColor: "#ef4444"
                    onViewAllClicked: console.log("Expense View All Clicked")
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
                            onClicked: console.log("Upcoming Bills View All")
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
                            spacing: 8

                            Repeater {
                                model: [
                                    { title: "child support", category: "unimportant", amount: "$1", date: "May 16" },
                                    { title: "electricity", category: "daily", amount: "$1", date: "May 17" },
                                    { title: "wifi", category: "daily", amount: "$1", date: "May 18" },
                                    { title: "something", category: "subscription", amount: "$1", date: "May 19" },
                                    { title: "?", category: "game", amount: "$100", date: "May 20" }
                                ]

                                Overview_item_1 {
                                    type_1: Overview_item_1.Type.Type_bill
                                    itemTitle: modelData.title
                                    categoryText: modelData.category
                                    amountText: modelData.amount
                                    dateText: modelData.date
                                    showUnderline: index < 4
                                }
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
                            onClicked: console.log("Statistics View All")
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
                                    anchors.margins: 16
                                    onPaint: {
                                        var ctx = getContext("2d");
                                        ctx.reset();
                                        ctx.strokeStyle = "#e2e8f0";
                                        ctx.lineWidth = 1;

                                        // Horizontal Grid lines
                                        for (var i = 1; i <= 4; i++) {
                                            var y = (height / 5) * i;
                                            ctx.beginPath();
                                            ctx.moveTo(0, y);
                                            ctx.lineTo(width, y);
                                            ctx.stroke();
                                        }

                                        // Sample Bar Chart / Area Chart representation
                                        var barWidth = Math.min(30, width / 16);
                                        var count = 6;
                                        var gap = width / (count + 1);

                                        for (var b = 0; b < count; b++) {
                                            var x = gap * (b + 1) - barWidth;
                                            var hInc = Math.random() * (height * 0.6) + 20;
                                            var hExp = Math.random() * (height * 0.5) + 15;

                                            // Income bar (green)
                                            ctx.fillStyle = "#34c759";
                                            ctx.fillRect(x, height - hInc, barWidth / 2 - 2, hInc);

                                            // Expense bar (pink/red)
                                            ctx.fillStyle = "#ff383c";
                                            ctx.fillRect(x + barWidth / 2, height - hExp, barWidth / 2 - 2, hExp);
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
                            onClicked: console.log("Recent Transactions View All")
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
                            spacing: 6

                            Repeater {
                                model: [
                                    { title: "salary", category: "income", amount: "$1", date: "16-12-2025", type: Overview_item_1.Type.Type_income },
                                    { title: "salary", category: "income", amount: "$1", date: "16-12-2025", type: Overview_item_1.Type.Type_income },
                                    { title: "salary", category: "income", amount: "$1", date: "16-12-2025", type: Overview_item_1.Type.Type_income }
                                ]

                                Overview_item_1 {
                                    type_1: modelData.type
                                    itemTitle: modelData.title
                                    categoryText: modelData.category
                                    amountText: modelData.amount
                                    dateText: modelData.date
                                    showUnderline: index < 2
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
                            onClicked: console.log("Savings View All")
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
                                    text: "PC"
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
                                        Text { text: "$12,500"; color: "#0f172a"; font.pixelSize: 18; font.weight: Font.Bold; font.family: "Inter" }
                                    }

                                    ColumnLayout {
                                        spacing: 2
                                        Text { text: "Goal"; color: "#94a3b8"; font.pixelSize: 12; font.family: "Inter" }
                                        Text { text: "$20,000"; color: "#0f172a"; font.pixelSize: 16; font.weight: Font.DemiBold; font.family: "Inter" }
                                    }
                                }

                                Item { Layout.fillWidth: true }

                                GaugeMeter {
                                    currentValue: 12500
                                    maxValue: 20000
                                    progressColor: "#0284c7"
                                    currentLabel: "12K"
                                    minLabel: "$0"
                                    maxLabel: "$20k"
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
                            onClicked: console.log("Budgets View All")
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
                                    text: "Entertainment"
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
                                        Text { text: "$12,500"; color: "#0f172a"; font.pixelSize: 18; font.weight: Font.Bold; font.family: "Inter" }
                                    }

                                    ColumnLayout {
                                        spacing: 2
                                        Text { text: "Limit"; color: "#94a3b8"; font.pixelSize: 12; font.family: "Inter" }
                                        Text { text: "$20,000"; color: "#0f172a"; font.pixelSize: 16; font.weight: Font.DemiBold; font.family: "Inter" }
                                    }
                                }

                                Item { Layout.fillWidth: true }

                                GaugeMeter {
                                    currentValue: 12500
                                    maxValue: 20000
                                    progressColor: "#f97316"
                                    currentLabel: "12K"
                                    minLabel: "$0"
                                    maxLabel: "$20k"
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
