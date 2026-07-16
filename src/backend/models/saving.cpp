#include "saving.h"

Saving::Saving():
    id(0),
    categoryId(0),
    name(""),
    targetAmount(0),
    currentAmount(0),
    dueDate(QDate::currentDate()) {}

Saving::Saving(int n_id, const QString& n_name, const QDate& n_dueDate, double n_target, double n_current, int n_categoryid):
    id(n_id),
    categoryId(n_categoryid),
    name(n_name),
    targetAmount(n_target),
    currentAmount(n_current),
    dueDate(n_dueDate) {}
