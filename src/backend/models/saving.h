#pragma once
#include <QString>
#include <QDate>
#include "budget.h"

class Saving
{
private:
    int id;
    int categoryId;
    Priority priority;
    QString name;
    double targetAmount;
    double currentAmount;
    QDate dueDate;

public:
    static const int parentCategory = 5; // Danh mục cha, tất cả categoryId của class này là con của danh mục này

    Saving();
    Saving(int n_id, const QString& n_name, Priority n_priority, const QDate& n_dueDate, double n_target, double n_current=0.0, int n_categoryid=0);

    int getId() const {return id;}
    int getCategoryId() const {return categoryId;}
    Priority getPriority() const {return priority;}
    QString getName() const {return name;}
    double getTarget() const {return targetAmount;}
    double getCurrent() const {return currentAmount;}
    QDate getDueDate() const {return dueDate;}

    void setCategoryId(int n_categoryId);
    void setPriority(Priority n_priority);
    void setName(const QString& n_name);
    void setTarget(double n_target);
    void setCurrent(double n_current);
    void setDueDate(const QDate& n_dueDate);

    // Nghiệp vụ - logic viết trong saving.cpp
    void contribute(double amount);      // Góp tiền vào hũ
    double getProgressPercent() const;   // % đã đạt so với mục tiêu (0-100)
    double getRemainingAmount() const;   // Số tiền còn thiếu để đạt mục tiêu
    int getDaysRemaining() const;        // Số ngày còn lại tới dueDate (âm nếu quá hạn)
    bool isCompleted() const;            // Đã đạt mục tiêu hay chưa
};