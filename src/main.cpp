// src/main.cpp
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QCoreApplication>
#include <QDebug>

#include "backend/storage/database_manager.h"

int main(int argc, char *argv[]) {
    QGuiApplication app(argc, argv);

    //Load file
    DatabaseManager dbManager;
    dbManager.loadBudgetsFromCSV();
    dbManager.loadCategoriesFromCSV();
    dbManager.loadSavingsFromCSV();

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/qt/qml/src/qml/Main.qml")));

    return app.exec();
}