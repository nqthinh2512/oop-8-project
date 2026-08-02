#include "saving.h"
#include <algorithm>

Saving::Saving()
    : id(0), categoryId(parentCategory), priority(Priority::Medium), name(""), targetAmount(0.0), currentAmount(0.0), dueDate(QDate())
{
}

Saving::Saving(int n_id, const QString& n_name, Priority n_priority, const QDate& n_dueDate, double n_target, double n_current, int n_categoryid)
    : id(n_id),
    categoryId(n_categoryid == 0 ? parentCategory : n_categoryid),
    priority(n_priority),
    name(n_name),
    targetAmount(n_target),
    currentAmount(n_current),
    dueDate(n_dueDate)
{
}

void Saving::setCategoryId(int n_categoryId)
{
    categoryId = n_categoryId;
}

void Saving::setPriority(Priority n_priority)
{
    priority = n_priority;
}

void Saving::setName(const QString& n_name)
{
    name = n_name;
}

void Saving::setTarget(double n_target)
{
    if (n_target < 0)
        return;
    targetAmount = n_target;
}

void Saving::setCurrent(double n_current)
{
    if (n_current < 0)
        return;
    currentAmount = n_current;
}

void Saving::setDueDate(const QDate& n_dueDate)
{
    dueDate = n_dueDate;
}

void Saving::contribute(double amount)
{
    if (amount <= 0)
        return;
    currentAmount += amount;
    if (currentAmount > targetAmount)
        currentAmount = targetAmount; // không cho vượt quá số tiền mục tiêu
}

double Saving::getProgressPercent() const
{
    if (targetAmount <= 0)
        return 0.0;
    double percent = (currentAmount / targetAmount) * 100.0;
    return std::min(percent, 100.0);
}

double Saving::getRemainingAmount() const
{
    double remaining = targetAmount - currentAmount;
    return remaining > 0 ? remaining : 0.0;
}

int Saving::getDaysRemaining() const
{
    QDate today = QDate::currentDate();
    return today.daysTo(dueDate); // âm nếu đã quá hạn
}

bool Saving::isCompleted() const
{
    return currentAmount >= targetAmount;
}
