// database_manager_transaction.cpp
#include "database_manager.h"
#include <QFile>
#include <QTextStream>
#include <QDir>
#include <QDebug>

int DatabaseManager::generateNextTransactionId() const {
    int maxId = 0;
    for (const Transaction* t : m_transactions) {
        if (t && t->getId() > maxId) {
            maxId = t->getId();
        }
    }
    return maxId + 1;
}

// 🎯 ĐỌC FILE CSV: Đọc type, id, amount, date, note, categoryId
void DatabaseManager::loadTransactionsFromCSV() {
    qDeleteAll(m_transactions);
    m_transactions.clear();

    QString dirPath = QCoreApplication::applicationDirPath() + "/data";
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

    // khởi tạo dữ liệu __TẠM THỜI__ để test tính năng

    if (m_transactions.isEmpty()) {
        qDebug() << "Khởi tạo dữ liệu giao dịch mẫu ban đầu...";
        int id = 1;
        QDateTime now = QDateTime::currentDateTime();

        // 1. Thu nhập (Income)
        m_transactions.append(new Income(id++, 15000000.0, now.addDays(-15), "Monthly Salary", 1)); // Salary
        m_transactions.append(new Income(id++, 3500000.0, now.addDays(-5), "Freelance Web Design", 2)); // Freelance

        // 2. Chi tiêu (Expense)
        m_transactions.append(new Expense(id++, 3500000.0, now.addDays(-10), "Monthly Apartment Rent", 6)); // Housing & Rent
        m_transactions.append(new Expense(id++, 850000.0, now.addDays(-3), "Weekly Grocery & Dining", 5)); // Food & Dining
        m_transactions.append(new Expense(id++, 250000.0, now.addDays(-2), "Fiber Internet Service", 8)); // Utilities & Services
        m_transactions.append(new Expense(id++, 200000.0, now.addDays(-1), "Fuel & Transportation", 7)); // Transportation

        saveTransactionsToCSV();
    }

    qDebug() << "Đã tải" << m_transactions.size() << "giao dịch từ transactions.csv vào RAM.";
}

//  ghi file csv : Ghi type, id, amount, date, note, categoryId
void DatabaseManager::saveTransactionsToCSV() const {
    QString dirPath = QCoreApplication::applicationDirPath() + "/data";
    QDir dir(dirPath);
    if (!dir.exists()) {
        dir.mkpath(".");
    }

    QString fullPath = dirPath + "/transactions.csv";
    QFile file(fullPath);
    if (!file.open(QIODevice::WriteOnly | QIODevice::Text)) {
        qWarning() << "Không thể ghi dữ liệu vào file transactions.csv!";
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
    const_cast<DatabaseManager*>(this)->emit dataChanged();
}

void DatabaseManager::addTransaction(Transaction* transaction) {
    if (!transaction) return;
    m_transactions.append(transaction);
    saveTransactionsToCSV();
}

bool DatabaseManager::updateTransaction(int id, Transaction* newTransaction) {
    if (!newTransaction) return false;
    for (int i = 0; i < m_transactions.size(); ++i) {
        if (m_transactions[i] && m_transactions[i]->getId() == id) {
            delete m_transactions[i];
            m_transactions[i] = newTransaction;
            saveTransactionsToCSV();
            return true;
        }
    }
    delete newTransaction;
    return false;
}

bool DatabaseManager::deleteTransaction(int id) {
    for (int i = 0; i < m_transactions.size(); ++i) {
        if (m_transactions[i] && m_transactions[i]->getId() == id) {
            delete m_transactions[i];
            m_transactions.removeAt(i);
            saveTransactionsToCSV();
            return true;
        }
    }
    return false;
}