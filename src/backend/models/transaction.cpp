#include "transaction.h"

Transaction::Transaction():
    id(0),
    title(""),
    amount(0),
    categoryId(0),
    dateTime(QDateTime::currentDateTime()),
    method("") {}

Transaction::Transaction(int n_id, const QString& n_title, double n_amount, const QDateTime& n_date, const QString& n_method, int n_categoryid):
    id(n_id),
    title(n_title),
    amount(n_amount),
    categoryId(n_categoryid),
    dateTime(n_date),
    method(n_method) {}

Income::Income(int n_id, const QString& n_title, double n_amount, const QDateTime& n_date, const QString& n_method, int n_categoryid):
    Transaction(n_id, n_title, n_amount, n_date, n_method, n_categoryid) {}

double Income::getSignedAmount() const {
    return getAmount(); // Thu nhập là tiền dương
}

Expense::Expense(int n_id, const QString& n_title, double n_amount, const QDateTime& n_date, const QString& n_method, int n_categoryid):
    Transaction(n_id, n_title, n_amount, n_date, n_method, n_categoryid) {}

double Expense::getSignedAmount() const {
    return -getAmount(); // Chi tiêu là tiền âm
}