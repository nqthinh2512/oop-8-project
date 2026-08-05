#ifndef SESSION_CONTROLLER_H
#define SESSION_CONTROLLER_H

#include <QObject>
#include <QString>
#include <QMap>

// Simple single-user login/session handling for the app.
//
// NOTE: credentials are stored in plain text in data/auth.csv. That is fine for
// this project's scope (a local desktop demo with no server/auth backend) but is
// NOT how a real production app should store passwords (those should be salted +
// hashed, e.g. with a library like libsodium, and never kept in plain text).
class SessionController : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool isLoggedIn READ isLoggedIn NOTIFY loggedInChanged)
    Q_PROPERTY(QString currentUsername READ currentUsername NOTIFY loggedInChanged)

public:
    explicit SessionController(QObject *parent = nullptr);

    bool isLoggedIn() const { return m_isLoggedIn; }
    QString currentUsername() const { return m_currentUsername; }

    // Returns true and logs the user in if the credentials match; otherwise
    // returns false (and QML should show an error message).
    Q_INVOKABLE bool login(const QString &username, const QString &password, bool rememberMe);
    Q_INVOKABLE void logout();

signals:
    void loggedInChanged();

private:
    void loadCredentials();
    void tryAutoLogin();
    void persistRememberedSession(const QString &username, bool remember);

    bool m_isLoggedIn;
    QString m_currentUsername;
    QMap<QString, QString> m_credentials; // username -> password
};

#endif // SESSION_CONTROLLER_H
