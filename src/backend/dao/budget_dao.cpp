#include "budget_dao.h"
#include "../storage/database_manager.h" // For getDataDirectoryPath
#include <QFile>
#include <QTextStream>
#include <QDir>
#include <QDebug>
#include <QUrl>
#include <QDateTime>

BudgetDAO::BudgetDAO() {
    loadFromCSV();
}

int BudgetDAO::generateNextId() const {
    int maxId = 0;
    for (const Budget& b : m_budgets) {
        if (b.getId() > maxId) {
            maxId = b.getId();
        }
    }
    return maxId + 1;
}

const QVector<Budget>& BudgetDAO::getAll() const {
    return m_budgets;
}

void BudgetDAO::add(const Budget& item) {
    Budget newItem = item;
    if (newItem.getId() <= 0) {
        newItem.setId(generateNextId());
    }
    m_budgets.append(newItem);
    saveToCSV();
}

bool BudgetDAO::update(int id, const Budget& item) {
    for (int i = 0; i < m_budgets.size(); ++i) {
        if (m_budgets[i].getId() == id) {
            Budget b = item;
            b.setId(id); // Ensure ID doesn't change
            m_budgets[i] = b;
            saveToCSV();
            return true;
        }
    }
    return false;
}

bool BudgetDAO::remove(int id) {
    for (int i = 0; i < m_budgets.size(); ++i) {
        if (m_budgets[i].getId() == id) {
            m_budgets.removeAt(i);
            saveToCSV();
            return true;
        }
    }
    return false;
}

void BudgetDAO::addExpenseToBudget(int categoryId, double amount) {
    bool updated = false;
    for (Budget& b : m_budgets) {
        if (b.getCategoryId() == categoryId) {
            b.addExpense(amount);
            updated = true;
        }
    }
    if (updated) {
        saveToCSV();
    }
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

void BudgetDAO::loadFromCSV() {
    m_budgets.clear();
    QString filePath = DatabaseManager::getDataDirectoryPath() + "/budgets.csv";
    QFile file(filePath);

    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        qWarning() << "Cannot open budgets.csv for reading at:" << filePath;
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
        if (fields.size() >= 8) {
            int id = fields[0].toInt();
            QString name = fields[1];
            Priority priority = static_cast<Priority>(fields[2].toInt());
            int categoryId = fields[3].toInt();
            double limitAmount = fields[4].toDouble();
            double spentAmount = fields[5].toDouble();
            QDate startDate = QDate::fromString(fields[6], Qt::ISODate);
            if (!startDate.isValid()) startDate = QDate::fromString(fields[6], "dd/MM/yyyy");
            QDate endDate = QDate::fromString(fields[7], Qt::ISODate);
            if (!endDate.isValid()) endDate = QDate::fromString(fields[7], "dd/MM/yyyy");

            m_budgets.append(Budget(id, name, priority, categoryId, limitAmount, startDate, endDate, spentAmount));
        }
    }
    file.close();
}

void BudgetDAO::saveToCSV() const {
    QString filePath = DatabaseManager::getDataDirectoryPath() + "/budgets.csv";
    QFile file(filePath);

    if (!file.open(QIODevice::WriteOnly | QIODevice::Text)) {
        qWarning() << "Cannot open budgets.csv for writing at:" << filePath;
        return;
    }

    QTextStream out(&file);
    out << "id,name,priority,categoryId,limitAmount,spentAmount,startDate,endDate\n";
    for (const Budget& b : m_budgets) {
        QString escapedName = QString(b.getName()).replace("\"", "\"\"");
        out << b.getId() << ",\""
            << escapedName << "\","
            << static_cast<int>(b.getPriority()) << ","
            << b.getCategoryId() << ","
            << QString::number(b.getLimit(), 'f', 2) << ","
            << QString::number(b.getSpent(), 'f', 2) << ","
            << b.getStartDate().toString(Qt::ISODate) << ","
            << b.getEndDate().toString(Qt::ISODate) << "\n";
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

bool BudgetDAO::exportToCSV(const QString& targetFilePath) const {
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
    out << "=== BUDGETS EXPORT REPORT ===\n";
    out << "Generated Date,\"" << QDateTime::currentDateTime().toString("yyyy-MM-dd HH:mm:ss") << "\"\n\n";
    out << "ID,Budget Name,Priority,Category Name,Limit Amount (VND),Spent Amount (VND),Start Date,End Date,Status\n";

    for (const Budget& b : m_budgets) {
        QString escapedName = QString(b.getName()).replace("\"", "\"\"");
        QString priorityStr = b.getPriorityLabel();
        QString catName = QString(getCatName(b.getCategoryId())).replace("\"", "\"\"");
        QString statusStr;
        switch (b.getStatus()) {
            case BudgetStatus::Safe: statusStr = "Safe"; break;
            case BudgetStatus::Warning: statusStr = "Warning"; break;
            case BudgetStatus::Danger: statusStr = "Danger"; break;
            case BudgetStatus::Over: statusStr = "Over Budget"; break;
        }

        out << b.getId() << ",\""
            << escapedName << "\",\""
            << priorityStr << "\",\""
            << catName << "\","
            << QString::number(b.getLimit(), 'f', 2) << ","
            << QString::number(b.getSpent(), 'f', 2) << ","
            << b.getStartDate().toString("yyyy-MM-dd") << ","
            << b.getEndDate().toString("yyyy-MM-dd") << ",\""
            << statusStr << "\"\n";
    }
    file.close();
    return true;
}
