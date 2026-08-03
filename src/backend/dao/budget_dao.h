#ifndef BUDGET_DAO_H
#define BUDGET_DAO_H

#include "ibase_dao.h"
#include "../models/budget.h"

class BudgetDAO : public IBaseDAO<Budget> {
private:
    QVector<Budget> m_budgets;
    int generateNextId() const;
public:
    BudgetDAO();
    ~BudgetDAO() override = default;

    const QVector<Budget>& getAll() const override;
    void add(const Budget& item) override;
    bool update(int id, const Budget& item) override;
    bool remove(int id) override;

    void loadFromCSV();
    void saveToCSV() const;
    bool exportToCSV(const QString& targetFilePath) const;
    
    void addExpenseToBudget(int categoryId, double amount);
};

#endif // BUDGET_DAO_H
