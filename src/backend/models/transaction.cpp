#include "transaction.h"

Transaction::Transaction():
    id(0),
    amount(0),
    categoryId(0),
    dateTime(QDateTime::currentDateTime()),
    description(""),
    account("") {}

Transaction::Transaction(int n_id, double n_amount, const QDateTime& n_date, const QString& n_desc, int n_categoryid, const QString& n_account):
    id(n_id),
    amount(n_amount),
    categoryId(n_categoryid),
    dateTime(n_date),
    description(n_desc),
    account(n_account) {}

Income::Income(int n_id, double n_amount, const QDateTime& n_date, const QString& n_desc, int n_categoryid, const QString& n_account):
    Transaction(n_id, n_amount, n_date, n_desc, n_categoryid, n_account) {}

Expense::Expense(int n_id, double n_amount, const QDateTime& n_date, const QString& n_desc, int n_categoryid, const QString& n_account):
    Transaction(n_id, n_amount, n_date, n_desc, n_categoryid, n_account) {}