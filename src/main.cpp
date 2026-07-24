// src/main.cpp
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>


int main(int argc, char *argv[]) {
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;

    // Load the single Main.qml test window
    engine.load(QUrl(QStringLiteral("qrc:/qt/qml/src/qml/Main.qml")));

    // Quick sanity check to ensure QML loaded without errors
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}