#include "bill.h"

Bill::Bill(): id(0), billName(""), amount(0), dueDate(QDate::currentDate()), isPaid(false){}

Bill::Bill(int n_id, const QString &n_billName, double n_amount, const QDate &n_dueDate, bool n_isPaid)
    :id(n_id), billName(n_billName), amount(n_amount), dueDate{n_dueDate}, isPaid(n_isPaid){}