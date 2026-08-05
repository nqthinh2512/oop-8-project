#ifndef CATEGORY_DAO_H
#define CATEGORY_DAO_H

#include "ibase_dao.h"
#include "../models/category.h"

class CategoryDAO : public IBaseDAO<Category> {
private:
    QVector<Category> m_categories;
    int generateNextId() const;
public:
    CategoryDAO();
    ~CategoryDAO() override = default;

    const QVector<Category>& getAll() const override;
    void add(const Category& item) override;
    bool update(int id, const Category& item) override;
    bool remove(int id) override;

    void loadFromCSV();
    void saveToCSV() const;
    bool exportToCSV(const QString& targetFilePath) const;

    void deactivate(int id);
};

#endif // CATEGORY_DAO_H
