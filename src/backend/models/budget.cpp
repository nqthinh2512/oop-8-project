#include "budget.h"

Budget::Budget(): categoryName(""), limitAmount(0), currentSpent(0){}

Budget::Budget(const QString& n_name, double n_limit, double n_spent)
    : categoryName(n_name), limitAmount(n_limit), currentSpent(n_spent){}