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

// ======================= CATEGORY SECTION =======================
void DatabaseManager::loadCategoriesFromCSV() { m_categoryDAO->loadFromCSV(); emit dataChanged(); }
void DatabaseManager::saveCategoriesToCSV() const { m_categoryDAO->saveToCSV(); const_cast<DatabaseManager*>(this)->emit dataChanged(); }
const QVector<Category>& DatabaseManager::getAllCategories() const { return m_categoryDAO->getAll(); }

void DatabaseManager::addUserCustomCategory(const QString& name, int parentId, bool active) {
    Category cat(0, parentId, name);
    cat.setActive(active);
    m_categoryDAO->add(cat);
    emit dataChanged();
}

void DatabaseManager::updateCategory(int id, const QString& name, int newParentId, bool active) {
    Category cat(id, newParentId, name);
    cat.setActive(active);
    m_categoryDAO->update(id, cat);
    emit dataChanged();
}

void DatabaseManager::updateCategoryParent(int id, int newParentId) {
    for (const Category& cat : m_categoryDAO->getAll()) {
        if (cat.getId() == id) {
            Category updatedCat = cat;
            updatedCat.setParentId(newParentId);
            m_categoryDAO->update(id, updatedCat);
            emit dataChanged();
            break;
        }
    }
}

void DatabaseManager::removeCategory(int id) {
    m_categoryDAO->remove(id);
    emit dataChanged();
}

void DatabaseManager::migrateAndRemoveCategory(int sourceCatId, int targetCatId) {
    // Migration logic
    for (const Transaction* t : m_transactionDAO->getAll()) {
        if (t->getCategoryId() == sourceCatId) {
            Transaction* updatedT = const_cast<Transaction*>(t);
            updatedT->setCategoryId(targetCatId);
            m_transactionDAO->update(t->getId(), updatedT);
        }
    }
    for (const Bill& b : m_billDAO->getAll()) {
        if (b.getCategoryId() == sourceCatId) {
            Bill updatedB = b;
            updatedB.setCategoryId(targetCatId);
            m_billDAO->update(b.getId(), updatedB);
        }
    }
    for (const Budget& b : m_budgetDAO->getAll()) {
        if (b.getCategoryId() == sourceCatId) {
            Budget updatedB = b;
            updatedB.setCategoryId(targetCatId);
            m_budgetDAO->update(b.getId(), updatedB);
        }
    }
    for (const Saving& s : m_savingDAO->getAll()) {
        if (s.getCategoryId() == sourceCatId) {
            Saving updatedS = s;
            updatedS.setCategoryId(targetCatId);
            m_savingDAO->update(s.getId(), updatedS);
        }
    }
    m_categoryDAO->remove(sourceCatId);
    emit dataChanged();
}

void DatabaseManager::deactivateCategory(int id) {
    m_categoryDAO->deactivate(id);
    emit dataChanged();
}

// ======================= BILL SECTION =======================
void DatabaseManager::loadBillsFromCSV() { m_billDAO->loadFromCSV(); emit dataChanged(); }
void DatabaseManager::saveBillsToCSV() const { m_billDAO->saveToCSV(); const_cast<DatabaseManager*>(this)->emit dataChanged(); }
const QVector<Bill>& DatabaseManager::getAllBills() const { return m_billDAO->getAll(); }
void DatabaseManager::addBill(const Bill& b) { m_billDAO->add(b); emit dataChanged(); }
void DatabaseManager::updateBill(int id, const Bill& b) { m_billDAO->update(id, b); emit dataChanged(); }
void DatabaseManager::deleteBill(int id) { m_billDAO->remove(id); emit dataChanged(); }

// ======================= BUDGET SECTION =======================
void DatabaseManager::loadBudgetsFromCSV() { m_budgetDAO->loadFromCSV(); emit dataChanged(); }
void DatabaseManager::saveBudgetsToCSV() const { m_budgetDAO->saveToCSV(); const_cast<DatabaseManager*>(this)->emit dataChanged(); }
const QVector<Budget>& DatabaseManager::getAllBudgets() const { return m_budgetDAO->getAll(); }

void DatabaseManager::addBudget(const QString& name, Priority priority, int categoryId, double limit, const QDate& startDate, const QDate& endDate) {
    Budget b(0, name, priority, categoryId, limit, startDate, endDate, 0.0);
    m_budgetDAO->add(b);
    emit dataChanged();
}

bool DatabaseManager::updateBudget(int budgetId, const QString& name, Priority priority, int categoryId, double limit, const QDate& startDate, const QDate& endDate) {
    for (const Budget& b : m_budgetDAO->getAll()) {
        if (b.getId() == budgetId) {
            Budget updatedB = b;
            updatedB.setName(name);
            updatedB.setPriority(priority);
            updatedB.setCategoryId(categoryId);
            updatedB.setLimit(limit);
            updatedB.setStartDate(startDate);
            updatedB.setEndDate(endDate);
            bool ok = m_budgetDAO->update(budgetId, updatedB);
            if (ok) emit dataChanged();
            return ok;
        }
    }
    return false;
}

