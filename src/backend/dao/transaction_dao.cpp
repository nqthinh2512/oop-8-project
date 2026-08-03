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
            if (fields.size() >= 6) {
                QString type = fields[0];
                int id = fields[1].toInt();
                double amount = fields[2].toDouble();
                QDateTime dt = QDateTime::fromString(fields[3], Qt::ISODate);
                if (!dt.isValid()) dt = QDateTime::currentDateTime();
                QString note = fields[4];
                int catId = fields[5].toInt();

                if (type == "Income") {
                    m_transactions.append(new Income(id, amount, dt, note, catId));
                } else {
                    m_transactions.append(new Expense(id, amount, dt, note, catId));
                }
            }
        }
        file.close();
    }

    if (m_transactions.isEmpty()) {
        qDebug() << "Khởi tạo dữ liệu giao dịch mẫu ban đầu...";
        int id = 1;
        QDateTime now = QDateTime::currentDateTime();
        m_transactions.append(new Income(id++, 15000000.0, now.addDays(-15), "Monthly Salary", 1));
        m_transactions.append(new Income(id++, 3500000.0, now.addDays(-5), "Freelance Web Design", 2));
        m_transactions.append(new Expense(id++, 3500000.0, now.addDays(-10), "Monthly Apartment Rent", 6));
        m_transactions.append(new Expense(id++, 850000.0, now.addDays(-3), "Weekly Grocery & Dining", 5));
        m_transactions.append(new Expense(id++, 250000.0, now.addDays(-2), "Fiber Internet Service", 8));
        m_transactions.append(new Expense(id++, 200000.0, now.addDays(-1), "Fuel & Transportation", 7));
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
    out << "type,id,amount,dateTime,note,categoryId\n";

    for (const Transaction* t : m_transactions) {
        if (!t) continue;
        QString type = (dynamic_cast<const Income*>(t) != nullptr) ? "Income" : "Expense";
        out << type << ","
            << t->getId() << ","
            << QString::number(t->getAmount(), 'f', 2) << ","
            << t->getDateTime().toString(Qt::ISODate) << ","
            << t->getNote() << ","
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

    QTextStream out(&file);
    out << "type,id,amount,dateTime,note,categoryId\n";

    for (const Transaction* t : m_transactions) {
        if (!t) continue;
        QString type = (dynamic_cast<const Income*>(t) != nullptr) ? "Income" : "Expense";
        out << type << ","
            << t->getId() << ","
            << QString::number(t->getAmount(), 'f', 2) << ","
            << t->getDateTime().toString(Qt::ISODate) << ","
            << t->getNote() << ","
            << t->getCategoryId() << "\n";
    }
    file.close();
    return true;
}
