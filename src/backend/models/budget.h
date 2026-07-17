#pragma once
#include <QString>
#include <QDate>

// Mức độ ưu tiên của ngân sách - dùng enum class để tránh xung đột tên
enum class Priority {
    Low,
    Medium,
    High
};

// Trạng thái ngân sách dựa theo % đã tiêu - dùng để đổi màu bên frontend
enum class BudgetStatus {
    Safe,       // tiêu ít (vd < 50%)
    Warning,    // tiêu vừa (vd 50-80%)
    Danger,     // sắp hết (vd 80-100%)
    Over        // đã vượt ngân sách (>100%)
};

class Budget
{
private:
    int id;
    QString name;
    Priority priority;
    int categoryId;
    double limitAmount;   // số tiền giới hạn (mục tiêu ngân sách)
    double spentAmount;   // số tiền đã tiêu
    QDate startDate;
    QDate endDate;

public:
    Budget();
    Budget(int n_id, const QString& n_name, Priority n_priority, int n_categoryId,
           double n_limit, const QDate& n_startDate, const QDate& n_endDate, double n_spent = 0.0);

    int getId() const { return id; }
    QString getName() const { return name; }
    Priority getPriority() const { return priority; }
    int getCategoryId() const { return categoryId; }
    double getLimit() const { return limitAmount; }
    double getSpent() const { return spentAmount; }
    QDate getStartDate() const { return startDate; }
    QDate getEndDate() const { return endDate; }

    void setName(const QString& n_name);
    void setPriority(Priority n_priority);
    void setCategoryId(int n_categoryId);
    void setLimit(double n_limit);
    void setStartDate(const QDate& n_startDate);
    void setEndDate(const QDate& n_endDate);

    // Nghiệp vụ - logic viết trong budget.cpp
    void addExpense(double amount);            // ghi nhận 1 khoản chi vào ngân sách
    double getProgressPercent() const;          // % đã tiêu so với limit (có thể >100%)
    double getRemainingAmount() const;          // số tiền còn được phép tiêu (0 nếu đã vượt)
    int getDaysRemaining() const;               // số ngày còn lại tới endDate (âm nếu quá hạn)
    bool isOverBudget() const;                  // đã tiêu vượt limit chưa
    BudgetStatus getStatus() const;             // trạng thái để frontend map ra màu sắc
    QString getPriorityLabel() const;           // "Thấp"/"Trung bình"/"Cao" - hiển thị UI
};