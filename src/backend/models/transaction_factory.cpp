#include "transaction_factory.h"

Transaction* TransactionFactory::createTransaction(int typeIndex, int id, double amount, const QDateTime& dt, const QString& note, int categoryId) {
    if (typeIndex == 0) { // Income
        return new Income(id, amount, dt, note, categoryId);
    } else { // Expense or Transfer (which acts as expense in base logic)
        return new Expense(id, amount, dt, note, categoryId);
    }
}
