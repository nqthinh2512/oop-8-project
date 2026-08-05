#include "category_dao.h"
#include "../storage/database_manager.h" // For getDataDirectoryPath
#include <QFile>
#include <QTextStream>
#include <QDir>
#include <QDebug>
#include <QUrl>

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

    QString dirPath = DatabaseManager::getDataDirectoryPath();
    QDir dir(dirPath);
    if (!dir.exists()) {
        dir.mkpath(".");
    }

    QString fullPath = dirPath + "/categories.csv";
    QFile file(fullPath);

    if (file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        QTextStream in(&file);
        if (!in.atEnd()) {
            in.readLine(); // Bỏ qua dòng tiêu đề
        }

        while (!in.atEnd()) {
            QString line = in.readLine().trimmed();
            if (line.isEmpty()) continue;

            QStringList fields = parseCSVLine(line);
            if (fields.size() >= 3) {
                int id = fields[0].toInt();
                QString name = fields[1];
                int parentId = fields[2].toInt();
                bool active = (fields.size() >= 4) ? (fields[3].toInt() != 0) : true;

                Category cat(id, parentId, name);
                cat.setActive(active);
                m_categories.append(cat);
            }
        }
        file.close();
    }

    if (m_categories.isEmpty()) {
        qDebug() << "Khởi tạo danh mục mặc định ban đầu...";
        int id = 1;
        
        auto addCat = [&](int pId, const QString& n) {
            Category c(id++, pId, n);
            c.setActive(true);
            m_categories.append(c);
        };

        addCat(1, "Salary");
        addCat(1, "Freelance & Side Income");
        addCat(1, "Investment Returns");
        addCat(1, "Gifts & Allowances");
        addCat(2, "Food & Dining");
        addCat(2, "Housing & Rent");
        addCat(2, "Transportation & Fuel");
        addCat(2, "Utilities & Services");
        addCat(2, "Entertainment & Leisure");
        addCat(2, "Healthcare & Medical");
        addCat(3, "Electricity Bill");
        addCat(3, "Water Bill");
        addCat(3, "Internet & Cable");
        addCat(3, "Credit Card Bill");
        addCat(4, "Monthly Living Budget");
        addCat(4, "Discretionary Budget");
        addCat(5, "Emergency Savings");
        addCat(5, "Vacation Fund");

        saveToCSV();
    }
}

void CategoryDAO::saveToCSV() const {
    QString dirPath = DatabaseManager::getDataDirectoryPath();
    QDir dir(dirPath);
    if (!dir.exists()) {
        dir.mkpath(".");
    }

    QString fullPath = dirPath + "/categories.csv";
    QFile file(fullPath);
    if (!file.open(QIODevice::WriteOnly | QIODevice::Text)) {
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
            break;
        }
    }
    saveToCSV();
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
    out << "id,name,parentId,active\n";

    for (const Category& cat : m_categories) {
        QString escapedName = QString(cat.getName()).replace("\"", "\"\"");
        out << cat.getId() << ",\""
            << escapedName << "\","
            << cat.getParentId() << ","
            << (cat.isActive() ? 1 : 0) << "\n";
    }
    
    file.close();
    return true;
}
