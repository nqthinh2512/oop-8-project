// src/main.cpp
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QCoreApplication>
#include <QDebug>

#include "backend/storage/database_manager.h"
#include "frontend/categories_controller.h"
#include "frontend/overview_controller.h"
#include "frontend/reports_controller.h"

int main(int argc, char *argv[]) {
    QGuiApplication app(argc, argv);

    // Initialize Database & load data from CSVs
    DatabaseManager& db = DatabaseManager::instance();
    db.loadBudgetsFromCSV();
    db.loadCategoriesFromCSV();
    db.loadSavingsFromCSV();

    // Instantiate Controllers for your pages
    CategoriesController categoriesCtrl;
    OverviewController overviewCtrl;
    ReportsController reportsCtrl;

    QQmlApplicationEngine engine;

    // Expose controllers as QML Context Properties
    engine.rootContext()->setContextProperty("categoriesController", &categoriesCtrl);
    engine.rootContext()->setContextProperty("overviewController", &overviewCtrl);
    engine.rootContext()->setContextProperty("reportsController", &reportsCtrl);

    engine.load(QUrl(QStringLiteral("qrc:/qt/qml/src/qml/Main.qml")));

    return app.exec();
}