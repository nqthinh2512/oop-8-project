#ifndef CATEGORY_H
#define CATEGORY_H

#include <QString>

struct Category {
    int id;
    QString name;           // Tên danh mục (Ăn uống, Học phí...)
    QString iconPath;       // Đường dẫn tới ảnh icon (nếu có)
};

#endif // CATEGORY_H