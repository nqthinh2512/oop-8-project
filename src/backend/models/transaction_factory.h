#ifndef TRANSACTION_FACTORY_H
#define TRANSACTION_FACTORY_H

#include "transaction.h"
#include <QString>
#include <QDateTime>

class TransactionFactory {
public:
    // Factory method to create Transaction objects
    // typeIndex: 0 for Income, 1 for Expense
    static Transaction* createTransaction(int typeIndex, int id, const QString& title, double amount, const QDateTime& dt, const QString& method, int categoryId, int linkedBillId = -1, int linkedSavingId = -1);
};

#endif // TRANSACTION_FACTORY_H
