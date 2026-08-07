#include "bill_dao.h"
#include "../storage/database_manager.h" // For getDataDirectoryPath
#include <QFile>
#include <QTextStream>
#include <QDir>
#include <QDebug>
#include <QUrl>
#include <QDateTime>

BillDAO::BillDAO() {
    loadFromCSV();
}

int BillDAO::generateNextId() const {
    int maxId = 0;
    for (const Bill& b : m_bills) {
        if (b.getId() > maxId) {
            maxId = b.getId();
        }
    }
    return maxId + 1;
}

const QVector<Bill>& BillDAO::getAll() const {
    return m_bills;
}

void BillDAO::add(const Bill& item) {
    Bill newItem = item;
    if (newItem.getId() <= 0) {
        newItem.setId(generateNextId());
    }
    m_bills.append(newItem);
    saveToCSV();
}

bool BillDAO::update(int id, const Bill& item) {
    for (int i = 0; i < m_bills.size(); ++i) {
        if (m_bills[i].getId() == id) {
            Bill b = item;
            b.setId(id); // Ensure ID doesn't change
            m_bills[i] = b;
            saveToCSV();
            return true;
        }
    }
    return false;
}

bool BillDAO::remove(int id) {
    for (int i = 0; i < m_bills.size(); ++i) {
        if (m_bills[i].getId() == id) {
            m_bills.removeAt(i);
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

void BillDAO::loadFromCSV() {
    m_bills.clear();
    QString filePath = DatabaseManager::getDataDirectoryPath() + "/bills.csv";
    QFile file(filePath);

    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        qWarning() << "Cannot open bills.csv for reading at:" << filePath;
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
        if (fields.size() >= 6) {
            int id = fields[0].toInt();
            QString name = fields[1];
            double amount = fields[2].toDouble();
            QDate dueDate = QDate::fromString(fields[3], Qt::ISODate);
            if (!dueDate.isValid()) {
                dueDate = QDate::fromString(fields[3], "dd/MM/yyyy");
            }
            int categoryId = fields[4].toInt();
            bool isPaid = (fields[5].toInt() != 0);

            m_bills.append(Bill(id, name, amount, dueDate, categoryId, isPaid));
        }
    }
    file.close();
}

void BillDAO::saveToCSV() const {
    QString filePath = DatabaseManager::getDataDirectoryPath() + "/bills.csv";
    QFile file(filePath);

    if (!file.open(QIODevice::WriteOnly | QIODevice::Text)) {
        qWarning() << "Cannot open bills.csv for writing at:" << filePath;
        return;
    }

    QTextStream out(&file);
    out << "id,name,amount,dueDate,categoryId,isPaid\n";
    for (const Bill& b : m_bills) {
        QString escapedName = QString(b.getName()).replace("\"", "\"\"");
        out << b.getId() << ",\""
            << escapedName << "\","
            << QString::number(b.getAmount(), 'f', 2) << ","
            << b.getDueDate().toString(Qt::ISODate) << ","
            << b.getCategoryId() << ","
            << (b.checkPaid() ? 1 : 0) << "\n";
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

bool BillDAO::exportToCSV(const QString& targetFilePath) const {
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
    out << "=== BILLS EXPORT REPORT ===\n";
    out << "Generated Date,\"" << QDateTime::currentDateTime().toString("yyyy-MM-dd HH:mm:ss") << "\"\n\n";
    out << "ID,Bill Name,Amount (VND),Due Date,Category Name,Payment Status\n";

    for (const Bill& b : m_bills) {
        QString escapedName = QString(b.getName()).replace("\"", "\"\"");
        QString catName = QString(getCatName(b.getCategoryId())).replace("\"", "\"\"");
        out << b.getId() << ",\""
            << escapedName << "\","
            << QString::number(b.getAmount(), 'f', 2) << ","
            << b.getDueDate().toString("yyyy-MM-dd") << ",\""
            << catName << "\","
            << (b.checkPaid() ? "Paid" : "Unpaid") << "\n";
    }
    file.close();
    return true;
}