bool DatabaseManager::deleteBudget(int budgetId) {
    bool ok = m_budgetDAO->remove(budgetId);
    if (ok) emit dataChanged();
    return ok;
}

void DatabaseManager::addExpenseToBudget(int categoryId, double amount) {
    m_budgetDAO->addExpenseToBudget(categoryId, amount);
    emit dataChanged();
}

// ======================= SAVING SECTION =======================
void DatabaseManager::loadSavingsFromCSV() { m_savingDAO->loadFromCSV(); emit dataChanged(); }
void DatabaseManager::saveSavingsToCSV() const { m_savingDAO->saveToCSV(); const_cast<DatabaseManager*>(this)->emit dataChanged(); }
const QVector<Saving>& DatabaseManager::getAllSavings() const { return m_savingDAO->getAll(); }

void DatabaseManager::addSaving(const QString& name, Priority priority, int categoryId, double target, double currentAmount, const QDate& dueDate) {
    int catId = (categoryId == 0 ? Saving::parentCategory : categoryId);
    Saving s(0, name, priority, dueDate, target, currentAmount, catId);
    m_savingDAO->add(s);
    emit dataChanged();
}

bool DatabaseManager::updateSaving(int savingId, const QString& name, Priority priority, int categoryId, double target, double currentAmount, const QDate& dueDate) {
    for (const Saving& s : m_savingDAO->getAll()) {
        if (s.getId() == savingId) {
            Saving updatedS = s;
            updatedS.setName(name);
            updatedS.setPriority(priority);
            if (categoryId != 0) updatedS.setCategoryId(categoryId);
            updatedS.setTarget(target);
            updatedS.setCurrent(currentAmount);
            updatedS.setDueDate(dueDate);
            bool ok = m_savingDAO->update(savingId, updatedS);
            if (ok) emit dataChanged();
            return ok;
        }
    }
    return false;
}

bool DatabaseManager::contributeToSaving(int savingId, double amount) {
    bool ok = m_savingDAO->contributeToSaving(savingId, amount);
    if (ok) emit dataChanged();
    return ok;
}

bool DatabaseManager::deleteSaving(int savingId) {
    bool ok = m_savingDAO->remove(savingId);
    if (ok) emit dataChanged();
    return ok;
}

// ======================= TRANSACTION SECTION =======================
void DatabaseManager::loadTransactionsFromCSV() { m_transactionDAO->loadFromCSV(); emit dataChanged(); }
void DatabaseManager::saveTransactionsToCSV() const { m_transactionDAO->saveToCSV(); const_cast<DatabaseManager*>(this)->emit dataChanged(); }
const QVector<Transaction*>& DatabaseManager::getAllTransactions() const { return m_transactionDAO->getAll(); }
void DatabaseManager::addTransaction(Transaction* transaction) { m_transactionDAO->add(transaction); emit dataChanged(); }
bool DatabaseManager::updateTransaction(int id, Transaction* newTransaction) { bool ok = m_transactionDAO->update(id, newTransaction); if (ok) emit dataChanged(); return ok; }
bool DatabaseManager::deleteTransaction(int id) { bool ok = m_transactionDAO->remove(id); if (ok) emit dataChanged(); return ok; }

// ======================= EXPORT SECTION =======================
bool DatabaseManager::exportCategoriesToCSV(const QString& targetFilePath) const { return m_categoryDAO->exportToCSV(targetFilePath); }
bool DatabaseManager::exportBillsToCSV(const QString& targetFilePath) const { return m_billDAO->exportToCSV(targetFilePath); }
bool DatabaseManager::exportBudgetsToCSV(const QString& targetFilePath) const { return m_budgetDAO->exportToCSV(targetFilePath); }
bool DatabaseManager::exportSavingsToCSV(const QString& targetFilePath) const { return m_savingDAO->exportToCSV(targetFilePath); }
bool DatabaseManager::exportTransactionsToCSV(const QString& targetFilePath) const { return m_transactionDAO->exportToCSV(targetFilePath); }

bool DatabaseManager::exportAllToCSV(const QString& targetFolderPath) const {
    QDir dir(targetFolderPath);
    if (!dir.exists()) {
        if (!dir.mkpath(".")) return false;
    }
    bool success = true;
    success &= exportCategoriesToCSV(targetFolderPath + "/categories_export.csv");
    success &= exportTransactionsToCSV(targetFolderPath + "/transactions_export.csv");
    success &= exportBillsToCSV(targetFolderPath + "/bills_export.csv");
    success &= exportBudgetsToCSV(targetFolderPath + "/budgets_export.csv");
    success &= exportSavingsToCSV(targetFolderPath + "/savings_export.csv");
    return success;
}
