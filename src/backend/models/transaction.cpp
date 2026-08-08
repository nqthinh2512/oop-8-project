#include "transaction.h"

Transaction::Transaction():
    id(0),
    title(""),
    amount(0),
    categoryId(0),
    dateTime(QDateTime::currentDateTime()),
    method(""),
    linkedBillId(-1),
    linkedSavingId(-1),
    linkedBudgetId(-1) {}

Transaction::Transaction(int n_id, const QString& n_title, double n_amount, const QDateTime& n_date, const QString& n_method, int n_categoryid, int n_linkedBillId, int n_linkedSavingId, int n_linkedBudgetId):
    id(n_id),
    title(n_title),
    amount(n_amount),
    categoryId(n_categoryid),
    dateTime(n_date),
    method(n_method),
    linkedBillId(n_linkedBillId),
    linkedSavingId(n_linkedSavingId),
    linkedBudgetId(n_linkedBudgetId) {}

Income::Income(int n_id, const QString& n_title, double n_amount, const QDateTime& n_date, const QString& n_method, int n_categoryid, int n_linkedBillId, int n_linkedSavingId, int n_linkedBudgetId):
    Transaction(n_id, n_title, n_amount, n_date, n_method, n_categoryid, n_linkedBillId, n_linkedSavingId, n_linkedBudgetId) {}

double Income::getSignedAmount() const {
    return getAmount(); // Thu nhập là tiền dương
}

Expense::Expense(int n_id, const QString& n_title, double n_amount, const QDateTime& n_date, const QString& n_method, int n_categoryid, int n_linkedBillId, int n_linkedSavingId, int n_linkedBudgetId):
    Transaction(n_id, n_title, n_amount, n_date, n_method, n_categoryid, n_linkedBillId, n_linkedSavingId, n_linkedBudgetId) {}

double Expense::getSignedAmount() const {
    return -getAmount(); // Chi tiêu là tiền âm
}