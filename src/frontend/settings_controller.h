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

    Q_PROPERTY(QString avatarImagePath READ avatarImagePath NOTIFY profileChanged)
    Q_PROPERTY(QString avatarColor READ avatarColor NOTIFY profileChanged)
    Q_PROPERTY(QString initials READ initials NOTIFY profileChanged)

private:
    bool m_isEditing;
    QString m_fullName;
    QString m_email;
    QString m_contact;

    // avatarImagePath: local "file://..." path chosen via the file picker, or "" if none
    // avatarColor: background color for the initials placeholder / preset swatch avatar
    QString m_avatarImagePath;
    QString m_avatarColor;

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

    Q_INVOKABLE void toggleEdit();
    Q_INVOKABLE void cancelEdit();
    Q_INVOKABLE void saveChanges(const QString &newName, const QString &newEmail, const QString &newContact);

    // Sets a custom uploaded image as the avatar (from the FileDialog).
    Q_INVOKABLE void setAvatarImage(const QString &filePath);
    // Picks one of the built-in colored-initials presets, clearing any custom image.
    Q_INVOKABLE void setAvatarPreset(const QString &colorHex);

signals:
    void isEditingChanged();
    void profileChanged();
};

#endif // SETTINGS_CONTROLLER_H
