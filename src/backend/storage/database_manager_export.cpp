// database_manager_export.cpp
#include "database_manager.h"
#include <QFile>
#include <QTextStream>
#include <QDir>
#include <QUrl>
#include <QDebug>

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

bool DatabaseManager::exportCategoriesToCSV(const QString& targetFilePath) const {
    QString cleanPath = resolveLocalPath(targetFilePath);
    QFile file(cleanPath);
    if (!file.open(QIODevice::WriteOnly | QIODevice::Text)) {
        qWarning() << "Failed to export categories to:" << cleanPath;
        return false;
    }

    QTextStream out(&file);
    out << "id,name,parentId,active\n";
    for (const Category& cat : m_categories) {
        out << cat.getId() << ","
            << cat.getName() << ","
            << cat.getParentId() << ","
            << (cat.isActive() ? 1 : 0) << "\n";
    }
    file.close();
    qDebug() << "Successfully exported categories to:" << cleanPath;
    return true;
}

bool DatabaseManager::exportBillsToCSV(const QString& targetFilePath) const {
    QString cleanPath = resolveLocalPath(targetFilePath);
    QFile file(cleanPath);
    if (!file.open(QIODevice::WriteOnly | QIODevice::Text)) {
        qWarning() << "Failed to export bills to:" << cleanPath;
        return false;
    }

    QTextStream out(&file);
    out << "id,name,amount,dueDate,categoryId,isPaid\n";
    for (const Bill& b : m_bills) {
        out << b.getId() << ","
            << b.getName() << ","
            << QString::number(b.getAmount(), 'f', 2) << ","
            << b.getDueDate().toString(Qt::ISODate) << ","
            << b.getCategoryId() << ","
            << (b.checkPaid() ? 1 : 0) << "\n";
    }
    file.close();
    qDebug() << "Successfully exported bills to:" << cleanPath;
    return true;
}

bool DatabaseManager::exportBudgetsToCSV(const QString& targetFilePath) const {
    QString cleanPath = resolveLocalPath(targetFilePath);
    QFile file(cleanPath);
    if (!file.open(QIODevice::WriteOnly | QIODevice::Text)) {
        qWarning() << "Failed to export budgets to:" << cleanPath;
        return false;
    }

    QTextStream out(&file);
    out << "id,name,priority,categoryId,limitAmount,spentAmount,startDate,endDate\n";
    for (const Budget& b : m_budgets) {
        out << b.getId() << ","
            << b.getName() << ","
            << static_cast<int>(b.getPriority()) << ","
            << b.getCategoryId() << ","
            << QString::number(b.getLimit(), 'f', 2) << ","
            << QString::number(b.getSpent(), 'f', 2) << ","
            << b.getStartDate().toString(Qt::ISODate) << ","
            << b.getEndDate().toString(Qt::ISODate) << "\n";
    }
    file.close();
    qDebug() << "Successfully exported budgets to:" << cleanPath;
    return true;
}

bool DatabaseManager::exportSavingsToCSV(const QString& targetFilePath) const {
    QString cleanPath = resolveLocalPath(targetFilePath);
    QFile file(cleanPath);
    if (!file.open(QIODevice::WriteOnly | QIODevice::Text)) {
        qWarning() << "Failed to export savings to:" << cleanPath;
        return false;
    }

    QTextStream out(&file);
    out << "id,name,priority,categoryId,targetAmount,currentAmount,dueDate\n";
    for (const Saving& s : m_savings) {
        out << s.getId() << ","
            << s.getName() << ","
            << static_cast<int>(s.getPriority()) << ","
            << s.getCategoryId() << ","
            << QString::number(s.getTarget(), 'f', 2) << ","
            << QString::number(s.getCurrent(), 'f', 2) << ","
            << s.getDueDate().toString(Qt::ISODate) << "\n";
    }
    file.close();
    qDebug() << "Successfully exported savings to:" << cleanPath;
    return true;
}

bool DatabaseManager::exportTransactionsToCSV(const QString& targetFilePath) const {
    QString cleanPath = resolveLocalPath(targetFilePath);
    QFile file(cleanPath);
    if (!file.open(QIODevice::WriteOnly | QIODevice::Text)) {
        qWarning() << "Failed to export transactions to:" << cleanPath;
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
    qDebug() << "Successfully exported transactions to:" << cleanPath;
    return true;
}

bool DatabaseManager::exportAllToCSV(const QString& targetFolderPath) const {
    QString cleanDir = resolveLocalPath(targetFolderPath);
    QDir dir(cleanDir);
    if (!dir.exists()) {
        dir.mkpath(".");
    }

    bool success = true;
    success &= exportCategoriesToCSV(cleanDir + "/categories_export.csv");
    success &= exportTransactionsToCSV(cleanDir + "/transactions_export.csv");
    success &= exportBillsToCSV(cleanDir + "/bills_export.csv");
    success &= exportBudgetsToCSV(cleanDir + "/budgets_export.csv");
    success &= exportSavingsToCSV(cleanDir + "/savings_export.csv");

    return success;
}
