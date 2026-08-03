#include "database_manager.h"
#include "../dao/category_dao.h"
#include "../dao/bill_dao.h"
#include "../dao/budget_dao.h"
#include "../dao/saving_dao.h"
#include "../dao/transaction_dao.h"
#include <QDir>
#include <QFile>

DatabaseManager::DatabaseManager(QObject *parent)
    : QObject(parent),
      m_categoryDAO(new CategoryDAO()),
      m_billDAO(new BillDAO()),
      m_budgetDAO(new BudgetDAO()),
      m_savingDAO(new SavingDAO()),
      m_transactionDAO(new TransactionDAO())
{
}

DatabaseManager::~DatabaseManager() {}

bool DatabaseManager::exportAllToCSV(const QString& targetFolderPath) const {
    QDir dir(targetFolderPath);
    if (!dir.exists()) {
        if (!dir.mkpath(".")) return false;
    }
    bool success = true;
    success &= m_categoryDAO->exportToCSV(targetFolderPath + "/categories_export.csv");
    success &= m_transactionDAO->exportToCSV(targetFolderPath + "/transactions_export.csv");
    success &= m_billDAO->exportToCSV(targetFolderPath + "/bills_export.csv");
    success &= m_budgetDAO->exportToCSV(targetFolderPath + "/budgets_export.csv");
    success &= m_savingDAO->exportToCSV(targetFolderPath + "/savings_export.csv");
    return success;
}
