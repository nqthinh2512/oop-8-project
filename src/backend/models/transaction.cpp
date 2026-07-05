#include "transaction.h"

Transaction::Transaction(): id(0), amount(0), type(""), categoryName(""), dateTime(QDateTime::currentDateTime()), note(""){}

Transaction::Transaction(int n_id, double n_amount, const QString& n_type, const QString& n_name, const QDateTime& n_date, const QString& n_note)
    : id(n_id), amount(n_amount), type(n_type), categoryName(n_name), dateTime(n_date), note(n_note){}