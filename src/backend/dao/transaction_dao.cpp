#include "transaction_dao.h"
#include "../storage/database_manager.h" // For getDataDirectoryPath
#include <QFile>
#include <QTextStream>
#include <QDir>
#include <QDebug>
#include <QUrl>

TransactionDAO::TransactionDAO() {
    loadFromCSV();
}

TransactionDAO::~TransactionDAO() {
    qDeleteAll(m_transactions);
    m_transactions.clear();
}

int TransactionDAO::generateNextId() const {
    int maxId = 0;
    for (const Transaction* t : m_transactions) {
        if (t && t->getId() > maxId) {
            maxId = t->getId();
        }
    }
    return maxId + 1;
}

const QVector<Transaction*>& TransactionDAO::getAll() const {
    return m_transactions;
}

void TransactionDAO::add(Transaction* const& item) {
    if (!item) return;
    if (item->getId() <= 0) {
        item->setId(generateNextId());
    }
    m_transactions.append(item);
    saveToCSV();
}

bool TransactionDAO::update(int id, Transaction* const& item) {
    if (!item) return false;
    for (int i = 0; i < m_transactions.size(); ++i) {
        if (m_transactions[i] && m_transactions[i]->getId() == id) {
            delete m_transactions[i];
            item->setId(id);
            m_transactions[i] = item;
            saveToCSV();
            return true;
        }
    }
    delete item;
    return false;
}

bool TransactionDAO::remove(int id) {
    for (int i = 0; i < m_transactions.size(); ++i) {
        if (m_transactions[i] && m_transactions[i]->getId() == id) {
            delete m_transactions[i];
            m_transactions.removeAt(i);
            saveToCSV();
            return true;
        }
    }
    return false;
}

void TransactionDAO::loadFromCSV() {
    qDeleteAll(m_transactions);
    m_transactions.clear();

    QString dirPath = DatabaseManager::getDataDirectoryPath();
    QDir dir(dirPath);
    if (!dir.exists()) {
        dir.mkpath(".");
    }

    QString fullPath = dirPath + "/transactions.csv";
    QFile file(fullPath);

    if (file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        QTextStream in(&file);
        if (!in.atEnd()) {
            in.readLine(); // Bỏ qua dòng tiêu đề
        }

        while (!in.atEnd()) {
            QString line = in.readLine().trimmed();
            if (line.isEmpty()) continue;

            QStringList fields = line.split(",");
            if (fields.size() >= 7) {
                QString type = fields[0];
                int id = fields[1].toInt();
                QString title = fields[2];
                double amount = fields[3].toDouble();
                QDateTime dt = QDateTime::fromString(fields[4], Qt::ISODate);
                if (!dt.isValid()) dt = QDateTime::currentDateTime();
                QString method = fields[5];
                int catId = fields[6].toInt();

                if (type == "Income") {
                    m_transactions.append(new Income(id, title, amount, dt, method, catId));
                } else {
                    m_transactions.append(new Expense(id, title, amount, dt, method, catId));
                }
            }
        }
        file.close();
    }

    if (m_transactions.isEmpty()) {
        qDebug() << "Khởi tạo dữ liệu giao dịch mẫu ban đầu...";
        int id = 1;
        QDateTime now = QDateTime::currentDateTime();
        m_transactions.append(new Income(id++, "Monthly Salary", 15000000.0, now.addDays(-15), "Bank Transfer", 1));
        m_transactions.append(new Income(id++, "Freelance Web Design", 3500000.0, now.addDays(-5), "Bank Transfer", 2));
        m_transactions.append(new Expense(id++, "Monthly Apartment Rent", 3500000.0, now.addDays(-10), "Cash", 6));
        m_transactions.append(new Expense(id++, "Weekly Grocery & Dining", 850000.0, now.addDays(-3), "Cash", 5));
        m_transactions.append(new Expense(id++, "Fiber Internet Service", 250000.0, now.addDays(-2), "Credit Card", 8));
        m_transactions.append(new Expense(id++, "Fuel & Transportation", 200000.0, now.addDays(-1), "Cash", 7));
        saveToCSV();
    }
}

void TransactionDAO::saveToCSV() const {
    QString dirPath = DatabaseManager::getDataDirectoryPath();
    QDir dir(dirPath);
    if (!dir.exists()) {
        dir.mkpath(".");
    }

    QString fullPath = dirPath + "/transactions.csv";
    QFile file(fullPath);
    if (!file.open(QIODevice::WriteOnly | QIODevice::Text)) {
        return;
    }

    QTextStream out(&file);
    out << "type,id,title,amount,dateTime,method,categoryId\n";

    for (const Transaction* t : m_transactions) {
        if (!t) continue;
        QString type = (dynamic_cast<const Income*>(t) != nullptr) ? "Income" : "Expense";
        out << type << ","
            << t->getId() << ","
            << t->getTitle() << ","
            << QString::number(t->getAmount(), 'f', 2) << ","
            << t->getDateTime().toString(Qt::ISODate) << ","
            << t->getMethod() << ","
            << t->getCategoryId() << "\n";
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

bool TransactionDAO::exportToCSV(const QString& targetFilePath) const {
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
    out << "=== TRANSACTIONS EXPORT REPORT ===\n";
    out << "Generated Date,\"" << QDateTime::currentDateTime().toString("yyyy-MM-dd HH:mm:ss") << "\"\n\n";
    out << "Type,ID,Title,Amount (VND),Date & Time,Payment Method,Category Name\n";

    for (const Transaction* t : m_transactions) {
        if (!t) continue;
        QString type = (dynamic_cast<const Income*>(t) != nullptr) ? "Income" : "Expense";
        QString escapedTitle = QString(t->getTitle()).replace("\"", "\"\"");
        QString escapedMethod = QString(t->getMethod()).replace("\"", "\"\"");
        QString catName = QString(getCatName(t->getCategoryId())).replace("\"", "\"\"");

        out << type << ","
            << t->getId() << ",\""
            << escapedTitle << "\","
            << QString::number(t->getAmount(), 'f', 2) << ",\""
            << t->getDateTime().toString("yyyy-MM-dd HH:mm:ss") << ",\""
            << escapedMethod << "\",\""
            << catName << "\"\n";
    }
    file.close();
    return true;
}
