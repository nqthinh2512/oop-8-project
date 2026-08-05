#ifndef SAVING_DAO_H
#define SAVING_DAO_H

#include "ibase_dao.h"
#include "../models/saving.h"

class SavingDAO : public IBaseDAO<Saving> {
private:
    QVector<Saving> m_savings;
    int generateNextId() const;
public:
    SavingDAO();
    ~SavingDAO() override = default;

    const QVector<Saving>& getAll() const override;
    void add(const Saving& item) override;
    bool update(int id, const Saving& item) override;
    bool remove(int id) override;

    void loadFromCSV();
    void saveToCSV() const;
    bool exportToCSV(const QString& targetFilePath) const;
    
    bool contributeToSaving(int savingId, double amount);
};

#endif // SAVING_DAO_H
