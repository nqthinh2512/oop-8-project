#include "transactions_controller.h"
#include <QDebug>
#include <QDate>
#include <QLocale>
#include <QDateTime>
#include "../backend/models/transaction_factory.h"

// ============================================================================
// TRANSACTION LIST MODEL IMPLEMENTATION
// ============================================================================

TransactionListModel::TransactionListModel(QObject *parent)
    : QAbstractListModel(parent)
{
}

int TransactionListModel::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid()) return 0;
    return m_transactions.count();
}

QVariant TransactionListModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.row() >= m_transactions.count())
        return QVariant();

    const Transaction* t = m_transactions[index.row()];
    if (!t) return QVariant();

    switch (role) {
    case IdRole:
        return t->getId();
    case TypeRole: {
        return (dynamic_cast<const Income*>(t) != nullptr) ? 0 : 1;
    }
    case TitleRole: {
        if (!t->getTitle().isEmpty()) return t->getTitle();
        if (t->getCategoryId() == 0) return "Uncategorized";
        for (const auto& cat : DatabaseManager::instance().categoryDAO()->getAll()) {
            if (cat.getId() == t->getCategoryId()) return cat.getName();
        }
        return "Uncategorized";
    }
    case CategoryRole: {
        if (t->getCategoryId() == 0) return "Uncategorized";
        for (const auto& cat : DatabaseManager::instance().categoryDAO()->getAll()) {
            if (cat.getId() == t->getCategoryId()) {
                return cat.getName();
            }
        }
        return "Uncategorized";
    }
    case AmountRole: {
        QString formatted = QLocale(QLocale::English).toString(t->getAmount(), 'f', 0);
        return formatted + " VND";
    }
    case MethodRole: {
        return t->getMethod().isEmpty() ? "Cash/Bank" : t->getMethod();
    }
    case DateRole:
        return t->getDateTime().toString("dd/MM/yyyy");
    default:
        return QVariant();
    }
}

QHash<int, QByteArray> TransactionListModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[IdRole] = "tId";
    roles[TypeRole] = "tType";
    roles[TitleRole] = "tName";
    roles[AmountRole] = "tAmount";
    roles[CategoryRole] = "tCat";
    roles[MethodRole] = "tMethod";
    roles[DateRole] = "tDate";
    return roles;
}

void TransactionListModel::setTransactions(const QVector<Transaction*>& transactions)
{
    beginResetModel();
    m_transactions = transactions;

    std::sort(m_transactions.begin(), m_transactions.end(), [](const Transaction* a, const Transaction* b) {
        return a->getDateTime() > b->getDateTime();
    });

    endResetModel();
}

// ============================================================================
// TRANSACTIONS CONTROLLER IMPLEMENTATION
// ============================================================================

TransactionsController::TransactionsController(QObject *parent)
    : QObject(parent),
      m_model(new TransactionListModel(this)),
      m_filterType(-1),
      m_searchKeyword(""),
      m_categoryIdFilter(0)
{
    connect(&DatabaseManager::instance(), &DatabaseManager::dataChanged, this, &TransactionsController::loadTransactions);
    loadTransactions();
}

void TransactionsController::setFilterType(int type)
{
    if (m_filterType != type) {
        m_filterType = type;
        emit filterTypeChanged();
        applyFilter();
    }
}

void TransactionsController::setSearchKeyword(const QString& keyword)
{
    if (m_searchKeyword != keyword) {
        m_searchKeyword = keyword;
        emit searchKeywordChanged();
        applyFilter();
    }
}

void TransactionsController::setCategoryIdFilter(int catId)
{
    if (m_categoryIdFilter != catId) {
        m_categoryIdFilter = catId;
        emit categoryIdFilterChanged();
        applyFilter();
    }
}

void TransactionsController::loadTransactions()
{
    applyFilter();
}

