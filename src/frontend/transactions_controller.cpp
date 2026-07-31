#include "transactions_controller.h"
#include <QDebug>
#include <QDate>
#include <QLocale>
#include <QDateTime>

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
        int typeIndex = 1; 
        if (dynamic_cast<const Income*>(t) != nullptr) typeIndex = 0;
        QString note = t->getNote();
        if (note.startsWith("[TYPE:")) {
            int closeIdx = note.indexOf("]");
            if (closeIdx != -1) {
                typeIndex = note.mid(6, closeIdx - 6).toInt();
            }
        }
        return typeIndex;
    }
    case TitleRole: {
        QString note = t->getNote();
        if (note.startsWith("[TYPE:")) {
            int closeIdx = note.indexOf("]");
            if (closeIdx != -1) note = note.mid(closeIdx + 1);
        }
        int sepIdx = note.indexOf("||");
        if (sepIdx != -1) return note.left(sepIdx);
        return note; 
    }
    case AmountRole: {
        // Format amount with commas (e.g. 25,000,000 VND)
        QString formatted = QLocale(QLocale::English).toString(t->getAmount(), 'f', 0);
        return formatted + " VND";
    }
    case CategoryRole: {
        // Find category name by ID
        QString catName = "Unknown";
        for (const auto& cat : DatabaseManager::instance().getAllCategories()) {
            if (cat.getId() == t->getCategoryId()) {
                catName = cat.getName();
                break;
            }
        }
        // Fallback for dummy data
        if (catName == "Unknown") {
            if (t->getCategoryId() == 1) catName = "Salary";
            else if (t->getCategoryId() == 2) catName = "Freelance";
            else if (t->getCategoryId() == 5) catName = "Food & Dining";
            else if (t->getCategoryId() == 6) catName = "Housing & Rent";
            else if (t->getCategoryId() == 7) catName = "Transportation";
            else if (t->getCategoryId() == 8) catName = "Utilities";
        }
        return catName;
    }
    case AccountRole: {
        QString note = t->getNote();
        int sepIdx = note.indexOf("||");
        if (sepIdx != -1) return note.mid(sepIdx + 2);
        return "Cash/Bank"; 
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
    roles[AccountRole] = "tAcc";
    roles[DateRole] = "tDate";
    return roles;
}

void TransactionListModel::setTransactions(const QVector<Transaction*>& transactions)
{
    beginResetModel();
    m_transactions = transactions;
    endResetModel();
}

// ============================================================================
// TRANSACTIONS CONTROLLER IMPLEMENTATION
// ============================================================================

TransactionsController::TransactionsController(QObject *parent)
    : QObject(parent),
      m_model(new TransactionListModel(this)),
      m_filterType(-1),
      m_searchKeyword("")
{
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

void TransactionsController::loadTransactions()
{
    applyFilter();
}

void TransactionsController::applyFilter()
{
    const QVector<Transaction*>& all = DatabaseManager::instance().getAllTransactions();
    QVector<Transaction*> filtered;

    QString searchLower = m_searchKeyword.toLower();

    for (Transaction* t : all) {
        if (!t) continue;

        // 1. Filter by Type
        int tType = 1;
        if (dynamic_cast<const Income*>(t) != nullptr) tType = 0;
        QString note = t->getNote();
        if (note.startsWith("[TYPE:")) {
            int closeIdx = note.indexOf("]");
            if (closeIdx != -1) tType = note.mid(6, closeIdx - 6).toInt();
        }

        if (m_filterType != -1 && m_filterType != tType) {
            continue; // Skip if type doesn't match and we are not showing 'All'
        }

        // 2. Filter by Keyword (Title/Note)
        if (!searchLower.isEmpty()) {
            if (!t->getNote().toLower().contains(searchLower)) {
                // Should also check category name here, but keeping it simple for now
                continue;
            }
        }

        filtered.append(t);
    }

    m_model->setTransactions(filtered);
}

void TransactionsController::addTransaction(int typeIndex, const QString& title, double amount, const QString& dateStr, int categoryId, const QString& account)
{
    // Parse date (DD/MM/YYYY)
    QDateTime dt = QDateTime::currentDateTime();
    QDate d = QDate::fromString(dateStr, "dd/MM/yyyy");
    if (d.isValid()) {
        dt.setDate(d);
    }

    int maxId = 0;
    for (const auto* t : DatabaseManager::instance().getAllTransactions()) {
        if (t && t->getId() > maxId) maxId = t->getId();
    }
    int id = maxId + 1;

    QString fullNote = QString("[TYPE:%1]%2||%3").arg(typeIndex).arg(title).arg(account.isEmpty() ? "Cash/Bank" : account);

    Transaction* newTx = nullptr;
    if (typeIndex == 0) { // Income
        newTx = new Income(id, amount, dt, fullNote, categoryId);
    } else { // Expense or Transfer
        newTx = new Expense(id, amount, dt, fullNote, categoryId);
    }

    DatabaseManager::instance().addTransaction(newTx);
    loadTransactions(); // Reload from DB and apply filters
}

void TransactionsController::updateTransaction(int id, int typeIndex, const QString& title, double amount, const QString& dateStr, int categoryId, const QString& account)
{
    // Parse date
    QDateTime dt = QDateTime::currentDateTime();
    QDate d = QDate::fromString(dateStr, "dd/MM/yyyy");
    if (d.isValid()) {
        dt.setDate(d);
    }

    QString fullNote = QString("[TYPE:%1]%2||%3").arg(typeIndex).arg(title).arg(account.isEmpty() ? "Cash/Bank" : account);

    Transaction* newTx = nullptr;
    if (typeIndex == 0) {
        newTx = new Income(id, amount, dt, fullNote, categoryId);
    } else {
        newTx = new Expense(id, amount, dt, fullNote, categoryId);
    }

    DatabaseManager::instance().updateTransaction(id, newTx);
    loadTransactions();
}

void TransactionsController::deleteTransaction(int id)
{
    DatabaseManager::instance().deleteTransaction(id);
    loadTransactions();
}