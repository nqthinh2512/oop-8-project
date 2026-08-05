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

    // khởi tạo dữ liệu __TẠM THỜI__ để test tính năng

    if (m_transactions.isEmpty()) {
        qDebug() << "Khởi tạo dữ liệu giao dịch mẫu ban đầu...";
        int id = 1;
        QDateTime now = QDateTime::currentDateTime();

        // 1. Thu nhập (Income)
        m_transactions.append(new Income(id++, "Monthly Salary", 15000000.0, now.addDays(-15), "Bank Transfer", 1)); // Salary
        m_transactions.append(new Income(id++, "Freelance Web Design", 3500000.0, now.addDays(-5), "Bank Transfer", 2)); // Freelance

        // 2. Chi tiêu (Expense)
        m_transactions.append(new Expense(id++, "Monthly Apartment Rent", 3500000.0, now.addDays(-10), "Cash", 6)); // Housing & Rent
        m_transactions.append(new Expense(id++, "Weekly Grocery & Dining", 850000.0, now.addDays(-3), "Cash", 5)); // Food & Dining
        m_transactions.append(new Expense(id++, "Fiber Internet Service", 250000.0, now.addDays(-2), "Credit Card", 8)); // Utilities & Services
        m_transactions.append(new Expense(id++, "Fuel & Transportation", 200000.0, now.addDays(-1), "Cash", 7)); // Transportation

        saveTransactionsToCSV();
    }

    qDebug() << "Đã tải" << m_transactions.size() << "giao dịch từ transactions.csv vào RAM.";
}

//  ghi file csv : Ghi type, id, title, amount, dateTime, method, categoryId
void DatabaseManager::saveTransactionsToCSV() const {
    QString dirPath = DatabaseManager::getDataDirectoryPath();
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