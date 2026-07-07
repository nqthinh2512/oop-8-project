#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QStackedWidget>
#include <QPushButton>
#include <QVBoxLayout>
#include <QResizeEvent>
#include <QButtonGroup>

// Khai báo trước các lớp Giao diện
class OverviewWidget;
class TransactionsWidget;
class BillsWidget;
class CategoriesWidget;
class BudgetsWidget;
class ReportsWidget;

class MainWindow : public QMainWindow {
    Q_OBJECT

public:
    MainWindow(QWidget *parent = nullptr);
    ~MainWindow();

private:

    // Bộ quản lý lật trang
    QStackedWidget *stackedWidget;

    // Các con trỏ lưu trữ 6 trang giao diện chính
    OverviewWidget *overviewPage;
    TransactionsWidget *transactionsPage;
    BillsWidget *billsPage;
    CategoriesWidget *categoriesPage;
    BudgetsWidget *budgetsPage;
    ReportsWidget *reportsPage;

    // Các nút bấm trên thanh Sidebar điều hướng
    QPushButton *btnOverview;
    QPushButton *btnTransactions;
    QPushButton *btnBills;
    QPushButton *btnCategories;
    QPushButton *btnBudgets;
    QPushButton *btnReports;

    // Hàm phụ trợ tạo giao diện điều hướng
    void setupNavigation();
};

#endif // MAINWINDOW_H