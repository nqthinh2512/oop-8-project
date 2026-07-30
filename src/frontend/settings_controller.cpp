#include "settings_controller.h"

SettingsController::SettingsController(QObject *parent)
    : QObject(parent),
      m_isEditing(false),
      m_fullName("Admin User"),
      m_email("admin.user@phinma.edu.ph"),
      m_contact("09123456789")
{
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
