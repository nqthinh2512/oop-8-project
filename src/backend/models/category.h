#ifndef CATEGORY_H
#define CATEGORY_H

#include <QString>

class Category {
private:
    int id;
    QString name;           // Tên danh mục (Ăn uống, Học phí...)
    QString iconPath;       // Đường dẫn tới ảnh icon (nếu có)
public:
    Category();
    Category(int n_id, const QString& n_name, const QString& n_path = "");
    //đừng viết trực tiếp logic cho các hàm ở đây, đi qua .cpp để viết đi.
};

#endif // CATEGORY_H