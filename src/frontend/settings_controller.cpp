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
      m_avatarColor(kDefaultAvatarColor),
      m_theme("Light"),
      m_autoBackup(false)
{
    loadAvatar();
    loadSettings();
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



void SettingsController::setTheme(const QString &theme)
{
    if (m_theme != theme) {
        m_theme = theme;
        persistSettings();
        emit themeChanged();
    }
}

void SettingsController::setAutoBackup(bool autoBackup)
{
    if (m_autoBackup != autoBackup) {
        m_autoBackup = autoBackup;
        persistSettings();
        emit autoBackupChanged();
    }
}

void SettingsController::loadSettings()
{
    QString dirPath = DatabaseManager::getDataDirectoryPath();
    QString fullPath = dirPath + "/settings.ini";
    QFile file(fullPath);
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) return;
    QTextStream in(&file);
    m_theme = in.readLine();
    m_autoBackup = (in.readLine() == "true");
    file.close();
}

void SettingsController::persistSettings() const
{
    QString dirPath = DatabaseManager::getDataDirectoryPath();
    QDir dir(dirPath);
    if (!dir.exists()) dir.mkpath(".");
    QString fullPath = dirPath + "/settings.ini";
    QFile file(fullPath);
    if (file.open(QIODevice::WriteOnly | QIODevice::Text)) {
        QTextStream out(&file);
        out << m_theme << "\n";
        out << (m_autoBackup ? "true" : "false") << "\n";
        file.close();
    }
}

void SettingsController::loadAvatar()
{
    QString dirPath = DatabaseManager::getDataDirectoryPath();
    QString fullPath = dirPath + "/avatar.txt";
    QFile file(fullPath);
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) return;
    QTextStream in(&file);
    QString imagePath = in.readLine();
    QString color = in.readLine();
    file.close();
    if (!imagePath.isNull() && !imagePath.isEmpty()) {
        QUrl url(imagePath);
        QString localPath = url.isLocalFile() ? url.toLocalFile() : imagePath;
        if (QFile::exists(localPath)) m_avatarImagePath = imagePath;
    }
    if (!color.isNull() && !color.isEmpty()) m_avatarColor = color;
}

void SettingsController::persistAvatar() const
{
    QString dirPath = DatabaseManager::getDataDirectoryPath();
    QDir dir(dirPath);
    if (!dir.exists()) dir.mkpath(".");
    QString fullPath = dirPath + "/avatar.txt";
    QFile file(fullPath);
    if (file.open(QIODevice::WriteOnly | QIODevice::Text)) {
        QTextStream out(&file);
        out << m_avatarImagePath << "\n";
        out << m_avatarColor << "\n";
        file.close();
    }
}

bool SettingsController::exportAllToCSV(const QString &folderPath)
{
    return DatabaseManager::instance().exportAllToCSV(folderPath);
}

void SettingsController::factoryReset()
{
    DatabaseManager::instance().factoryReset();
    m_theme = "Light";
    m_autoBackup = false;
    persistSettings();
    emit themeChanged();
    emit autoBackupChanged();
}