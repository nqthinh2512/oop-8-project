#include "transactions_controller.h"
#include "../../backend/storage/database_manager.h"
#include <algorithm>

TransactionsController::TransactionsController(QObject *parent) : QObject(parent) {
}

QVector<Transaction*> TransactionsController::getAllTransactions() const {
    return DatabaseManager::instance().getAllTransactions();
}

QVector<Transaction*> TransactionsController::getFilteredTransactions(const QString& keyword, int categoryId, const QDate& startDate, const QDate& endDate) const {
    QVector<Transaction*> allTx = DatabaseManager::instance().getAllTransactions();
    QVector<Transaction*> filtered;

    for (Transaction* tx : allTx) {
        // 1. Lọc theo Category
        if (categoryId != -1 && tx->getCategoryId() != categoryId) {
            continue;
        }

        // 2. Lọc theo Ngày (Date Range)
        QDate txDate = tx->getDateTime().date();
        if (startDate.isValid() && txDate < startDate) continue;
        if (endDate.isValid() && txDate > endDate) continue;

        // 3. Lọc theo Keyword (tìm kiếm trong Description hoặc Account)
        if (!keyword.isEmpty()) {
            bool matchDesc = tx->getDescription().contains(keyword, Qt::CaseInsensitive);
            bool matchAcc = tx->getAccount().contains(keyword, Qt::CaseInsensitive);
            if (!matchDesc && !matchAcc) continue;
        }

        filtered.append(tx);
    }
    
    // Yêu cầu của Leader: Các giao dịch được gom theo thời gian giao dịch
    // -> Sắp xếp theo thời gian giảm dần (mới nhất lên đầu)
    std::sort(filtered.begin(), filtered.end(), [](Transaction* a, Transaction* b) {
        return a->getDateTime() > b->getDateTime();
    });

    return filtered;
}

void TransactionsController::addTransaction(const QString& type, double amount, const QDateTime& dateTime, int categoryId, const QString& description, const QString& account) {
    int newId = DatabaseManager::instance().generateNextTransactionId();
    Transaction* newTx = nullptr;
    
    if (type == "Income") {
        newTx = new Income(newId, amount, dateTime, description, categoryId, account);
    } else {
        newTx = new Expense(newId, amount, dateTime, description, categoryId, account);
    }
    
    DatabaseManager::instance().addTransaction(newTx);
}

bool TransactionsController::updateTransaction(int id, double amount, const QDateTime& dateTime, int categoryId, const QString& description, const QString& account) {
    return DatabaseManager::instance().updateTransaction(id, amount, dateTime, categoryId, description, account);
}

bool TransactionsController::deleteTransaction(int id) {
    return DatabaseManager::instance().deleteTransaction(id);
}

QVector<Category> TransactionsController::getCategories() const {
    return DatabaseManager::instance().getAllCategories();
}

QString TransactionsController::getCategoryName(int categoryId) const {
    const auto& categories = getCategories();
    for (const Category& cat : categories) {
        if (cat.getId() == categoryId) return cat.getName();
    }
    return "Unknown";
}