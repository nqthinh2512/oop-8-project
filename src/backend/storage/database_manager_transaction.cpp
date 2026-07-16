#include "database_manager.h"
#include <QFile>
#include <QTextStream>
#include <QDir>
#include <QDebug>
#include <QStandardPaths>
#include <QCoreApplication>

// ==========================================================
// 🎯 CÁC HÀM XỬ LÝ GIAO DỊCH (CRUD - OOP)
// ==========================================================

int DatabaseManager::generateNextTransactionId() const {
    int maxId = 0;
    for (Transaction* tx : m_transactions) {
        if (tx->getId() > maxId) {
            maxId = tx->getId();
        }
    }
    return maxId + 1;
}

void DatabaseManager::loadTransactionsFromCSV() {
    // Xóa dữ liệu cũ nếu có
    for (Transaction* tx : m_transactions) {
        delete tx;
    }
    m_transactions.clear();

    QString appDataDir = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
    QDir dir(appDataDir);
    if (!dir.exists()) {
        dir.mkpath(".");
    }
    
    QString filePath = dir.filePath("transactions.csv");
    QFile file(filePath);
    
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        qDebug() << "Cannot open transactions.csv for reading or file does not exist yet.";
        return;
    }

    QTextStream in(&file);
    
    // Bỏ qua dòng tiêu đề
    if (!in.atEnd()) {
        in.readLine();
    }

    while (!in.atEnd()) {
        QString line = in.readLine();
        QStringList fields = line.split(",");
        
        // Expected format: ID, Amount, DateTime, Note, CategoryId, TransactionType, PaymentMethod, ClassType, ReceiptImagePath, Status, Source, Payee, IsEssential
        if (fields.size() >= 13) {
            int id = fields[0].toInt();
            double amount = fields[1].toDouble();
            QDateTime dateTime = QDateTime::fromString(fields[2], Qt::ISODate);
            QString note = fields[3];
            int categoryId = fields[4].toInt();
            QString txType = fields[5];
            QString payMethod = fields[6];
            QString classType = fields[7];
            QString receipt = fields[8];
            QString status = fields[9];
            QString payer = fields[10];
            QString payee = fields[11];
            bool isEssential = (fields[12] == "1" || fields[12].toLower() == "true");

            Transaction* newTx = nullptr;
            if (classType == "Income") {
                newTx = new Income(id, amount, dateTime, note, categoryId, txType, payMethod, receipt, status, payer);
            } else if (classType == "Expense") {
                newTx = new Expense(id, amount, dateTime, note, categoryId, txType, payMethod, receipt, status, payee, isEssential);
            } else {
                newTx = new Transaction(id, amount, dateTime, note, categoryId, txType, payMethod, receipt, status);
            }
            
            if (newTx) {
                m_transactions.append(newTx);
            }
        }
    }
    file.close();
}

void DatabaseManager::saveTransactionsToCSV() const {
    QString appDataDir = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
    QDir dir(appDataDir);
    if (!dir.exists()) {
        dir.mkpath(".");
    }
    
    QString filePath = dir.filePath("transactions.csv");
    QFile file(filePath);
    
    if (!file.open(QIODevice::WriteOnly | QIODevice::Text)) {
        qDebug() << "Cannot open transactions.csv for writing.";
        return;
    }

    QTextStream out(&file);
    out << "ID,Amount,DateTime,Note,CategoryId,TransactionType,PaymentMethod,ClassType,ReceiptImagePath,Status,Payer,Payee,IsEssential\n";

    for (Transaction* tx : m_transactions) {
        QString classType = "Transaction";
        QString payer = "";
        QString payee = "";
        QString isEssential = "";

        if (Income* income = dynamic_cast<Income*>(tx)) {
            classType = "Income";
            payer = income->getPayer();
        } else if (Expense* expense = dynamic_cast<Expense*>(tx)) {
            classType = "Expense";
            payee = expense->getPayee();
            isEssential = expense->getIsEssential() ? "1" : "0";
        }

        out << tx->getId() << ","
            << QString::number(tx->getAmount(), 'f', 2) << ","
            << tx->getDateTime().toString(Qt::ISODate) << ","
            << tx->getNote() << ","
            << tx->getCategoryId() << ","
            << tx->getTransactionType() << ","
            << tx->getPaymentMethod() << ","
            << classType << ","
            << tx->getReceiptImagePath() << ","
            << tx->getStatus() << ","
            << payer << ","
            << payee << ","
            << isEssential << "\n";
    }
    
    file.close();
}

void DatabaseManager::addTransaction(Transaction* newTransaction) {
    if (newTransaction) {
        m_transactions.append(newTransaction);
        saveTransactionsToCSV();
    }
}

bool DatabaseManager::updateTransaction(int id, double amount, const QDateTime& dateTime, int categoryId, const QString& note, const QString& transactionType, const QString& paymentMethod) {
    for (Transaction* tx : m_transactions) {
        if (tx->getId() == id) {
            tx->setAmount(amount);
            tx->setDateTime(dateTime);
            tx->setCategoryId(categoryId);
            tx->setNote(note);
            tx->setTransactionType(transactionType);
            tx->setPaymentMethod(paymentMethod);
            saveTransactionsToCSV();
            return true;
        }
    }
    return false;
}

bool DatabaseManager::deleteTransaction(int id) {
    for (int i = 0; i < m_transactions.size(); ++i) {
        if (m_transactions[i]->getId() == id) {
            delete m_transactions[i];
            m_transactions.removeAt(i);
            saveTransactionsToCSV();
            return true;
        }
    }
    return false;
}