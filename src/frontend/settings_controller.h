#ifndef SETTINGS_CONTROLLER_H
#define SETTINGS_CONTROLLER_H

#include <QObject>
#include <QString>

class SettingsController : public QObject {
    Q_OBJECT

    Q_PROPERTY(bool isEditing READ isEditing NOTIFY isEditingChanged)
    Q_PROPERTY(QString fullName READ fullName NOTIFY profileChanged)
    Q_PROPERTY(QString email READ email NOTIFY profileChanged)
    Q_PROPERTY(QString contact READ contact NOTIFY profileChanged)

private:
    bool m_isEditing;
    QString m_fullName;
    QString m_email;
    QString m_contact;

public:
    explicit SettingsController(QObject *parent = nullptr);

    bool isEditing() const { return m_isEditing; }
    QString fullName() const { return m_fullName; }
    QString email() const { return m_email; }
    QString contact() const { return m_contact; }

    Q_INVOKABLE void toggleEdit();
    Q_INVOKABLE void cancelEdit();
    Q_INVOKABLE void saveChanges(const QString &newName, const QString &newEmail, const QString &newContact);

signals:
    void isEditingChanged();
    void profileChanged();
};

#endif // SETTINGS_CONTROLLER_H
