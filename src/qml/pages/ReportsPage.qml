import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Rectangle {
    id: reportsPage

    color: "#f8fafc"
    clip: true

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

                    Text {
                        text: "Reports"
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
                // 2. ROW 1: 4 TOP KPI CARDS (Proportionally Equal)
                // =================================================================
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 20

                    ReportBox1_1 {
                        titleText: "MONTHLY INCOME"
                        amountText: "1,000 VND"
                        labelText: "July 2026"
                        subtitleText: "+4.2% vs June"
                        subtitleColor: "#6366f1"
                        Layout.fillWidth: true
                        Layout.preferredWidth: 1
                    }

                    ReportBox1_1 {
                        titleText: "MONTHLY EXPENSES"
                        amountText: "1,000 VND"
                        labelText: "July 2026"
                        subtitleText: "-11.6% vs June"
                        subtitleColor: "#6366f1"
                        Layout.fillWidth: true
                        Layout.preferredWidth: 1
                    }

                    ReportBox1_1 {
                        titleText: "NET WORTH"
                        amountText: "4,000 VND"
                        labelText: "Total Assets"
                        subtitleText: "+3,000 VND This Month"
                        subtitleColor: "#6366f1"
                        Layout.fillWidth: true
                        Layout.preferredWidth: 1
                    }

                    ReportBox1_1 {
                        titleText: "SAVINGS RATE"
                        amountText: "1%"
                        labelText: "Of Income"
                        subtitleText: ""
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
                        row1Amount: "100,000 VND"
                        row2Label: "Overdue"
                        row2Amount: "2,000,000 VND"
                        row3Label: "Paid"
                        row3Amount: "1,000 VND"
                        Layout.fillWidth: true
                        Layout.preferredWidth: 1
                    }

                    ReportBox2_1 {
                        titleText: "Budgets"
                        row1Label: "Total Spent"
                        row1Amount: "1,000,000 VND"
                        row2Label: "Total Limit"
                        row2Amount: "2,000,000 VND"
                        row3Label: "Remaining"
                        row3Amount: "2,500,000 VND"
                        Layout.fillWidth: true
                        Layout.preferredWidth: 1
                    }

                    ReportBox2_1 {
                        titleText: "Savings"
                        row1Label: "Total Saved"
                        row1Amount: "1,000,000"
                        row2Label: "Total Target"
                        row2Amount: "2,000,000"
                        row3Label: "Remaining"
                        row3Amount: "5,000,000"
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
                                    font.family: "Intel One Mono"
                                    font.pixelSize: 18
                                    font.weight: Font.Bold
                                    color: "#0f172a"
                                }

                                Text {
                                    text: "Last Month"
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

                            // Chart canvas area placeholder
                            Rectangle {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                color: "#f8fafc"
                                radius: 8
                                border.color: "#f1f5f9"
                            }

                            // Bottom Legend
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
                                    text: "Net Worth"
                                    font.family: "Intel One Mono"
                                    font.pixelSize: 18
                                    font.weight: Font.Bold
                                    color: "#0f172a"
                                }

                                Text {
                                    text: "Last Month"
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

                            // Chart canvas area placeholder
                            Rectangle {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                color: "#f8fafc"
                                radius: 8
                                border.color: "#f1f5f9"
                            }
                        }
                    }
                }

                // =================================================================
                // 5. ROW 4: 2 CATEGORY BREAKDOWN CARDS
                // =================================================================
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 20

                    // Left: Expense by Category
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
                                    font.family: "Intel One Mono"
                                    font.pixelSize: 18
                                    font.weight: Font.Bold
                                    color: "#0f172a"
                                }

                                Text {
                                    text: "July 2026"
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

                                // Donut Chart Canvas Area
                                Rectangle {
                                    Layout.fillWidth: true
                                    Layout.preferredWidth: 1
                                    Layout.fillHeight: true
                                    color: "#f8fafc"
                                    radius: 8
                                    border.color: "#f1f5f9"
                                }

                                // Legend List
                                ColumnLayout {
                                    Layout.fillHeight: true
                                    Layout.alignment: Qt.AlignVCenter
                                    spacing: 8

                                    Indicator_1 { labelText: "category1"; dotColor: "#3b82f6" }
                                    Indicator_1 { labelText: "category2"; dotColor: "#10b981" }
                                    Indicator_1 { labelText: "category3"; dotColor: "#f59e0b" }
                                    Indicator_1 { labelText: "category4"; dotColor: "#ef4444" }
                                    Indicator_1 { labelText: "category5"; dotColor: "#8b5cf6" }
                                    Indicator_1 { labelText: "unlisted"; dotColor: "#94a3b8" }
                                }
                            }
                        }
                    }

                    // Right: Income by Category
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
                                    font.family: "Intel One Mono"
                                    font.pixelSize: 18
                                    font.weight: Font.Bold
                                    color: "#0f172a"
                                }

                                Text {
                                    text: "July 2026"
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

                                // Donut Chart Canvas Area
                                Rectangle {
                                    Layout.fillWidth: true
                                    Layout.preferredWidth: 1
                                    Layout.fillHeight: true
                                    color: "#f8fafc"
                                    radius: 8
                                    border.color: "#f1f5f9"
                                }

                                // Legend List
                                ColumnLayout {
                                    Layout.fillHeight: true
                                    Layout.alignment: Qt.AlignVCenter
                                    spacing: 8

                                    Indicator_1 { labelText: "category1"; dotColor: "#3b82f6" }
                                    Indicator_1 { labelText: "category2"; dotColor: "#10b981" }
                                    Indicator_1 { labelText: "category3"; dotColor: "#f59e0b" }
                                    Indicator_1 { labelText: "category4"; dotColor: "#ef4444" }
                                    Indicator_1 { labelText: "category5"; dotColor: "#8b5cf6" }
                                    Indicator_1 { labelText: "unlisted"; dotColor: "#94a3b8" }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}