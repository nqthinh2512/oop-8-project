#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QButtonGroup>

// Forward declarations of your page widget classes
class OverviewWidget;
class TransactionsWidget;
class BillsWidget;
class CategoriesWidget;
class BudgetsWidget;
class ReportsWidget;

// Standard Qt namespace container for generated UI blueprints
namespace Ui {
class MainWindow;
}

class MainWindow : public QMainWindow {
    Q_OBJECT

public:
    MainWindow(QWidget *parent = nullptr);
    ~MainWindow();

private:
    // The bridge pointer holding access to your visual designer canvas elements
    Ui::MainWindow *ui;

    // A group container to manage exclusive navigation menu selections
    QButtonGroup *sidebarGroup;

    // Sub-page pointer tracking instances inside the page swapper framework
    OverviewWidget *overviewPage;
    TransactionsWidget *transactionsPage;
    BillsWidget *billsPage;
    CategoriesWidget *categoriesPage;
    BudgetsWidget *budgetsPage;
    ReportsWidget *reportsPage;
};

#endif // MAINWINDOW_H