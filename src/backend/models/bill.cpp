#include "bill.h"

Bill::Bill():
    id(0),
    name(""),
    amount(0),
    dueDate(QDate::currentDate()),
    paidDate(QDate(0, 0, 0)),
    categoryId(0),
    isPaid(false) {}

Bill::Bill(int n_id, const QString &n_name, double n_amount, const QDate &n_dueDate, const QDate &n_paidDate, int n_categoryid, bool n_isPaid):
    id(n_id),
    name(n_name),
    amount(n_amount),
    dueDate(n_dueDate),
    paidDate(n_paidDate),
    categoryId(n_categoryid),
    isPaid(n_isPaid) {}

void Bill::setName(const QString& n_name)
{
    name = n_name;
}

void Bill::setCategoryId(int n_categoryId)
{
    categoryId = n_categoryId;
}

void Bill::setAmount(double n_amount)
{
    amount = n_amount;
}

void Bill::setDueDate(const QDate& n_dueDate)
{
    dueDate = n_dueDate;
}

void Bill::markAsPaid(QDate n_paidDate)
{
    isPaid = true;
    paidDate = n_paidDate;
}

int Bill::getDaysUntilDue()
{
    return QDate::currentDate().daysTo(dueDate);
}

bool Bill::isOverdue()
{
    if (!checkPaid() && getDaysUntilDue() <= 0) return true;
    return false;
}