#include "transaction_factory.h"

Transaction* TransactionFactory::createTransaction(int typeIndex, int id, const QString& title, double amount, const QDateTime& dt, const QString& method, int categoryId, int linkedBillId, int linkedSavingId) {
    if (typeIndex == 0) { // Income
        return new Income(id, title, amount, dt, method, categoryId, linkedBillId, linkedSavingId);
    } else { // Expense
        return new Expense(id, title, amount, dt, method, categoryId, linkedBillId, linkedSavingId);
    }
}
