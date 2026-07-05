#ifndef BUDGET_H
#define BUDGET_H

#include <QString>

class Budget {
private:
    QString categoryName;   // Tên danh mục áp hạn mức
    double limitAmount;     // Hạn mức tối đa (Ví dụ: Tối đa 3 triệu cho ăn uống)
    double currentSpent;    // Số tiền thực tế đã tiêu trong tháng đó
public:
    Budget();
    Budget(const QString& n_name, double n_limit, double n_spent);
    //đừng viết trực tiếp logic cho các hàm ở đây, đi qua .cpp để viết đi.
};

#endif // BUDGET_H