void TransactionsController::applyFilter()
{
    const QVector<Transaction*>& all = DatabaseManager::instance().transactionDAO()->getAll();
    QVector<Transaction*> filtered;

    QString searchLower = m_searchKeyword.toLower();

    for (Transaction* t : all) {
        if (!t) continue;

        // 1. Filter by Type (0 = Income, 1 = Expense)
        int tType = (dynamic_cast<const Income*>(t) != nullptr) ? 0 : 1;

        if (m_filterType != -1 && m_filterType != tType) {
            continue;
        }

        // 2. Filter by Category ID
        if (m_categoryIdFilter > 0 && t->getCategoryId() != m_categoryIdFilter) {
            continue;
        }

        // 3. Filter by Keyword (Title / Category Name / Method / Amount)
        if (!searchLower.isEmpty()) {
            QString catName = "Uncategorized";
            for (const auto& cat : DatabaseManager::instance().categoryDAO()->getAll()) {
                if (cat.getId() == t->getCategoryId()) {
                    catName = cat.getName();
                    break;
                }
            }
            bool matches = t->getTitle().toLower().contains(searchLower) ||
                           catName.toLower().contains(searchLower) ||
                           t->getMethod().toLower().contains(searchLower) ||
                           QString::number(t->getAmount(), 'f', 0).contains(searchLower);
            if (!matches) continue;
        }

        filtered.append(t);
    }

    m_model->setTransactions(filtered);
}

void TransactionsController::addTransaction(int typeIndex, const QString& title, double amount, const QString& dateStr, int categoryId, const QString& method, int linkedBillId, int linkedSavingId, int linkedBudgetId)
{
    QDate date = QDate::fromString(dateStr, "dd/MM/yyyy");
    if (!date.isValid()) {
        date = QDate::currentDate();
    }
    QDateTime dt(date, QTime::currentTime());

    int maxId = 0;
    for (const auto* t : DatabaseManager::instance().transactionDAO()->getAll()) {
        if (t && t->getId() > maxId) maxId = t->getId();
    }
    int id = maxId + 1;

    QString cleanMethod = method.isEmpty() ? "Cash/Bank" : method;
    QString cleanTitle = title.isEmpty() ? "Transaction" : title;
    Transaction* newTx = TransactionFactory::createTransaction(typeIndex, id, cleanTitle, amount, dt, cleanMethod, categoryId, linkedBillId, linkedSavingId);

    DatabaseManager::instance().transactionDAO()->add(newTx);
    
    // Hub Architecture: Sync back to Budgets / Bills / Savings
    if (linkedBudgetId != -1) {
        for (const Budget& b : DatabaseManager::instance().budgetDAO()->getAll()) {
            if (b.getId() == linkedBudgetId) {
                Budget updatedBudget = b;
                if (typeIndex == 1) { // Expense
                    updatedBudget.addExpense(amount);
                } else { // Income
                    double newSpent = std::max(0.0, b.getSpent() - amount);
                    updatedBudget.setSpent(newSpent);
                }
                DatabaseManager::instance().budgetDAO()->update(linkedBudgetId, updatedBudget);
                break;
            }
        }
    } else if (typeIndex == 1) { // 1 = Expense default category sync
        DatabaseManager::instance().budgetDAO()->addExpenseToBudget(categoryId, amount);
    }
    
    if (linkedBillId != -1) {
        for (const Bill& b : DatabaseManager::instance().billDAO()->getAll()) {
            if (b.getId() == linkedBillId) {
                Bill updatedBill(b.getId(), b.getName(), b.getAmount(), b.getDueDate(), b.getCategoryId(), true);
                DatabaseManager::instance().billDAO()->update(linkedBillId, updatedBill);
                break;
            }
        }
    }
    
    if (linkedSavingId != -1) {
        for (const Saving& s : DatabaseManager::instance().savingDAO()->getAll()) {
            if (s.getId() == linkedSavingId) {
                double newCurrent = s.getCurrent() + amount;
                Saving updatedSaving(s.getId(), s.getName(), s.getPriority(), s.getDueDate(), s.getTarget(), newCurrent, s.getCategoryId());
                DatabaseManager::instance().savingDAO()->update(linkedSavingId, updatedSaving);
                break;
            }
        }
    }
    
    DatabaseManager::instance().triggerDataChanged();
    loadTransactions();
}

