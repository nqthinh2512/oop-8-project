#include "bill.h"

Bill::Bill():
    id(0),
    name(""),
    amount(0),
    dueDate(QDate::currentDate()),
    categoryId(0),
    isPaid(false) {}

Bill::Bill(int n_id, const QString &n_name, double n_amount, const QDate &n_dueDate,int n_categoryid, bool n_isPaid):
    id(n_id),
    name(n_name),
    amount(n_amount),
    dueDate(n_dueDate),
    categoryId(n_categoryid),
    isPaid(n_isPaid) {}