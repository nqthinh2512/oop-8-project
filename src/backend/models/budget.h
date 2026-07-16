#ifndef BUDGET_H
#define BUDGET_H

#include <QString>
#include <QDate>

class Budget {
private:
    int id;
    int categoryId;         // Danh mục ID, nhớ đây sẽ là danh mục con của parentCategory
    QString name;           // tên ngân sách
    double limitAmount;     // Hạn mức tối đa (Ví dụ: Tối đa 3 triệu cho ăn uống)
    double currentSpent;    // Số tiền thực tế đã tiêu trong tháng đó
    QDate startDate;
    QDate endDate;
public:
    static const int parentCategory = 4; // Danh mục cha, tất cả categoryId của class này là con của danh mục này
    // 4 sẽ là số chỉ định cho danh mục cha này

    Budget();
    Budget(int n_id, const QString& n_name,double n_limit, const QDate& n_start, const QDate& n_end, int n_categoryid=0, double n_spent=0);
    //ngoại trừ hàm getter và setter thì các hàm khác không được viết logic của nó trực tiếp ở đây, đi qua .cpp để viết đi.

    //getter
    int getId() const {return id;}
    int getCategoryId() const {return categoryId;}
    QString getName() const {return name;}
    double getLimit() const {return limitAmount;}
    double getSpent() const{return currentSpent;}
    QDate getStartDate() const {return startDate;}
    QDate getEndDate() const {return endDate;}

    //setter, để tránh lỗi đè cùng ID, đừng viết hàm setId.
};

#endif // BUDGET_H