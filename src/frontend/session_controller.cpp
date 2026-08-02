#include "session_controller.h"
#include <QCoreApplication>
#include <QDir>
#include <QFile>
#include <QTextStream>
#include <QStringList>

SessionController::SessionController(QObject *parent)
    : QObject(parent), m_isLoggedIn(false)
{
    loadCredentials();
    tryAutoLogin();
}

void SessionController::loadCredentials()
{
    QString dirPath = QCoreApplication::applicationDirPath() + "/data";
    QDir dir(dirPath);
    if (!dir.exists()) dir.mkpath(".");

    QString fullPath = dirPath + "/auth.csv";
    QFile file(fullPath);

    if (!file.exists()) {
        // First run: seed a default account so the app is usable out of the box.
        if (file.open(QIODevice::WriteOnly | QIODevice::Text)) {
            QTextStream out(&file);
            out << "username;password\n";
            out << "admin;admin123\n";
            file.close();
        }
    }

    if (file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        QTextStream in(&file);
        bool first = true;
        while (!in.atEnd()) {
            QString line = in.readLine().trimmed();
            if (first) { first = false; continue; } // skip header
            if (line.isEmpty()) continue;

            QStringList parts = line.split(';');
            if (parts.size() >= 2) {
                m_credentials.insert(parts[0], parts[1]);
            }
        }
        file.close();
    }

    if (m_credentials.isEmpty()) {
        // Fallback in case the file couldn't be read/written for some reason
        m_credentials.insert("admin", "admin123");
    }
}

void SessionController::tryAutoLogin()
{
    QString dirPath = QCoreApplication::applicationDirPath() + "/data";
    QFile file(dirPath + "/session.txt");
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        return;
    }

    QTextStream in(&file);
    QString rememberedUser = in.readLine().trimmed();
    file.close();

    if (!rememberedUser.isEmpty() && m_credentials.contains(rememberedUser)) {
        m_isLoggedIn = true;
        m_currentUsername = rememberedUser;
        emit loggedInChanged();
    }
}

void SessionController::persistRememberedSession(const QString &username, bool remember)
{
    QString dirPath = QCoreApplication::applicationDirPath() + "/data";
    QDir dir(dirPath);
    if (!dir.exists()) dir.mkpath(".");

    QFile file(dirPath + "/session.txt");
    if (!file.open(QIODevice::WriteOnly | QIODevice::Text)) {
        return;
    }
    QTextStream out(&file);
    out << (remember ? username : QString(""));
    file.close();
}

bool SessionController::login(const QString &username, const QString &password, bool rememberMe)
{
    if (username.isEmpty() || password.isEmpty()) {
        return false;
    }

    if (m_credentials.contains(username) && m_credentials.value(username) == password) {
        m_isLoggedIn = true;
        m_currentUsername = username;
        persistRememberedSession(username, rememberMe);
        emit loggedInChanged();
        return true;
    }

    return false;
}

void SessionController::logout()
{
    m_isLoggedIn = false;
    m_currentUsername = "";
    persistRememberedSession("", false);
    emit loggedInChanged();
}
