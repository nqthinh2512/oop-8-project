#include "mainwindow.h"
#include "ui_mainwindow.h" // Pulls in the hidden compiler translation sheet

// Sub-page interface layouts
#include "overview/overview_widget.h"
#include "transactions/transactions_widget.h"
#include "bills/bills_widget.h"
#include "categories/categories_widget.h"
#include "budgets/budgets_widget.h"
#include "reports/reports_widget.h"

#include "../frontend/categories/categories_controller.h"

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent),
    ui(new Ui::MainWindow) // Allocates the visual engine tracking pointer
{
    // Executes 100% of your visual layout structure automatically
    ui->setupUi(this);

    showMaximized();

    // 1. CONFIGURE THE SELECTION LOGIC FOR THE SIDEBAR MENU BUTTONS
    sidebarGroup = new QButtonGroup(this);
    sidebarGroup->setExclusive(true);

    sidebarGroup->addButton(ui->btnOverview);
    sidebarGroup->addButton(ui->btnTransactions);
    sidebarGroup->addButton(ui->btnBills);
    sidebarGroup->addButton(ui->btnCategories);
    sidebarGroup->addButton(ui->btnBudgets);
    sidebarGroup->addButton(ui->btnReports);

    // Dynamic style rules targeting hover states and selection borders
    QString buttonStyle = "QPushButton { color: #ecf0f1; background-color: transparent; text-align: left; "
                          "padding: 12px; border-radius: 5px; font-size: 14px; font-weight: bold; border: none; }"
                          "QPushButton:hover { background-color: #34495e; }"
                          "QPushButton:pressed { background-color: #1abc9c; }"
                          "QPushButton:checked { color: #FFFFFF; background-color: #2A82DA; font-weight: bold; border-left: 4px solid #00E5FF; }";

    ui->btnOverview->setStyleSheet(buttonStyle);
    ui->btnTransactions->setStyleSheet(buttonStyle);
    ui->btnBills->setStyleSheet(buttonStyle);
    ui->btnCategories->setStyleSheet(buttonStyle);
    ui->btnBudgets->setStyleSheet(buttonStyle);
    ui->btnReports->setStyleSheet(buttonStyle);

    // 2. INSTANTIATE AND EMBED CUSTOM TEAM PAGES INTO THE SWAPPER CANVAS
    overviewPage = new OverviewWidget(this);
    transactionsPage = new TransactionsWidget(this);
    billsPage = new BillsWidget(this);
    categoriesPage = new CategoriesWidget(this); new CategoriesController(categoriesPage, this);
    budgetsPage = new BudgetsWidget(this);
    reportsPage = new ReportsWidget(this);

    ui->stackedWidget->addWidget(overviewPage);     // Index 0
    ui->stackedWidget->addWidget(transactionsPage);  // Index 1
    ui->stackedWidget->addWidget(billsPage);         // Index 2
    ui->stackedWidget->addWidget(categoriesPage);    // Index 3
    ui->stackedWidget->addWidget(budgetsPage);       // Index 4
    ui->stackedWidget->addWidget(reportsPage);       // Index 5

    // 3. SECURELY CONNECT SELECTION CLICKS TO INDEX SWAPPING
    connect(ui->btnOverview, &QPushButton::clicked, [=]() { ui->stackedWidget->setCurrentIndex(0); });
    connect(ui->btnTransactions, &QPushButton::clicked, [=]() { ui->stackedWidget->setCurrentIndex(1); });
    connect(ui->btnBills, &QPushButton::clicked, [=]() { ui->stackedWidget->setCurrentIndex(2); });
    connect(ui->btnCategories, &QPushButton::clicked, [=]() { ui->stackedWidget->setCurrentIndex(3); });
    connect(ui->btnBudgets, &QPushButton::clicked, [=]() { ui->stackedWidget->setCurrentIndex(4); });
    connect(ui->btnReports, &QPushButton::clicked, [=]() { ui->stackedWidget->setCurrentIndex(5); });
}

MainWindow::~MainWindow() {
    delete ui; // Cleans away full canvas memory footprint to prevent memory leaks
}