#include "category.h"

Category::Category():
    id(0),
    parentId(0),
    name("") {}

Category::Category(int n_id, int n_parentid, const QString& n_name):
    id(n_id),
    parentId(n_parentid),
    name(n_name) {}

Category::Category(int n_parentid, const QString& n_name):
    id(0),
    parentId(n_parentid),
    name(n_name) {}

QString Category::parentCategoryName(int parentId){
    switch(parentId){
        case 1: return "Income";
        case 2: return "Expense";
        case 3: return "Bill";
        case 4: return "Budget";
        case 5: return "Saving";
        default: return "Unknown";
    }
}