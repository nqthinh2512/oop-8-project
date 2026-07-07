#include "transaction.h"

Transaction::Transaction():
    id(0),
    amount(0),
    categoryId(0),
    dateTime(QDateTime::currentDateTime()),
    note("") {}

Transaction::Transaction(int n_id, double n_amount, const QDateTime& n_date, const QString& n_note, int n_categoryid):
    id(n_id),
    amount(n_amount),
    categoryId(n_categoryid),
    dateTime(n_date),
    note(n_note) {}

Income::Income(int n_id, double n_amount, const QDateTime& n_date, const QString& n_note, int n_categoryid):
    Transaction(n_id,n_amount,n_date,n_note,n_categoryid) {}

Expense::Expense(int n_id, double n_amount, const QDateTime& n_date, const QString& n_note, int n_categoryid):
    Transaction(n_id,n_amount,n_date,n_note,n_categoryid) {}