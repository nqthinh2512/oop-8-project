#include "mainwindow.h"

// Include tất cả các trang con vào khung xương chính
#include "overview/overview_widget.h"
#include "transactions/transactions_widget.h"
#include "bills/bills_widget.h"
#include "categories/categories_widget.h"
#include "budgets/budgets_widget.h"
#include "reports/reports_widget.h"


MainWindow::MainWindow(QWidget *parent) : QMainWindow(parent) {
    resize(1000, 700);
    showMaximized();
    setWindowTitle("Personal Finance Dashboard - Nhóm 8 Template");

    // 1. Tạo Widget trung tâm tổng và Layout ngang chính (Trái: Menu, Phải: Nội dung)
    QWidget *centralWidget = new QWidget(this);
    setCentralWidget(centralWidget);
    QHBoxLayout *mainLayout = new QHBoxLayout(centralWidget);
    mainLayout->setContentsMargins(0, 0, 0, 0);
    mainLayout->setSpacing(0);

    // 2. TẠO THANH SIDEBAR (Bên trái)
    QFrame *sidebar = new QFrame(this);
    sidebar->setFixedWidth(220);
    sidebar->setStyleSheet("background-color: #2c3e50; border: none;");
    QVBoxLayout *sidebarLayout = new QVBoxLayout(sidebar);
    sidebarLayout->setContentsMargins(10, 30, 10, 30);
    sidebarLayout->setSpacing(10);
    QButtonGroup *sidebarGroup = new QButtonGroup(this);
    sidebarGroup->setExclusive(true);

    // Khởi tạo 6 nút bấm menu điều hướng
    btnOverview = new QPushButton("📊 Tổng quan", sidebar);
    btnTransactions = new QPushButton("📝 Lịch sử giao dịch", sidebar);
    btnBills = new QPushButton("🧾 Quản lý hóa đơn", sidebar);
    btnCategories = new QPushButton("📁 Danh mục", sidebar);
    btnBudgets = new QPushButton("💰 Tiết kiệm / Ngân sách", sidebar);
    btnReports = new QPushButton("📈 Báo cáo / Phân tích", sidebar);

    //Button group action
    btnOverview->setCheckable(true); sidebarGroup->addButton(btnOverview);
    btnTransactions->setCheckable(true); sidebarGroup->addButton(btnTransactions);
    btnBills->setCheckable(true); sidebarGroup->addButton(btnBills);
    btnCategories->setCheckable(true); sidebarGroup->addButton(btnCategories);
    btnBudgets->setCheckable(true); sidebarGroup->addButton(btnBudgets);
    btnReports->setCheckable(true); sidebarGroup->addButton(btnReports);

    // Nút Style định dạng CSS thuần cho mượt mà chuyên nghiệp
    QString buttonStyle = "QPushButton { color: #ecf0f1; background-color: transparent; text-align: left; "
                          "padding: 12px; border-radius: 5px; font-size: 14px; font-weight: bold; }"
                          "QPushButton:hover { background-color: #34495e; }"
                          "QPushButton:pressed { background-color: #1abc9c; }"
                          "QPushButton:checked {color: #FFFFFF; background-color: #2A82DA; font-weight: bold; border-left: 4px solid #00E5FF}";

    btnOverview->setStyleSheet(buttonStyle);
    btnTransactions->setStyleSheet(buttonStyle);
    btnBills->setStyleSheet(buttonStyle);
    btnCategories->setStyleSheet(buttonStyle);
    btnBudgets->setStyleSheet(buttonStyle);
    btnReports->setStyleSheet(buttonStyle);

    sidebarLayout->addWidget(btnOverview);
    sidebarLayout->addWidget(btnTransactions);
    sidebarLayout->addWidget(btnBills);
    sidebarLayout->addWidget(btnCategories);
    sidebarLayout->addWidget(btnBudgets);
    sidebarLayout->addWidget(btnReports);
    sidebarLayout->addStretch(); // Đẩy các nút lên phía trên cùng

    // 3. TẠO BỘ LẬT TRANG QSTACKEDWIDGET (Bên phải)
    stackedWidget = new QStackedWidget(this);
    stackedWidget->setStyleSheet("background-color: #f5f6fa;");

    // Khởi tạo các trang con
    overviewPage = new OverviewWidget(this);
    transactionsPage = new TransactionsWidget(this);
    billsPage = new BillsWidget(this);
    categoriesPage = new CategoriesWidget(this);
    budgetsPage = new BudgetsWidget(this);
    reportsPage = new ReportsWidget(this);

    // Add lần lượt vào stackedWidget theo đúng thứ tự Index từ 0 đến 5
    stackedWidget->addWidget(overviewPage);     // Index 0
    stackedWidget->addWidget(transactionsPage);  // Index 1
    stackedWidget->addWidget(billsPage);         // Index 2
    stackedWidget->addWidget(categoriesPage);    // Index 3
    stackedWidget->addWidget(budgetsPage);       // Index 4
    stackedWidget->addWidget(reportsPage);       // Index 5

    // Ghép Thanh Sidebar và Khung lật trang vào màn hình chính
    mainLayout->addWidget(sidebar);
    mainLayout->addWidget(stackedWidget, 1);

    // 4. KẾT NỐI CÁC NÚT BẤM VỚI SỰ KIỆN LẬT TRANG (Signals & Slots)
    btnOverview->setChecked(true); // mặc định overview là checked
    connect(btnOverview, &QPushButton::clicked, [=]() { stackedWidget->setCurrentIndex(0); });
    connect(btnTransactions, &QPushButton::clicked, [=]() { stackedWidget->setCurrentIndex(1); });
    connect(btnBills, &QPushButton::clicked, [=]() { stackedWidget->setCurrentIndex(2); });
    connect(btnCategories, &QPushButton::clicked, [=]() { stackedWidget->setCurrentIndex(3); });
    connect(btnBudgets, &QPushButton::clicked, [=]() { stackedWidget->setCurrentIndex(4); });
    connect(btnReports, &QPushButton::clicked, [=]() { stackedWidget->setCurrentIndex(5); });
}

MainWindow::~MainWindow() {}