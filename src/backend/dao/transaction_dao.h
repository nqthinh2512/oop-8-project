#ifndef TRANSACTION_DAO_H
#define TRANSACTION_DAO_H

#include "ibase_dao.h"
#include "../models/transaction.h"

class TransactionDAO : public IBaseDAO<Transaction*> {
private:
    QVector<Transaction*> m_transactions;
    int generateNextId() const;
public:
    TransactionDAO();
    ~TransactionDAO() override;

    const QVector<Transaction*>& getAll() const override;
    void add(Transaction* const& item) override;
    bool update(int id, Transaction* const& item) override;
    bool remove(int id) override;

    void loadFromCSV();
    void saveToCSV() const;
    bool exportToCSV(const QString& targetFilePath) const;
};

#endif // TRANSACTION_DAO_H
