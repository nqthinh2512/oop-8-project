#pragma once
#include <QString>
#include <QDate>
class Saving
{
private:
    int id;
    int categoryId;
    QString name;
    double targetAmount;
    double currentAmount;
    QDate dueDate;
public:
    static const int parentCategory = 5; // Danh mục cha, tất cả categoryId của class này là con của danh mục này
    // 5 sẽ là số chỉ định cho danh mục cha này
    Saving();
    Saving(int n_id, const QString& n_name, const QDate& n_dueDate, double n_target, double n_current=0.0, int n_categoryid=0);
    //ngoại trừ hàm getter và setter thì các hàm khác không được viết logic của nó trực tiếp ở đây, đi qua .cpp để viết đi.
    //getter
    int getId() const {return id;}
    int getCategoryId() const {return categoryId;}
    QString getName() const {return name;}
    double getTarget() const {return targetAmount;}
    double getCurrent() const{return currentAmount;}
    QDate getDueDate() const {return dueDate;}
    //setter, để tránh lỗi đè cùng ID, đừng viết hàm setId.
    void setCategoryId(int n_categoryId);
    void setName(const QString& n_name);
    void setTarget(double n_target);
    void setDueDate(const QDate& n_dueDate);

    // Nghiệp vụ - logic viết trong saving.cpp
    void contribute(double amount);      // Góp tiền vào hũ
    double getProgressPercent() const;   // % đã đạt so với mục tiêu (0-100)
    double getRemainingAmount() const;   // Số tiền còn thiếu để đạt mục tiêu
    int getDaysRemaining() const;        // Số ngày còn lại tới dueDate (âm nếu quá hạn)
    bool isCompleted() const;            // Đã đạt mục tiêu hay chưa
};