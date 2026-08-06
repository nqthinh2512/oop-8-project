#include <QCoreApplication>
#include <QDebug>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "backend/storage/database_manager.h"
#include "frontend/bills_controller.h"
#include "frontend/budgets_controller.h"
#include "frontend/categories_controller.h"
#include "frontend/overview_controller.h"
#include "frontend/reports_controller.h"
#include "frontend/savings_controller.h"
#include "frontend/settings_controller.h"
#include "frontend/transactions_controller.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    // Initialize Database & load data from CSVs
    DatabaseManager &db = DatabaseManager::instance();
    // DAOs automatically load data from CSV on creation

    // Instantiate Controllers for your pages
    CategoriesController categoriesCtrl;
    OverviewController overviewCtrl;
    ReportsController reportsCtrl;
    SettingsController settingsCtrl;
    BudgetsController budgetsCtrl;
    TransactionsController transactionsCtrl;
    BillsController billsCtrl;
    SavingsController savingsCtrl;

    QQmlApplicationEngine engine;

    // Expose controllers as QML Context Properties
    engine.rootContext()->setContextProperty("categoriesController", &categoriesCtrl);
    engine.rootContext()->setContextProperty("overviewController", &overviewCtrl);
    engine.rootContext()->setContextProperty("reportsController", &reportsCtrl);
    engine.rootContext()->setContextProperty("settingsController", &settingsCtrl);
    engine.rootContext()->setContextProperty("budgetsController", &budgetsCtrl);
    engine.rootContext()->setContextProperty("transactionsController", &transactionsCtrl);
    engine.rootContext()->setContextProperty("billsController", &billsCtrl);
    engine.rootContext()->setContextProperty("savingsController", &savingsCtrl);

    engine.load(QUrl(QStringLiteral("qrc:/qt/qml/src/qml/Main.qml")));

    return app.exec();
}