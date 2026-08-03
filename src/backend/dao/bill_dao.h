#ifndef BILL_DAO_H
#define BILL_DAO_H

#include "ibase_dao.h"
#include "../models/bill.h"

class BillDAO : public IBaseDAO<Bill> {
private:
    QVector<Bill> m_bills;
    int generateNextId() const;
public:
    BillDAO();
    ~BillDAO() override = default;

    const QVector<Bill>& getAll() const override;
    void add(const Bill& item) override;
    bool update(int id, const Bill& item) override;
    bool remove(int id) override;

    void loadFromCSV();
    void saveToCSV() const;
    bool exportToCSV(const QString& targetFilePath) const;
};

#endif // BILL_DAO_H