void TransactionsController::updateTransaction(int id, int typeIndex, const QString& title, double amount, const QString& dateStr, int categoryId, const QString& method, int linkedBillId, int linkedSavingId, int linkedBudgetId)
{
    QDate date = QDate::fromString(dateStr, "dd/MM/yyyy");
    if (!date.isValid()) {
        date = QDate::currentDate();
    }
    QDateTime dt(date, QTime::currentTime());

    QString cleanMethod = method.isEmpty() ? "Cash/Bank" : method;
    QString cleanTitle = title.isEmpty() ? "Transaction" : title;
    
    // Auto-sync Budget: Remove old amount, add new amount
    int oldCategoryId = 0;
    double oldAmount = 0;
    int oldTypeIndex = 0;
    for (const Transaction* t : DatabaseManager::instance().transactionDAO()->getAll()) {
        if (t->getId() == id) {
            oldCategoryId = t->getCategoryId();
            oldAmount = t->getAmount();
            oldTypeIndex = (dynamic_cast<const Income*>(t) != nullptr) ? 0 : 1;
            break;
        }
    }

    if (oldTypeIndex == 1) {
        DatabaseManager::instance().budgetDAO()->addExpenseToBudget(oldCategoryId, -oldAmount);
    }
    
    Transaction* newTx = TransactionFactory::createTransaction(typeIndex, id, cleanTitle, amount, dt, cleanMethod, categoryId, linkedBillId, linkedSavingId);

    DatabaseManager::instance().transactionDAO()->update(id, newTx);
    
    if (linkedBudgetId != -1) {
        for (const Budget& b : DatabaseManager::instance().budgetDAO()->getAll()) {
            if (b.getId() == linkedBudgetId) {
                Budget updatedBudget = b;
                if (typeIndex == 1) {
                    updatedBudget.addExpense(amount);
                }
                DatabaseManager::instance().budgetDAO()->update(linkedBudgetId, updatedBudget);
                break;
            }
        }
    } else if (typeIndex == 1) {
        DatabaseManager::instance().budgetDAO()->addExpenseToBudget(categoryId, amount);
    }
    
    // Hub Architecture: Sync updated amount back to Bill if linked
    if (linkedBillId != -1) {
        for (const Bill& b : DatabaseManager::instance().billDAO()->getAll()) {
            if (b.getId() == linkedBillId) {
                Bill updatedBill(b.getId(), b.getName(), amount, b.getDueDate(), b.getCategoryId(), true);
                DatabaseManager::instance().billDAO()->update(linkedBillId, updatedBill);
                break;
            }
        }
    }
    
    DatabaseManager::instance().triggerDataChanged();
    loadTransactions();
}

void TransactionsController::deleteTransaction(int id)
{
    // Lấy thông tin giao dịch để trừ lại khỏi budget
    int categoryId = 0;
    double amount = 0;
    int typeIndex = 0;
    int linkedBillId = -1;
    int linkedSavingId = -1;
    for (const Transaction* t : DatabaseManager::instance().transactionDAO()->getAll()) {
        if (t->getId() == id) {
            categoryId = t->getCategoryId();
            amount = t->getAmount();
            typeIndex = (dynamic_cast<const Income*>(t) != nullptr) ? 0 : 1;
            linkedBillId = t->getLinkedBillId();
            linkedSavingId = t->getLinkedSavingId();
            break;
        }
    }

    if (typeIndex == 1) {
        DatabaseManager::instance().budgetDAO()->addExpenseToBudget(categoryId, -amount);
    }
    
    // Hub Architecture: Revert Bill to Unpaid if deleted
    if (linkedBillId != -1) {
        for (const Bill& b : DatabaseManager::instance().billDAO()->getAll()) {
            if (b.getId() == linkedBillId) {
                Bill updatedBill(b.getId(), b.getName(), b.getAmount(), b.getDueDate(), b.getCategoryId(), false);
                DatabaseManager::instance().billDAO()->update(linkedBillId, updatedBill);
                break;
            }
        }
    }
    
    // Revert saving
    if (linkedSavingId != -1) {
        for (const Saving& s : DatabaseManager::instance().savingDAO()->getAll()) {
            if (s.getId() == linkedSavingId) {
                double newCurrent = s.getCurrent() - (typeIndex == 1 ? amount : -amount);
                if (newCurrent < 0) newCurrent = 0;
                Saving updatedSaving(s.getId(), s.getName(), s.getPriority(), s.getDueDate(), s.getTarget(), newCurrent, s.getCategoryId());
                DatabaseManager::instance().savingDAO()->update(linkedSavingId, updatedSaving);
                break;
            }
        }
    }

    DatabaseManager::instance().transactionDAO()->remove(id);
    DatabaseManager::instance().triggerDataChanged();
    loadTransactions();
}

bool TransactionsController::exportToCSV(const QString& filePath)
{
    return DatabaseManager::instance().transactionDAO()->exportToCSV(filePath);
}