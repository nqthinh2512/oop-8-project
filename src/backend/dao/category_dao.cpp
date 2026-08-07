#include "category_dao.h"
#include "../storage/database_manager.h" // For getDataDirectoryPath
#include <QFile>
#include <QTextStream>
#include <QDir>
#include <QDebug>
#include <QUrl>
#include <QDateTime>

CategoryDAO::CategoryDAO() {
    loadFromCSV();
}

int CategoryDAO::generateNextId() const {
    int maxId = 0;
    for (const Category& cat : m_categories) {
        if (cat.getId() > maxId) {
            maxId = cat.getId();
        }
    }
    return maxId + 1;
}

const QVector<Category>& CategoryDAO::getAll() const {
    return m_categories;
}

void CategoryDAO::add(const Category& item) {
    Category newItem = item;
    if (newItem.getId() <= 0) {
        newItem.setId(generateNextId());
    }
    m_categories.append(newItem);
    saveToCSV();
}

bool CategoryDAO::update(int id, const Category& item) {
    for (int i = 0; i < m_categories.size(); ++i) {
        if (m_categories[i].getId() == id) {
            Category cat = item;
            cat.setId(id); // Ensure ID doesn't change
            m_categories[i] = cat;
            saveToCSV();
            return true;
        }
    }
    return false;
}

bool CategoryDAO::remove(int id) {
    for (int i = 0; i < m_categories.size(); ++i) {
        if (m_categories[i].getId() == id) {
            m_categories.removeAt(i);
            saveToCSV();
            return true;
        }
    }
    return false;
}

static QStringList parseCSVLine(const QString& line) {
    QStringList fields;
    QString current;
    bool inQuotes = false;
    for (int i = 0; i < line.length(); ++i) {
        QChar c = line[i];
        if (c == '"') {
            if (inQuotes && i + 1 < line.length() && line[i + 1] == '"') {
                current += '"';
                i++;
            } else {
                inQuotes = !inQuotes;
            }
        } else if (c == ',' && !inQuotes) {
            fields.append(current.trimmed());
            current.clear();
        } else {
            current += c;
        }
    }
    fields.append(current.trimmed());
    return fields;
}

void CategoryDAO::loadFromCSV() {
    m_categories.clear();
    QString filePath = DatabaseManager::getDataDirectoryPath() + "/categories.csv";
    QFile file(filePath);

    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        qWarning() << "Cannot open categories.csv for reading at:" << filePath;
        return;
    }

    QTextStream in(&file);
    if (!in.atEnd()) {
        in.readLine(); // Skip header
    }

    while (!in.atEnd()) {
        QString line = in.readLine().trimmed();
        if (line.isEmpty()) continue;

        QStringList fields = parseCSVLine(line);
        if (fields.size() >= 4) {
            int id = fields[0].toInt();
            QString name = fields[1];
            int parentId = fields[2].toInt();
            bool active = (fields[3].toInt() != 0);

            m_categories.append(Category(id, parentId, name, active));
        }
    }
    file.close();
}

void CategoryDAO::saveToCSV() const {
    QString filePath = DatabaseManager::getDataDirectoryPath() + "/categories.csv";
    QFile file(filePath);

    if (!file.open(QIODevice::WriteOnly | QIODevice::Text)) {
        qWarning() << "Cannot open categories.csv for writing at:" << filePath;
        return;
    }

    QTextStream out(&file);
    out << "id,name,parentId,active\n";
    for (const Category& cat : m_categories) {
        QString escapedName = QString(cat.getName()).replace("\"", "\"\"");
        out << cat.getId() << ",\""
            << escapedName << "\","
            << cat.getParentId() << ","
            << (cat.isActive() ? 1 : 0) << "\n";
    }
    file.close();
}

void CategoryDAO::deactivate(int id) {
    for (Category& cat : m_categories) {
        if (cat.getId() == id) {
            cat.setActive(false);
            saveToCSV();
            break;
        }
    }
}

static QString resolveLocalPath(const QString& path) {
    QUrl url(path);
    if (url.isValid() && url.isLocalFile()) {
        return url.toLocalFile();
    }
    if (path.startsWith("file:", Qt::CaseInsensitive)) {
        return QUrl(path).toLocalFile();
    }
    return path;
}

bool CategoryDAO::exportToCSV(const QString& targetFilePath) const {
    QString cleanPath = resolveLocalPath(targetFilePath);
    QFile file(cleanPath);
    if (!file.open(QIODevice::WriteOnly | QIODevice::Text)) {
        return false;
    }

    QTextStream out(&file);
    out << "=== CATEGORIES EXPORT REPORT ===\n";
    out << "Generated Date,\"" << QDateTime::currentDateTime().toString("yyyy-MM-dd HH:mm:ss") << "\"\n\n";
    out << "ID,Category Name,Parent Section,Status\n";

    for (const Category& cat : m_categories) {
        QString escapedName = QString(cat.getName()).replace("\"", "\"\"");
        QString parentName = Category::parentCategoryName(cat.getParentId());
        out << cat.getId() << ",\""
            << escapedName << "\",\""
            << parentName << "\","
            << (cat.isActive() ? "Active" : "Inactive") << "\n";
    }
    
    file.close();
    return true;
}
