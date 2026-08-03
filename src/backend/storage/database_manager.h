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

signals:
    void dataChanged();

public:
    //=============================CATEGORY SECTION================================
    void loadCategoriesFromCSV();
    void saveCategoriesToCSV() const;
    const QVector<Category>& getAllCategories() const;
    void addUserCustomCategory(const QString& name, int parentId, bool active = true);
    void updateCategory(int id, const QString& name, int newParentId, bool active);
    void updateCategoryParent(int id, int newParentId);
    void removeCategory(int id);
    void migrateAndRemoveCategory(int sourceCatId, int targetCatId);
    void deactivateCategory(int id);

    //=============================BILL SECTION==================================
    void loadBillsFromCSV();
    void saveBillsToCSV() const;
    const QVector<Bill>& getAllBills() const;
    void addBill(const Bill& b);
    void updateBill(int id, const Bill& b);
    void deleteBill(int id);

    //=============================BUDGET SECTION==================================
    void loadBudgetsFromCSV();
    void saveBudgetsToCSV() const;
    const QVector<Budget>& getAllBudgets() const;
    void addBudget(const QString& name, Priority priority, int categoryId,
                   double limit, const QDate& startDate, const QDate& endDate);
    bool updateBudget(int budgetId, const QString& name, Priority priority, int categoryId,
                      double limit, const QDate& startDate, const QDate& endDate);
    bool deleteBudget(int budgetId);
    void addExpenseToBudget(int categoryId, double amount);

    //=============================SAVING SECTION==================================
    void loadSavingsFromCSV();
    void saveSavingsToCSV() const;
    const QVector<Saving>& getAllSavings() const;
    void addSaving(const QString& name, Priority priority, int categoryId, double target, double currentAmount, const QDate& dueDate);
    bool updateSaving(int savingId, const QString& name, Priority priority, int categoryId, double target, double currentAmount, const QDate& dueDate);
    bool contributeToSaving(int savingId, double amount);
    bool deleteSaving(int savingId);

    //==========================TRANSACTION SECTION=================================
    void loadTransactionsFromCSV();
    void saveTransactionsToCSV() const;
    const QVector<Transaction*>& getAllTransactions() const;
    void addTransaction(Transaction* transaction);
    bool updateTransaction(int id, Transaction* newTransaction);
    bool deleteTransaction(int id);

    //=============================EXPORT SECTION==================================
    bool exportCategoriesToCSV(const QString& targetFilePath) const;
    bool exportBillsToCSV(const QString& targetFilePath) const;
    bool exportBudgetsToCSV(const QString& targetFilePath) const;
    bool exportSavingsToCSV(const QString& targetFilePath) const;
    bool exportTransactionsToCSV(const QString& targetFilePath) const;
    bool exportAllToCSV(const QString& targetFolderPath) const;
};

#endif // DATABASE_MANAGER_H