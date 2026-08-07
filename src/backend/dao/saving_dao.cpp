#include "saving_dao.h"
#include "../storage/database_manager.h" // For getDataDirectoryPath
#include <QFile>
#include <QTextStream>
#include <QDir>
#include <QDebug>
#include <QUrl>
#include <QDateTime>

SavingDAO::SavingDAO() {
    loadFromCSV();
}

int SavingDAO::generateNextId() const {
    int maxId = 0;
    for (const Saving& s : m_savings) {
        if (s.getId() > maxId) {
            maxId = s.getId();
        }
    }
    return maxId + 1;
}

const QVector<Saving>& SavingDAO::getAll() const {
    return m_savings;
}

void SavingDAO::add(const Saving& item) {
    Saving newItem = item;
    if (newItem.getId() <= 0) {
        newItem.setId(generateNextId());
    }
    m_savings.append(newItem);
    saveToCSV();
}

bool SavingDAO::update(int id, const Saving& item) {
    for (int i = 0; i < m_savings.size(); ++i) {
        if (m_savings[i].getId() == id) {
            Saving s = item;
            s.setId(id); // Ensure ID doesn't change
            m_savings[i] = s;
            saveToCSV();
            return true;
        }
    }
    return false;
}

bool SavingDAO::remove(int id) {
    for (int i = 0; i < m_savings.size(); ++i) {
        if (m_savings[i].getId() == id) {
            m_savings.removeAt(i);
            saveToCSV();
            return true;
        }
    }
    return false;
}

bool SavingDAO::contributeToSaving(int savingId, double amount) {
    for (Saving& s : m_savings) {
        if (s.getId() == savingId) {
            s.contribute(amount); 
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
        } else if ((c == ';' || c == ',') && !inQuotes) {
            fields.append(current.trimmed());
            current.clear();
        } else {
            current += c;
        }
    }
    fields.append(current.trimmed());
    return fields;
}

void SavingDAO::loadFromCSV() {
    m_savings.clear();
    QString filePath = DatabaseManager::getDataDirectoryPath() + "/savings.csv";
    QFile file(filePath);

    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        qWarning() << "Cannot open savings.csv for reading at:" << filePath;
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
        if (fields.size() >= 7) {
            int id = fields[0].toInt();
            QString name = fields[1];
            Priority priority = static_cast<Priority>(fields[2].toInt());
            int categoryId = fields[3].toInt();
            double targetAmount = fields[4].toDouble();
            double currentAmount = fields[5].toDouble();
            QDate dueDate = QDate::fromString(fields[6], Qt::ISODate);
            if (!dueDate.isValid()) dueDate = QDate::fromString(fields[6], "dd/MM/yyyy");

            m_savings.append(Saving(id, name, priority, dueDate, targetAmount, currentAmount, categoryId));
        }
    }
    file.close();
}

void SavingDAO::saveToCSV() const {
    QString filePath = DatabaseManager::getDataDirectoryPath() + "/savings.csv";
    QFile file(filePath);

    if (!file.open(QIODevice::WriteOnly | QIODevice::Text)) {
        qWarning() << "Cannot open savings.csv for writing at:" << filePath;
        return;
    }

    QTextStream out(&file);
    out << "id,name,priority,categoryId,targetAmount,currentAmount,dueDate\n";
    for (const Saving& s : m_savings) {
        QString escapedName = QString(s.getName()).replace("\"", "\"\"");
        out << s.getId() << ",\""
            << escapedName << "\","
            << static_cast<int>(s.getPriority()) << ","
            << s.getCategoryId() << ","
            << QString::number(s.getTarget(), 'f', 2) << ","
            << QString::number(s.getCurrent(), 'f', 2) << ","
            << s.getDueDate().toString(Qt::ISODate) << "\n";
    }
    file.close();
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

bool SavingDAO::exportToCSV(const QString& targetFilePath) const {
    QString cleanPath = resolveLocalPath(targetFilePath);
    QFile file(cleanPath);
    if (!file.open(QIODevice::WriteOnly | QIODevice::Text)) {
        return false;
    }

    const auto& categories = DatabaseManager::instance().categoryDAO()->getAll();
    auto getCatName = [&categories](int catId) -> QString {
        for (const auto& c : categories) {
            if (c.getId() == catId) return c.getName();
        }
        return "Uncategorized";
    };

    QTextStream out(&file);
    out << "=== SAVINGS EXPORT REPORT ===\n";
    out << "Generated Date,\"" << QDateTime::currentDateTime().toString("yyyy-MM-dd HH:mm:ss") << "\"\n\n";
    out << "ID,Goal Pot Name,Priority,Category Name,Target Amount (VND),Current Saved (VND),Due Date,Progress (%),Status\n";

    for (const Saving& s : m_savings) {
        QString escapedName = QString(s.getName()).replace("\"", "\"\"");
        QString priorityStr = (s.getPriority() == Priority::High) ? "High" :
                              (s.getPriority() == Priority::Medium) ? "Medium" : "Low";
        QString catName = QString(getCatName(s.getCategoryId())).replace("\"", "\"\"");
        double pct = s.getProgressPercent();

        out << s.getId() << ",\""
            << escapedName << "\",\""
            << priorityStr << "\",\""
            << catName << "\","
            << QString::number(s.getTarget(), 'f', 2) << ","
            << QString::number(s.getCurrent(), 'f', 2) << ","
            << s.getDueDate().toString("yyyy-MM-dd") << ",\""
            << QString::number(pct, 'f', 1) << "%\",\""
            << (s.isCompleted() ? "Completed" : "In Progress") << "\"\n";
    }
    file.close();
    return true;
}
