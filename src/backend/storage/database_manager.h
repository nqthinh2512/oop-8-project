#ifndef DATABASE_MANAGER_H
#define DATABASE_MANAGER_H

#include <QObject>
#include <QVector>
#include <QString>
#include <QCoreApplication>
#include <QDir>
#include <QScopedPointer>

#include "../models/category.h"
#include "../models/bill.h"
#include "../models/budget.h"
#include "../models/saving.h"
#include "../models/transaction.h"

// Forward declarations
class CategoryDAO;
class BillDAO;
class BudgetDAO;
class SavingDAO;
class TransactionDAO;

class DatabaseManager : public QObject {
    Q_OBJECT
private:
    QScopedPointer<CategoryDAO> m_categoryDAO;
    QScopedPointer<BillDAO> m_billDAO;
    QScopedPointer<BudgetDAO> m_budgetDAO;
    QScopedPointer<SavingDAO> m_savingDAO;
    QScopedPointer<TransactionDAO> m_transactionDAO;

    explicit DatabaseManager(QObject *parent = nullptr);
    ~DatabaseManager();

public:
    static DatabaseManager& instance() {
        static DatabaseManager instance;
        return instance;
    }

    DatabaseManager(const DatabaseManager&) = delete;
    DatabaseManager& operator=(const DatabaseManager&) = delete;

    static QString getDataDirectoryPath() {
        static QString cachedPath;
        if (cachedPath.isEmpty()) {
            QDir devDir(QCoreApplication::applicationDirPath() + "/../../data");
            if (devDir.exists()) {
                cachedPath = devDir.absolutePath();
            } else {
                cachedPath = QCoreApplication::applicationDirPath() + "/data";
            }
        }
        return cachedPath;
    }

    CategoryDAO* categoryDAO() const { return m_categoryDAO.data(); }
    BillDAO* billDAO() const { return m_billDAO.data(); }
    BudgetDAO* budgetDAO() const { return m_budgetDAO.data(); }
    SavingDAO* savingDAO() const { return m_savingDAO.data(); }
    TransactionDAO* transactionDAO() const { return m_transactionDAO.data(); }

    void triggerDataChanged() { emit dataChanged(); }

signals:
    void dataChanged();

public:
    //=============================EXPORT SECTION==================================
    bool exportAllToCSV(const QString& targetFolderPath) const;
};

#endif // DATABASE_MANAGER_H