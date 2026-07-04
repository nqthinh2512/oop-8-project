#ifndef BUDGET_H
#define BUDGET_H

#include <QString>

struct Budget {
    QString categoryName;   // Tên danh mục áp hạn mức
    double limitAmount;     // Hạn mức tối đa (Ví dụ: Tối đa 3 triệu cho ăn uống)
    double currentSpent;    // Số tiền thực tế đã tiêu trong tháng đó
};

#endif // BUDGET_H