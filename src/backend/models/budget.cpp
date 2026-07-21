#include "budget.h"
#include <algorithm>

Budget::Budget()
    : id(0), name(""), priority(Priority::Medium), categoryId(0),
    limitAmount(0.0), spentAmount(0.0), startDate(QDate()), endDate(QDate())
{
}

Budget::Budget(int n_id, const QString& n_name, Priority n_priority, int n_categoryId,
               double n_limit, const QDate& n_startDate, const QDate& n_endDate, double n_spent)
    : id(n_id), name(n_name), priority(n_priority), categoryId(n_categoryId),
    limitAmount(n_limit), spentAmount(n_spent), startDate(n_startDate), endDate(n_endDate)
{
}

void Budget::setName(const QString& n_name)
{
    name = n_name;
}

void Budget::setPriority(Priority n_priority)
{
    priority = n_priority;
}

void Budget::setCategoryId(int n_categoryId)
{
    categoryId = n_categoryId;
}

void Budget::setLimit(double n_limit)
{
    if (n_limit < 0)
        return; // không cho limit âm
    limitAmount = n_limit;
}

void Budget::setStartDate(const QDate& n_startDate)
{
    startDate = n_startDate;
}

void Budget::setEndDate(const QDate& n_endDate)
{
    endDate = n_endDate;
}

// Ghi nhận thêm 1 khoản chi tiêu vào ngân sách này
// (hàm này sẽ được gọi khi có 1 Transaction mới thuộc category của budget)
void Budget::addExpense(double amount)
{
    if (amount <= 0)
        return;
    spentAmount += amount;
    // Cố tình KHÔNG chặn spentAmount vượt limitAmount ở đây,
    // vì thực tế người dùng có thể tiêu vượt ngân sách -> cần biết để cảnh báo (Over)
}

// % đã tiêu so với giới hạn. Có thể vượt 100% để phản ánh đúng thực tế đã chi vượt mức.
double Budget::getProgressPercent() const
{
    if (limitAmount <= 0)
        return 0.0;
    return (spentAmount / limitAmount) * 100.0;
}

// Số tiền còn được phép tiêu, không trả về số âm
double Budget::getRemainingAmount() const
{
    double remaining = limitAmount - spentAmount;
    return remaining > 0 ? remaining : 0.0;
}

// Số ngày còn lại của ngân sách (âm nếu đã hết hạn)
int Budget::getDaysRemaining() const
{
    QDate today = QDate::currentDate();
    return today.daysTo(endDate);
}

bool Budget::isOverBudget() const
{
    return spentAmount > limitAmount;
}

// Map % đã tiêu -> trạng thái màu sắc cho frontend
// Ngưỡng có thể chỉnh lại tuỳ ý (đang để 50% / 80% / 100%)
BudgetStatus Budget::getStatus() const
{
    double percent = getProgressPercent();
    if (percent >= 100.0)
        return BudgetStatus::Over;
    else if (percent >= 80.0)
        return BudgetStatus::Danger;
    else if (percent >= 50.0)
        return BudgetStatus::Warning;
    else
        return BudgetStatus::Safe;
}

QString Budget::getPriorityLabel() const
{
    switch (priority) {
    case Priority::High:   return "Cao";
    case Priority::Medium: return "Trung bình";
    case Priority::Low:    return "Thấp";
    }
    return "Trung bình";
}
