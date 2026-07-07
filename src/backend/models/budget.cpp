#include "budget.h"

Budget::Budget():
    id(0),
    categoryId(0),
    name(""),
    limitAmount(0),
    currentSpent(0),
    startDate(QDate::currentDate()),
    endDate(QDate::currentDate()) {}

Budget::Budget(int n_id, const QString& n_name, double n_limit, const QDate& n_start, const QDate& n_end, int n_categoryid, double n_spent):
    id(n_id),
    name(n_name),
    categoryId(n_id),
    limitAmount(n_limit),
    currentSpent(n_spent),
    startDate(n_start),
    endDate(n_end) {}