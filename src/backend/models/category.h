#ifndef CATEGORY_H
#define CATEGORY_H

#include <QString>

class Category {
private:
    int id;
    int parentId;
    QString name;        // Tên danh mục (Ăn uống, Học phí...)
    bool active;         // Trạng thái (Active = true, Inactive = false)

public:
    Category();

    // Hàm khởi tạo cho backend (có id, parentId, name, active)
    Category(int n_id, int n_parentid, const QString& n_name, bool n_active = true);
    // Hàm khởi tạo cho frontend (parentId, name, active)
    Category(int n_parentid, const QString& n_name, bool n_active = true);

    // Getters
    int getId() const { return id; }
    int getParentId() const { return parentId; }
    QString getName() const { return name; }
    bool isActive() const { return active; }

    // Setters
    void setParentId(int newParentId) { parentId = newParentId; }
    void setActive(bool newActive) { active = newActive; }

    static QString parentCategoryName(int parentId);
};

#endif // CATEGORY_H