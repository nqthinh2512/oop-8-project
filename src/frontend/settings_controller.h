#ifndef SETTINGS_CONTROLLER_H
#define SETTINGS_CONTROLLER_H

#include <QObject>
#include <QString>
#include "../backend/storage/database_manager.h"

class SettingsController : public QObject {
    Q_OBJECT

    Q_PROPERTY(bool isEditing READ isEditing NOTIFY isEditingChanged)
    Q_PROPERTY(QString fullName READ fullName NOTIFY profileChanged)
    Q_PROPERTY(QString email READ email NOTIFY profileChanged)
    Q_PROPERTY(QString contact READ contact NOTIFY profileChanged)

    Q_PROPERTY(QString avatarImagePath READ avatarImagePath NOTIFY profileChanged)
    Q_PROPERTY(QString avatarColor READ avatarColor NOTIFY profileChanged)
    Q_PROPERTY(QString initials READ initials NOTIFY profileChanged)
    Q_PROPERTY(QString theme READ theme WRITE setTheme NOTIFY themeChanged)
    Q_PROPERTY(bool autoBackup READ autoBackup WRITE setAutoBackup NOTIFY autoBackupChanged)

private:
    bool m_isEditing;
    QString m_fullName;
    QString m_email;
    QString m_contact;

    // avatarImagePath: local "file://..." path chosen via the file picker, or "" if none
    // avatarColor: background color for the initials placeholder / preset swatch avatar
    QString m_avatarImagePath;
    QString m_avatarColor;

    QString m_theme;
    bool m_autoBackup;

    void loadSettings();
    void persistSettings() const;

    void loadAvatar();
    void persistAvatar() const;

public:
    explicit SettingsController(QObject *parent = nullptr);

    bool isEditing() const { return m_isEditing; }
    QString fullName() const { return m_fullName; }
    QString email() const { return m_email; }
    QString contact() const { return m_contact; }

    QString avatarImagePath() const { return m_avatarImagePath; }
    QString avatarColor() const { return m_avatarColor; }
    QString initials() const;

    QString theme() const { return m_theme; }
    void setTheme(const QString &theme);

    bool autoBackup() const { return m_autoBackup; }
    void setAutoBackup(bool autoBackup);

    Q_INVOKABLE void toggleEdit();
    Q_INVOKABLE void cancelEdit();
    Q_INVOKABLE void saveChanges(const QString &newName, const QString &newEmail, const QString &newContact);
    
    Q_INVOKABLE void setAvatarImage(const QString &filePath);
    Q_INVOKABLE void setAvatarPreset(const QString &colorHex);

    Q_INVOKABLE bool exportAllToCSV(const QString &folderPath);

    Q_INVOKABLE void factoryReset();

signals:
    void isEditingChanged();
    void profileChanged();
    void themeChanged();
    void autoBackupChanged();
};

#endif // SETTINGS_CONTROLLER_H
