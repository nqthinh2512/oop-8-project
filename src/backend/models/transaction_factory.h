#ifndef TRANSACTION_FACTORY_H
#define TRANSACTION_FACTORY_H

#include "transaction.h"
#include <QString>
#include <QDateTime>

class TransactionFactory {
public:
    // Factory method to create Transaction objects
    // typeIndex: 0 for Income, 1 for Expense, 2 for Transfer (mapped to Expense for now)
    static Transaction* createTransaction(int typeIndex, int id, double amount, const QDateTime& dt, const QString& note, int categoryId);
};

#endif // TRANSACTION_FACTORY_H
