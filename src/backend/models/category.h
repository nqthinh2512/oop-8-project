#ifndef CATEGORY_H
#define CATEGORY_H

#include <QString>

class Category {
private:
    int id;
    int parentId;
    QString name;        // Tên danh mục (Ăn uống, Học phí...)
public:
    Category();

    //hàm cho backend
    Category(int n_id, int n_parentid, const QString& n_name);
    //hàm cho frontend
    Category(int n_parentid, const QString& n_name);
    //ngoại trừ hàm getter và setter thì các hàm khác không được viết logic của nó trực tiếp ở đây, đi qua .cpp để viết đi.

    //getter
    int getId() const {return id;}
    int getParentId() const {return parentId;}
    QString getName() const {return name;}

    //setter, để tránh lỗi đè cùng ID, đừng viết hàm setId ở đây.
    void setParentId(int newParentId) { parentId = newParentId; }

    static QString parentCategoryName(int parentId);

};

#endif // CATEGORY_H