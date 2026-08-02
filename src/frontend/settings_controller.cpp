#include "settings_controller.h"
#include <QCoreApplication>
#include <QDir>
#include <QFile>
#include <QTextStream>
#include <QUrl>

namespace {
const QString kDefaultAvatarColor = "#3b82f6";
}

SettingsController::SettingsController(QObject *parent)
    : QObject(parent),
      m_isEditing(false),
      m_fullName("Admin User"),
      m_email("admin.user@phinma.edu.ph"),
      m_contact("09123456789"),
      m_avatarImagePath(""),
      m_avatarColor(kDefaultAvatarColor)
{
    loadAvatar();
}

void SettingsController::toggleEdit()
{
    m_isEditing = !m_isEditing;
    emit isEditingChanged();
}

void SettingsController::cancelEdit()
{
    if (m_isEditing) {
        m_isEditing = false;
        emit isEditingChanged();
        // Since we didn't save, the properties remain unchanged.
        // QML will reset its temporary state to these bound properties.
    }
}

void SettingsController::saveChanges(const QString &newName, const QString &newEmail, const QString &newContact)
{
    m_fullName = newName;
    m_email = newEmail;
    m_contact = newContact;
    
    m_isEditing = false;
    
    emit profileChanged();
    emit isEditingChanged();
}

QString SettingsController::initials() const
{
    QStringList parts = m_fullName.trimmed().split(' ', Qt::SkipEmptyParts);
    if (parts.isEmpty()) return "?";
    if (parts.size() == 1) return parts.first().left(1).toUpper();
    return (parts.first().left(1) + parts.last().left(1)).toUpper();
}

void SettingsController::setAvatarImage(const QString &filePath)
{
    // filePath arrives as a "file:///..." URL from the QML FileDialog
    m_avatarImagePath = filePath;
    persistAvatar();
    emit profileChanged();
}

void SettingsController::setAvatarPreset(const QString &colorHex)
{
    m_avatarImagePath = "";
    m_avatarColor = colorHex;
    persistAvatar();
    emit profileChanged();
}

void SettingsController::loadAvatar()
{
    QString dirPath = QCoreApplication::applicationDirPath() + "/data";
    QString fullPath = dirPath + "/avatar.txt";

    QFile file(fullPath);
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        return; // no saved avatar yet - keep the defaults
    }

    QTextStream in(&file);
    QString imagePath = in.readLine();
    QString color = in.readLine();
    file.close();

    if (!imagePath.isNull() && !imagePath.isEmpty()) {
        // Only trust the saved path if the image file still exists on disk
        QUrl url(imagePath);
        QString localPath = url.isLocalFile() ? url.toLocalFile() : imagePath;
        if (QFile::exists(localPath)) {
            m_avatarImagePath = imagePath;
        }
    }
    if (!color.isNull() && !color.isEmpty()) {
        m_avatarColor = color;
    }
}

void SettingsController::persistAvatar() const
{
    QString dirPath = QCoreApplication::applicationDirPath() + "/data";
    QDir dir(dirPath);
    if (!dir.exists()) dir.mkpath(".");

    QFile file(dirPath + "/avatar.txt");
    if (!file.open(QIODevice::WriteOnly | QIODevice::Text)) {
        return;
    }

    QTextStream out(&file);
    out << m_avatarImagePath << "\n";
    out << m_avatarColor << "\n";
    file.close();
}
