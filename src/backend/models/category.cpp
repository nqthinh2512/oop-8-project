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