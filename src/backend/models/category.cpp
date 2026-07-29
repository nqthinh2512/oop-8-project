#include "category.h"

Category::Category():
    id(0),
    parentId(0),
    name(""),
    active(true) {}

Category::Category(int n_id, int n_parentid, const QString& n_name, bool n_active):
    id(n_id),
    parentId(n_parentid),
    name(n_name),
    active(n_active) {}

Category::Category(int n_parentid, const QString& n_name, bool n_active):
    id(0),
    parentId(n_parentid),
    name(n_name),
    active(n_active) {}

QString Category::parentCategoryName(int parentId) {
    switch (parentId) {
        case 1: return "Income";
        case 2: return "Expense";
        case 3: return "Bill";
        case 4: return "Budget";
        case 5: return "Saving";
        default: return "Unknown";
    }
}